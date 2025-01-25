import SwiftUI

struct PurchaseView: View {
    
    @StateObject var purchaseModel: PurchaseModel = PurchaseModel()
    
    @State private var shakeDegrees = 0.0
    @State private var shakeZoom = 0.9
    @State private var showCloseButton = false
    @State private var progress: CGFloat = 0.0

    @Binding var isPresented: Bool
    
    @State var showNoneRestoredAlert: Bool = false
    @State private var showTermsActionSheet: Bool = false

    @State private var freeTrial: Bool = true
    @State private var selectedProductId: String = ""
    
    let color: Color = Color(.navbar)
    
    private let allowCloseAfter: CGFloat = 5.0 // Time in seconds until close is allowed
    
    var hasCooldown: Bool = true
    
    let placeholderProductDetails: [PurchaseProductDetails] = [
        PurchaseProductDetails(price: "24.99", productId: "jewelryid_yearly", duration: "year", durationPlanName: "Premium Annual", hasTrial: false),
        PurchaseProductDetails(price: "4.99", productId: "jewelryid_weekly", duration: "week", durationPlanName: "Premium Weekly", hasTrial: true)
    ]
    
    var callToActionText: String {
        if let selectedProductTrial = purchaseModel.productDetails.first(where: { $0.productId == selectedProductId })?.hasTrial {
            return selectedProductTrial ? "Start Free Trial" : "Unlock Now"
        } else {
            return "Unlock Now"
        }
    }
    
    var calculateFullPrice: Double? {
        if let weeklyPriceString = purchaseModel.productDetails.first(where: { $0.duration == "week" })?.price {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency

            if let number = formatter.number(from: weeklyPriceString) {
                return number.doubleValue * 52
            }
        }
        return nil
    }
    
    var calculatePercentageSaved: Int {
        if let calculateFullPrice = calculateFullPrice,
           let yearlyPriceString = purchaseModel.productDetails.first(where: { $0.duration == "year" })?.price {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency

            if let number = formatter.number(from: yearlyPriceString) {
                let yearlyPriceDouble = number.doubleValue
                let saved = Int(100 - ((yearlyPriceDouble / calculateFullPrice) * 100))
                return saved > 0 ? saved : 90
            }
        }
        return 90
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                HStack {
                    Spacer()
                    
                    if hasCooldown && !showCloseButton {
                        Circle()
                            .trim(from: 0.0, to: progress)
                            .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                            .opacity(0.1 + 0.1 * progress)
                            .rotationEffect(Angle(degrees: -90))
                            .frame(width: 20, height: 20)
                    } else {
                        Image(systemName: "multiply")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20)
                            .onTapGesture { isPresented = false }
                            .opacity(0.2)
                    }
                }
                .padding()
                
                ScrollView {
                    VStack {
                        
                        ZStack {
                            Image("purchaseview-hero")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 150)
                                .scaleEffect(shakeZoom)
                                .rotationEffect(.degrees(shakeDegrees))
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { startShaking() }
                                }
                        }
                        
                        VStack(spacing: 10) {
                            Text("Unlock Unlimited Jewelry Identification")
                                .font(.system(.title, design: .rounded))
                                .foregroundColor(.fontTitle)
                                .fontWeight(.bold)
                                .padding()
                                .multilineTextAlignment(.center)
                            VStack(alignment: .leading) {
                                PurchaseFeatureView(title: "Detailed Jewelry Information", icon: "crown.fill", color: Color.yellow)
                                PurchaseFeatureView(title: "Material and Gemstone Analysis", icon: "crown.fill", color: Color.yellow)
                                PurchaseFeatureView(title: "Accurate Value Estimation", icon: "crown.fill", color: Color.yellow)
                                PurchaseFeatureView(title: "Save Identification History", icon: "crown.fill", color: Color.yellow)
                            }
                            .font(.system(size: 15))
                            .padding()
                        }
                        
                        Spacer()
                        
                        VStack(spacing: 10) {
                            let productDetails = purchaseModel.isFetchingProducts ? placeholderProductDetails : purchaseModel.productDetails
                            
                            ForEach(productDetails) { productDetails in
                                Button(action: {
                                    withAnimation {
                                        selectedProductId = productDetails.productId
                                    }
                                    freeTrial = productDetails.hasTrial
                                }) {
                                    VStack {
                                        HStack {
                                            VStack(alignment: .leading) {
                                                Text(productDetails.durationPlanName)
                                                    .font(.headline.bold())
                                                if productDetails.hasTrial {
                                                    Text(productDetails.price + " per " + productDetails.duration)
                                                        .opacity(0.8)
                                                } else {
                                                    HStack {
                                                        if let fullPrice = calculateFullPrice,
                                                           let formattedFullPrice = toLocalCurrencyString(fullPrice),
                                                           fullPrice > 0 {
                                                            Text("\(formattedFullPrice) ")
                                                                .font(.subheadline)
                                                                .strikethrough()
                                                                .opacity(0.4)
                                                        }
                                                        Text(productDetails.price + " per " + productDetails.duration)
                                                    }
                                                    .opacity(0.8)
                                                }
                                            }
                                            Spacer()
                                            if productDetails.hasTrial {
                                                Text("")
                                                    .font(.title2.bold())
                                            } else {
                                                VStack {
                                                    Text("SAVE \(calculatePercentageSaved)%")
                                                        .font(.caption.bold())
                                                        .foregroundColor(.black)
                                                        .padding(8)
                                                }
                                                .background(Color(hex: "#FFD700"))
                                                .cornerRadius(6)
                                            }

                                            ZStack {
                                                Image(systemName: selectedProductId == productDetails.productId ? "circle.fill" : "circle")
                                                    .foregroundColor(selectedProductId == productDetails.productId ? color : Color.primary.opacity(0.15))
                                                if selectedProductId == productDetails.productId {
                                                    Image(systemName: "checkmark")
                                                        .foregroundColor(.black)
                                                        .scaleEffect(0.7)
                                                }
                                            }
                                            .font(.title3.bold())
                                        }
                                        .padding(.horizontal)
                                        .padding(.vertical, 10)
                                    }
                                    .background(
                                        selectedProductId == productDetails.productId
                                        ? Color.fontTitle.opacity(0.2) // Selected background color
                                            : Color.white // Default background color
                                    )
                                    .cornerRadius(6)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 6)
                                            .stroke(selectedProductId == productDetails.productId ? color : Color.primary.opacity(0.15), lineWidth: 1)
                                    )
                                }
                                .accentColor(Color.primary)
                            }
                            
                            HStack {
                                Toggle(isOn: $freeTrial) {
                                    Text("3-Day Free Trial")
                                        .font(.headline.bold())
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                                .onChange(of: freeTrial) { _, isFreeTrial in
                                    if !isFreeTrial, let firstProductId = purchaseModel.productDetails.first?.productId {
                                        withAnimation { selectedProductId = firstProductId }
                                    } else if isFreeTrial, let lastProductId = purchaseModel.productDetails.last?.productId {
                                        withAnimation { selectedProductId = lastProductId }
                                    }
                                }
                            }
                            .background(Color.primary.opacity(0.05))
                            .cornerRadius(6)
                        }
                        
                        VStack {
                            Button(action: {
                                if !purchaseModel.isPurchasing {
                                    Task { await purchaseModel.purchaseSubscription(productId: selectedProductId) }
                                }
                            }) {
                                HStack {
                                    Spacer()
                                    Text(callToActionText)
                                    Image(systemName: "chevron.right")
                                    Spacer()
                                }
                                .padding()
                                .foregroundColor(.black)
                                .font(.title3.bold())
                                .background(color)
                                .cornerRadius(6)
                            }
                            .opacity(purchaseModel.isPurchasing ? 0 : 1)
                            .padding()
                            
                            HStack(spacing: 5) {
                                Button("Restore") {
                                    Task {
                                        await purchaseModel.restorePurchases()
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
                                            if !purchaseModel.isSubscribed {
                                                showNoneRestoredAlert = true
                                            }
                                        }
                                    }
                                }
                                .alert(isPresented: $showNoneRestoredAlert) {
                                    Alert(title: Text("Restore Purchases"),
                                          message: Text("No purchases restored"),
                                          dismissButton: .default(Text("OK")))
                                }
                                
                                Text("•").foregroundColor(.gray)
                                
                                Button("Terms of Use") {
                                    if let url = URL(string: "https://marioapps.com/apps/jewelryid/tos.html") {
                                        UIApplication.shared.open(url)
                                    }
                                }
                                
                                Text("•").foregroundColor(.gray)
                                
                                Button("Privacy Policy") {
                                    if let url = URL(string: "https://marioapps.com/apps/jewelryid/privacy.html") {
                                        UIApplication.shared.open(url)
                                    }
                                }
                            }
                            .foregroundColor(.gray)
                            .font(.system(size: 15))
                        }
                    }
                }
                .padding(.horizontal)
            }
            .onAppear {
                selectedProductId = purchaseModel.productDetails.last?.productId ?? ""
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    withAnimation(.easeIn(duration: allowCloseAfter)) {
                        progress = 1.0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + allowCloseAfter) {
                        withAnimation { showCloseButton = true }
                    }
                }
            }
            .onChange(of: purchaseModel.isSubscribed) { _, isSubscribed in
                if isSubscribed { isPresented = false }
            }
        }
    }
    
    private func startShaking() {
        let totalDuration = 0.7
        let numberOfShakes = 3
        let initialAngle: Double = 10
        
        withAnimation(.easeInOut(duration: totalDuration / 2)) {
            shakeZoom = 0.95
            DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration / 2) {
                withAnimation(.easeInOut(duration: totalDuration / 2)) {
                    shakeZoom = 0.9
                }
            }
        }

        for i in 0..<numberOfShakes {
            let delay = (totalDuration / Double(numberOfShakes)) * Double(i)
            let angle = initialAngle - (initialAngle / Double(numberOfShakes)) * Double(i)
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(Animation.easeInOut(duration: totalDuration / Double(numberOfShakes * 2))) {
                    shakeDegrees = angle
                }
                withAnimation(Animation.easeInOut(duration: totalDuration / Double(numberOfShakes * 2)).delay(totalDuration / Double(numberOfShakes * 2))) {
                    shakeDegrees = -angle
                }
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration) {
            withAnimation { shakeDegrees = 0 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) { startShaking() }
        }
    }
    
    struct PurchaseFeatureView: View {
        let title: String
        let icon: String
        let color: Color
        
        var body: some View {
            HStack {
                Image(systemName: icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 27, height: 27)
                    .foregroundColor(color)
                Text(title)
            }
        }
    }

    func toLocalCurrencyString(_ value: Double) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: value))
    }
}
