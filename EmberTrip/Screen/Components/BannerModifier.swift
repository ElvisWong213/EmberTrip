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
    func body(content: Content) -> some View {
        ZStack {
            content
            VStack {
                if showBanner {
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Network Error")
                                    .bold()
                                Text("Please check your internet connection and try again later.")
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
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            self.showBanner = false
                        }
                    }
                }
            }
            .animation(.easeInOut, value: showBanner)

        }
    }
}

extension View {
    func banner(showBanner: Binding<Bool>) -> some View {
        self.modifier(BannerModifier(showBanner: showBanner))
    }
}

#if DEBUG
private struct MyPreview: View {
    @State var show = false
    var body: some View {
        VStack {
            Button {
                show = true
            } label: {
                Text("Button")
            }
        }
        .modifier(BannerModifier(showBanner: $show))
    }
}

#Preview {
    MyPreview()
}
#endif
