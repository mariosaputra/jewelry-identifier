import SwiftUI
import GoogleGenerativeAI
import SwiftData
import RevenueCatUI

struct TranslateObjectScreen: View {
    
    @State private var inputImage: UIImage?
    @State private var isLoading = false
    @State private var showActionSheet = false
    @State private var showingImagePicker = false
    @State private var detectedText: String = ""
    @State private var translationResult = "Translated text appears here"
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var showingLanguagePicker = false
    @State private var isShowingPaywall = false
    
    @StateObject private var userViewModel = UserViewModel()

    @Environment(\.modelContext) var modelContext

    @AppStorage("selectedLanguageObject") private var selectedLanguage: String = "English"
    @AppStorage("nativeLanguage") private var nativeLanguage: String = "English"
    @AppStorage("translateObjectCount") var translateObjectCount:Int = 0

    private let languages = ["English", "Spanish", "French", "German", "Italian"]

    @Query var histories: [History]
    
    
    private let languageFlags = [
        "Arabic": "🇸🇦", "Bengali": "🇧🇩", "Bulgarian": "🇧🇬",
        "Chinese (Simplified)": "🇨🇳", "Chinese (Traditional)": "🇭🇰",
        "Croatian": "🇭🇷", "Czech": "🇨🇿", "Danish": "🇩🇰",
        "Dutch": "🇳🇱", "English": "🇬🇧", "Estonian": "🇪🇪",
        "Finnish": "🇫🇮", "French": "🇫🇷", "German": "🇩🇪",
        "Greek": "🇬🇷", "Hebrew": "🇮🇱", "Hindi": "🇮🇳",
        "Hungarian": "🇭🇺", "Indonesian": "🇮🇩", "Italian": "🇮🇹",
        "Japanese": "🇯🇵", "Korean": "🇰🇷", "Latvian": "🇱🇻",
        "Lithuanian": "🇱🇹", "Norwegian": "🇳🇴", "Polish": "🇵🇱",
        "Portuguese": "🇵🇹", "Romanian": "🇷🇴", "Russian": "🇷🇺",
        "Serbian": "🇷🇸", "Slovak": "🇸🇰", "Slovenian": "🇸🇮",
        "Spanish": "🇪🇸", "Swahili": "🇹🇿", "Swedish": "🇸🇪",
        "Thai": "🇹🇭", "Turkish": "🇹🇷", "Ukrainian": "🇺🇦",
        "Vietnamese": "🇻🇳"
    ]


    var body: some View {
        
        NavigationStack {
                            
                VStack(spacing: 20) {
                    
                    HStack {
                        
                        Text("To :")
                            .font(.subheadline)
                        
                        Button(action: {
                            showingLanguagePicker = true
                        }) {
                            HStack {
                                Text("\(flagForSelectedLanguage()) \(selectedLanguage)") // Display flag and language
                                    .foregroundColor(Color("Color2"))
                                Image(systemName: "chevron.down")
                            }
                        }
                        .disabled(isLoading)
                        Spacer()
                        
                    }
                    
                    
                    ZStack {
                        
                        // Background for the entire ZStack
                        Color("Color1") // Unified background color
                            .edgesIgnoringSafeArea(.all) // Make background extend to the edges

                        VStack {
                            
                            
                            if let inputImage = inputImage {
                                Image(uiImage: inputImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                            else {
                                
                                Rectangle()
                                    .fill(Color("Color1")) // Match the solid color
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .overlay(
                                        Image(systemName: "camera.metering.unknown")
                                            .resizable()
                                            .frame(width: 120, height: 100)
                                            .foregroundColor(Color("AccentColor"))
                                    )
                                    .cornerRadius(20)
                            }
                            
                            HStack(spacing: 20) {
                                Button(action: {
                                    showActionSheet = true
                                }) {
                                    HStack {
                                        Image(systemName: "camera")
                                            .font(.title2)
                                        Text("Take Picture")
                                    }
                                }
                                .disabled(isLoading)
                                .foregroundColor(Color("Color2"))
                                .actionSheet(isPresented: $showActionSheet) {
                                    ActionSheet(title: Text("Select Image"), buttons: [
                                        .default(Text("Camera")) {
                                            self.sourceType = .camera
                                            self.showingImagePicker = true
                                        },
                                        .default(Text("Photo Library")) {
                                            self.sourceType = .photoLibrary
                                            self.showingImagePicker = true
                                        },
                                        .cancel()
                                    ])
                                }
                                .sheet(isPresented: $showingImagePicker, onDismiss: uploadImage) {
                                    ImagePicker(image: self.$inputImage, sourceType: self.sourceType)
                                }


                                Button(action: {
                                    inputImage = nil
                                    detectedText = ""
                                }) {
                                    HStack {
                                        Image(systemName: "eraser.line.dashed")
                                            .font(.title2) // Adjust the font size as needed
                                        Text("Clear")
                                    }
                                }
                                .disabled(isLoading)
                                .foregroundColor(Color("Color2"))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)

                        }
                            .padding()
                    }

                        .cornerRadius(20)
                    
                    BottomTranslateView(translatedText: $detectedText, selectedLanguage: $selectedLanguage, isLoading: $isLoading)

                }
                .sheet(isPresented: $isShowingPaywall, onDismiss: {userViewModel.checkPremiumStatus()}) {
                    PaywallView(displayCloseButton: true)
                }
                .sheet(isPresented: $showingLanguagePicker) {
                    LanguagePickerView(selectedLanguage: $selectedLanguage)
                }
                .padding(20)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
            .navigationTitle("Translate Object")
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color("Color2"), for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
    
    // Function to upload and process the image
    func uploadImage() {
        
        userViewModel.checkPremiumStatus()
        
        if (!userViewModel.isPremium) {
            if (translateObjectCount >= 1) {
                isShowingPaywall = true
                return
            }
        }
        
        guard let inputImage = inputImage else { return }
        
        isLoading = true

        Task {
            do {
                
                let config = GenerationConfig(
                  temperature: 0
                )
                
                let model = GenerativeModel(name: "gemini-pro-vision", apiKey: APIKey.default, generationConfig: config)
                
                let prompt = """
list all objects detected in this image with this format:
object name in \(nativeLanguage) = object name in \(selectedLanguage) (object'spronounciation in alphabet)
"""
                
                let response = try await model.generateContent(prompt, inputImage)
                
                if let text = response.text {
                    
                    self.detectedText = text
                    
                    if (!userViewModel.isPremium) {
                        translateObjectCount += 1
                    }
                }
            } catch {
                print("Error generating content: \(error)")
                self.detectedText = "Failed to translate."

            }
            
            isLoading = false
            
            // Convert UIImage to Data
            if let imageData = inputImage.jpegData(compressionQuality: 1.0) {
                saveHistory(with: imageData, with: detectedText)
            }
        }

    }
    
    private func saveHistory(with imageData: Data, with translation: String) {
        
        let history = History(photo: imageData, translation: translation, timestamp: Date())
        modelContext.insert(history)
        try? modelContext.save()
    }
    
    private func flagForSelectedLanguage() -> String {
        return languageFlags[selectedLanguage] ?? ""
    }

}

// Preview Provider
struct TranslateObjectScreen_Previews: PreviewProvider {
    static var previews: some View {
        TranslateObjectScreen()
    }
}

