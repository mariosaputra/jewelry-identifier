import SwiftUI
import RevenueCatUI
import AIProxy

struct IdentifyScreen: View {
    
    // MARK: - Properties
    @State private var inputImage: UIImage?
    @State private var isLoading = false
    @State private var showActionSheet = false
    @State private var showingImagePicker = false
    @State private var infoText: String = ""
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var jewelryInfo: JewelryInfo?
    @StateObject private var networkMonitor = NetworkMonitor()
    
    @State private var lastFetchTime: Date = Date.distantPast
    @Environment(\.scenePhase) private var scenePhase
    
    @State private var latestInfo: String?
    @State private var datePosted: String?
    @State private var isLatestInfoLoading: Bool = false
    @State private var latestInfoError: String?
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.requestReview) var requestReview
    
    @AppStorage("scanCount") var scanCount: Int = 0
    @AppStorage("hasFinishedOnboarding") var hasFinishedOnboarding: Bool = false
    
    @State private var showPurchaseSheet = false
    @State private var showSettingSheet = false

    @StateObject var purchaseModel: PurchaseModel = PurchaseModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                if networkMonitor.isConnected {
                    connectedView
                } else {
                    noConnectionView
                }
                latestInfoView
            }
            .fullScreenCover(isPresented: $showPurchaseSheet, onDismiss: {
                hasFinishedOnboarding = true
            }) {
//                PurchaseView(isPresented: $showPurchaseSheet, hasCooldown: true)
                if let offerings = purchaseModel.offerings,
                   let promoOffering = offerings.offering(identifier: "promo") {
                    PaywallView(offering: promoOffering, displayCloseButton: true)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(.navbar, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Jewelry Identifier")
                        .font(.system(.title2, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.fontTitle)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 5) {
                        NavigationLink(destination: IdentifyHistoryScreen()) {
                            Image(systemName: "clock")
                                .foregroundColor(.fontTitle)
                                .imageScale(.medium)
                        }
                        
                        Button(action: {
                            showSettingSheet = true
                        }) {
                            Image(systemName: "gearshape.fill")
                                .foregroundColor(.fontTitle)
                                .imageScale(.medium)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showSettingSheet) {
            SettingScreen()
        }
        .onAppear() {
            if (!hasFinishedOnboarding) {
                showPurchaseSheet = true
            }
        }
    }
    
    // MARK: - Subviews
    private var connectedView: some View {
        VStack {
            if networkMonitor.isConnected {
                if isLoading {
                    VStack(spacing: 20) {
                        LottieView(animationFileName: "Scanning", loopMode: .loop)
                        
                        Text("Analyzing jewelry image...")
                            .font(.system(.headline, design: .rounded))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                } else if let info = jewelryInfo {
                    JewelryInfoView(jewelryInfo: info, inputImage: inputImage, isFromHistory: false)
                    Group {
                        Button(action: resetView) {
                            HStack {
                                Image(systemName: "camera")
                                Text("Scan Another Jewelry")
                                    .font(.system(.headline, design: .rounded))
                            }
                            .foregroundColor(.fontTitle)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                    }
                } else {
                    VStack(alignment: .center) {
                        Spacer()
                        Text("Tap the camera icon to take or upload a photo of the jewelry.")
                            .font(.system(.body, design: .rounded))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.silver)
                            .padding()
                        selectImageView
                        Spacer()
                    }
                    .padding(20)
                }
            } else {
                noConnectionView
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var noConnectionView: some View {
        ContentUnavailableView {
            Label("No Internet Connection", systemImage: "wifi.exclamationmark")
                .font(.title)
                .foregroundColor(.fontTitle)
        } description: {
            Text("Please check your internet connection and try again.")
                .foregroundColor(.fontTitle)
                .font(.title)
        }
    }
    
    private func resetView() {
        inputImage = nil
        jewelryInfo = nil
        infoText = ""
    }
    
    private var selectImageView: some View {
        VStack(spacing: 20) {
            Button(action: {
                Task {
                    
                    await purchaseModel.updateCustomerProductStatus()
                    if !purchaseModel.isSubscribed {
                        showPurchaseSheet = true
                    } else {
                        showActionSheet = true
                    }
                    
                }
            }) {
                if let image = inputImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, maxHeight: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(0)
                        .ignoresSafeArea(.container, edges: .horizontal)
                } else {
                    Rectangle()
                        .frame(maxWidth: 300, maxHeight: 300)
                        .overlay(
                            Image("Identify")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(Color("AccentColor"))
                        )
                        .cornerRadius(20)
                }
            }
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
            .foregroundColor(.navbar)
            
            Text(infoText)
                .padding(10)
                .foregroundColor(.red)
                .font(.headline)
                .multilineTextAlignment(.leading)
        }
        .padding(0)
        .frame(maxWidth: .infinity)
        .sheet(isPresented: $showingImagePicker, onDismiss: uploadImage) {
            ImagePicker(image: self.$inputImage, sourceType: self.sourceType)
        }
    }
    
    private var latestInfoView: some View {
        Group {
            if let info = latestInfo, let date = datePosted, !info.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundColor(.orange)
                        .scaleEffect(1.5)
                    
                    Text(info)
                        .foregroundColor(.primary)
                        .font(.footnote)
                        .frame(width: 300)
                        .fixedSize(horizontal: true, vertical: false)

                    Text("Posted on: \(date)")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                .padding(.bottom, 20)
            }
        }
        .padding()
        .padding(.horizontal)
    }
    
    // Function to upload and process the image
    func uploadImage() {
        guard let inputImageOrig = inputImage else { return }
        guard let cgImage = inputImageOrig.cgImage?.copy() else { return }
        let inputImage = UIImage(cgImage: cgImage)
        
        isLoading = true
        
        Task {
            let openAIService = AIProxy.openAIService(
                partialKey: "v2|30d1b12c|2GrrPigjsHBsnGqr",
                serviceURL: "https://api.aiproxy.pro/85d192ac/9fa02273",
                requestFormat: .azureDeployment(apiVersion: "2024-08-01-preview")
            )
            
            guard let localURL = inputImage.openAILocalURLEncoding() else {
                throw ClassifierDataLoaderError.couldNotCreateImageURL
            }
            
            let systemMessageContent = """
            You are JewelryIdentifier App, an AI assistant created to help users identify jewelry from pictures. 
            Analyze the jewelry in the image and provide details in RAW VALID JSON FORMAT, NO MARKDOWN, NOTHING ELSE.
            Include the following keys and all keys' values must be string:
                - name: A unique or descriptive name for the jewelry (e.g., "Victorian Diamond Brooch")
                - type: Type of jewelry (e.g., ring, necklace)
                - material: Material composition (e.g., gold, silver)
                - gemstone: Type of gemstone (e.g., diamond)
                - gemstoneCarat: Weight of the gemstone in carats
                - jewelryWeight: Weight of the jewelry piece
                - origin: Country or region of origin
                - era: Historical era of the piece (e.g., Victorian)
                - estimatedValue: Approximate market value
                - designDescription: Description of the jewelry design
                - historicalSignificance: Historical or cultural significance
                - rarity: Rarity level (Common/Uncommon/Rare)
                - grading: Quality or grading of the piece
                - confidence: Confidence level of the identification (e.g., "85")
                - notes: Additional observations

            If the image is unclear or identification is not possible, provide the following JSON format:
                - error: error message
            """
            
            do {
                let response = try await openAIService.chatCompletionRequest(body: .init(
                    model: "gpt-4o",
                    messages: [
                        .system(content: .text(systemMessageContent)),
                        .user(content: .parts([.text("Here's the jewelry image"), .imageURL(localURL)]))
                    ],
                    responseFormat: .jsonObject,
                    temperature: 0.2
                ))
                
                let content = response.choices.first?.message.content ?? ""
                
                if let errorMessage = decodeErrorMessage(from: content) {
                    jewelryInfo = nil
                    infoText = errorMessage
                    isLoading = false
                    self.inputImage = nil
                } else if let data = content.data(using: .utf8) {
                    do {
//                    print("content : ", content)
                    let decodedResponse = try JSONDecoder().decode(JewelryInfo.self, from: data)
                    jewelryInfo = decodedResponse
                    isLoading = false
                    } catch {
                        infoText = "Failed to decode response: \(error.localizedDescription)"
                        jewelryInfo = nil
                        isLoading = false
                        self.inputImage = nil
                    }
                } else {
                    infoText = "System error. Please try again."
                    jewelryInfo = nil
                    isLoading = false
                    self.inputImage = nil
                }
            } catch AIProxyError.unsuccessfulRequest(let statusCode, _) {
                let error = ErrorHandler.getError(from: statusCode)
                self.infoText = ErrorHandler.getMessage(for: error)
                jewelryInfo = nil
                isLoading = false
                self.inputImage = nil
            } catch {
                self.infoText = error.localizedDescription
                jewelryInfo = nil
                isLoading = false
                self.inputImage = nil
            }
            
            isLoading = false

            if jewelryInfo != nil {
                if let imageData = inputImageOrig.jpegData(compressionQuality: 0.4) {
                    saveHistory(with: imageData, with: jewelryInfo!)
                }
                
                scanCount += 1
                if (scanCount % 3 == 0) {
                    requestReview()
                }
            }
        }
    }
    
    func decodeErrorMessage(from content: String) -> String? {
        if let data = content.data(using: .utf8),
           let errorResponse = try? JSONDecoder().decode([String: String].self, from: data),
           let errorMessage = errorResponse["error"] {
            return errorMessage
        }
        return nil
    }
    
    private func saveHistory(with imageData: Data, with jewelryInfo: JewelryInfo) {
        let history = IdentifyHistory(imageData: imageData, jewelryInfo: jewelryInfo)
        modelContext.insert(history)
        try? modelContext.save()
    }
}

struct LatestInfo: Codable {
    let info: String
    let date: String
}
