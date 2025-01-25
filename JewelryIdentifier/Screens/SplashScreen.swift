//
//  SplashScreen.swift
//  Wedding Speech AI
//
//  Created by Mario Saputra on 2024/02/18.
//

import SwiftUI

struct SplashScreen: View {
    @State var isActive : Bool = false
    @State private var size = 0.8
    @State private var opacity = 0.5
   
    @AppStorage("hasFinishedOnboarding") var hasFinishedOnboarding:Bool = false

    // Customise your SplashScreen here
    var body: some View {
        if isActive {
                          
            if (!hasFinishedOnboarding) {
                WelcomeScreen()
            } else {
                IdentifyScreen()
            }
            
        } else {
            
            ZStack {
                
                Color(.navbar).edgesIgnoringSafeArea(.all)
                                
                VStack {
                    VStack {
                        //Logo
                        Image("Logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    .scaleEffect(size)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.2)) {
                            self.size = 0.9
                            self.opacity = 1.00
                        }
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        withAnimation {
                            self.isActive = true
                        }
                    }
                }
            }
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
