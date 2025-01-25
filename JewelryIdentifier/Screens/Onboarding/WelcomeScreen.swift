import SwiftUI
import Lottie

struct WelcomeScreen: View {
    @State private var navigateToNextScreen = false
    @State private var progress: CGFloat = 0.0
    
    var body: some View {
        ZStack {


            if navigateToNextScreen {
                ReviewRequestScreen()
            } else {
               
                ScrollView {
                    
                    
                    VStack(spacing: 15) {
                                                
                        Image("TopImage")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .clipped()
                        
                        VStack(spacing: 10) {
                            
                            TitleView()
                            
                            // Increased the width of the Lottie animation
                            LottieView(animationFileName: "fashion-jewelry", loopMode: .loop)
                                .frame(width: 400, height: 200)
                                .padding(.bottom, 20)
                            
                            Spacer()
                            
                            Button(action: {
                                navigateToNextScreen = true
                            }) {
                                HStack {
                                    Text("Get Started")
                                        .fontWeight(.semibold)
                
                                }
                                // Increased horizontal padding for a wider button
                                .frame(width: 200)
                                .padding(.horizontal, 50)
                                .padding(.vertical, 20)
                                .background(.navbar)
                                .foregroundColor(.black)
                                .cornerRadius(25)
                                .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 3)
                            }
                            
                            Spacer()

                        }
                        .padding(.horizontal, 20)
                    }
                }
                .edgesIgnoringSafeArea(.top)
            }
        }
        .animation(.easeInOut, value: navigateToNextScreen)
    }
}

struct WelcomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeScreen()
    }
}
