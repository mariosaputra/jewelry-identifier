import SwiftUI
import Lottie

struct Testimonial: Identifiable {
    let id = UUID()
    let text: String
    let author: String
}

struct ReviewRequestScreen: View {
    
    @State private var navigateToNextScreen = false

    @Environment(\.dismiss) private var dismiss

    @State private var progress: CGFloat = 0.0
    
    var testimonials: [Testimonial] {
        return [
            Testimonial(text: "This Jewelry Identifier app is incredible! It helped me identify a vintage necklace accurately.", author: "Emma L."),
            Testimonial(text: "The app provides such detailed information about my jewelry pieces. Highly recommend it!", author: "Noah C."),
            Testimonial(text: "I found this app very easy to use and the identification results were spot-on. Love it!", author: "Sophia R."),
            Testimonial(text: "The AI’s ability to recognize different gemstones is amazing. It even detected rare stones!", author: "Ava M."),
            Testimonial(text: "I used this app to learn more about my inherited jewelry. It’s so informative and accurate.", author: "Ethan W."),
            Testimonial(text: "The historical details provided by this app are a game-changer. It helped me discover the origins of my jewelry.", author: "Mia P."),
            Testimonial(text: "I can’t believe how fast and accurate this app is! Perfect for identifying valuable jewelry pieces.", author: "Lucas T."),
            Testimonial(text: "The app’s insights into gemstone quality and rarity are unmatched. Highly impressed!", author: "Zoe D."),
            Testimonial(text: "Using this app, I discovered the true value of my antique brooch. It's been so helpful!", author: "Alexander B."),
            Testimonial(text: "This app boosted my confidence in understanding my jewelry collection. Thanks for this amazing tool!", author: "Charlotte H."),
        ]
    }
    
    @State private var currentTestimonialIndex = 0
    @State private var timer: Timer?

    var body: some View {
        
        if (navigateToNextScreen == true) {
            IdentifyScreen()
        }
        else {
            ZStack {
                Color(.navbar).edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 20) {
                        HStack {
                            Spacer()
                            Button(action: {
                                navigateToNextScreen = true
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.black)
                                    .font(.title2)
                            }
                            .padding([.top, .trailing])
                        }
                        
                        VStack(spacing: 15) {
                            
                            Image("Logo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                            
                            Text("AI-Powered Jewelry Identifier")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)

                            Text("Your feedback helps us improve your jewelry identification journey.")
                                .font(.subheadline)
                                .foregroundColor(.silver)
                                .multilineTextAlignment(.center)
        
                            LottieView(animationFileName: "five-star-rating", loopMode: .loop)
                                .frame(width: 200, height: 100)

                            
                            Button(action: {
                                if let writeReviewURL = URL(string: "https://apps.apple.com/app/id6740074022?action=write-review") {
                                    UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
                                }
                            }) {
                                Text("Rate on App Store")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                .fontTitle,
                                                .fontTitle.opacity(0.4)
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomLeading
                                        )
                                    )
                                    .cornerRadius(15)
                                    .shadow(color: Color.silver.opacity(0.2), radius: 4, x: 0, y: 2)
                            }
                            .padding(.horizontal)

                            Divider()
                                .background(Color("Color1").opacity(0.5))
                                .padding(.vertical)
                            
                            Text("What jewelry enthusiasts are saying:")
                                .font(.headline)
                                .foregroundColor(.black)
                            
                            TestimonialCarouselView(testimonials: testimonials)
                                .frame(height: 150)
                                .padding(.horizontal)
                        }
                        .padding()
                    }
                }
            }
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            withAnimation {
                currentTestimonialIndex = (currentTestimonialIndex + 1) % testimonials.count
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

struct TestimonialView: View {
    let testimonial: Testimonial
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(testimonial.text)
                .font(.subheadline)
                .italic()
                .foregroundColor(.color1)
            Text("- \(testimonial.author)")
                .font(.caption)
                .foregroundColor(.silver)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.fontTitle.opacity(0.2))
        
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.navbar, lineWidth: 1)
        )
    }
}

struct TestimonialCarouselView: View {
    let testimonials: [Testimonial]
    @State private var currentIndex = 0
    @State private var timer: Timer?
    
    var body: some View {
        VStack {
            TabView(selection: $currentIndex) {
                ForEach(0..<testimonials.count, id: \.self) { index in
                    TestimonialView(testimonial: testimonials[index])
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .onAppear(perform: startTimer)
        .onDisappear(perform: stopTimer)
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            withAnimation {
                currentIndex = (currentIndex + 1) % testimonials.count
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

struct ReviewRequestScreen_Previews: PreviewProvider {
    static var previews: some View {
        ReviewRequestScreen()
    }
}

