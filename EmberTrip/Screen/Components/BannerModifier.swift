//
//  BannerModifier.swift
//  EmberTrip
//
//  Created by Elvis on 16/12/2023.
//

import Foundation
import SwiftUI

struct BannerModifier: ViewModifier {
    @Binding var showBanner: Bool
    var messageType: BannerMessage
    
    func body(content: Content) -> some View {
        ZStack {
            content
            VStack {
                if showBanner {
                    VStack {
                        HStack {
                            // Banner messages
                            VStack(alignment: .leading) {
                                Text(messageType.title)
                                    .bold()
                                    .font(.title3)
                                Text(messageType.body)
                            }
                            .foregroundStyle(.white)
                            Spacer()
                        }
                        // Banner background
                        .padding()
                        .background(messageType.color)
                        .cornerRadius(15)
                        Spacer()
                    }
                    // Banner Border
                    .padding()
                    .transition(AnyTransition.move(edge: .top))
                    .onAppear() {
                        DispatchQueue.main.asyncAfter(deadline: .now() + messageType.duration) {
                            self.showBanner = false
                        }
                    }
                    .gesture(
                        DragGesture()
                            .onChanged({ value in
                                if value.translation.height < -50 {
                                    self.showBanner = false
                                }
                            })
                    )
                }
            }
            .animation(.easeInOut, value: showBanner)

        }
    }
}


extension View {
    func banner(showBanner: Binding<Bool>, messageType: BannerMessage) -> some View {
        self.modifier(BannerModifier(showBanner: showBanner, messageType: messageType))
    }
}

#if DEBUG
private struct MyPreview: View {
    @State var show = false
    @State var messageType: BannerMessage = .NetworkError
    
    var body: some View {
        VStack {
            Button {
                show = true
                messageType = .NetworkError
            } label: {
                Text("Network")
            }
            Button {
                show = true
                messageType = .MoreInfo
            } label: {
                Text("More Information")
            }
        }
        .modifier(BannerModifier(showBanner: $show, messageType: messageType))
    }
}

#Preview {
    MyPreview()
}
#endif
