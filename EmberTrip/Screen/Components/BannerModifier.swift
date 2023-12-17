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
                            VStack(alignment: .leading) {
                                Text(messageType.title)
                                    .bold()
                                    .font(.title3)
                                Text(messageType.body)
                            }
                            .foregroundStyle(.white)
                            Spacer()
                        }
                        .padding()
                        .background(.red)
                        .cornerRadius(15)
                        Spacer()
                    }
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

enum BannerMessage {
    case NetworkError, MoreInfo
    
    var title: String {
        switch self {
        case .NetworkError:
            return "Network Error"
        case .MoreInfo:
            return "Offline Mode Enable"
        }
    }
    
    var body: LocalizedStringKey {
        switch self {
        case .NetworkError:
            return "Please check your internet connection and try again later."
        case .MoreInfo:
            return "The Bus Map Offline Mode enables users to access bus routes and information without an internet connection.\n**However, it may not provide accurate information.**"
        }
    }
    
    var duration: Double {
        switch self {
        case .NetworkError:
            return 2.5
        case .MoreInfo:
            return 10
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
