import Foundation
import RevenueCat

@MainActor
class PurchaseModel: ObservableObject {
    
    @Published var offerings: Offerings?
    @Published var customerInfo: CustomerInfo?
    @Published var productDetails: [PurchaseProductDetails] = []

    @Published var isSubscribed: Bool = false
    @Published var isPurchasing: Bool = false
    @Published var isFetchingProducts: Bool = false
    
    init() {
        self.productDetails = [
            PurchaseProductDetails(price: "$24.99", productId: "jewelryid_yearly", duration: "year", durationPlanName: "Premium Annual", hasTrial: false),
            PurchaseProductDetails(price: "$4.99", productId: "jewelryid_weekly", duration: "week", durationPlanName: "3-Day Trial", hasTrial: true)
        ]
        
        Task {
            await requestProducts()
            await updateCustomerProductStatus()
        }
    }
    
    func requestProducts() async {
        isFetchingProducts = true
        do {
            let offerings = try await Purchases.shared.offerings()
            self.offerings = offerings
            if let currentOffering = offerings.current,
               let weeklyPackage = currentOffering.package(identifier: "jewelryid_weekly"),
               let yearlyPackage = currentOffering.package(identifier: "jewelryid_yearly") {
                await MainActor.run {
                    self.productDetails[0].price = yearlyPackage.storeProduct.localizedPriceString
                    self.productDetails[1].price = weeklyPackage.storeProduct.localizedPriceString
                }
            }
        } catch {
            print("Failed to fetch products: \(error)")
        }
        isFetchingProducts = false
    }
    
    func purchaseSubscription(productId: String) async {
        isPurchasing = true
        defer { isPurchasing = false }
        
        do {
            // Fetch the offerings from RevenueCat
            let offerings = try await Purchases.shared.offerings()
            
            // Check if the current offering is available
            if let currentOffering = offerings.current {
//                print("Available packages:")
//                for package in currentOffering.availablePackages {
//                    print("Package Identifier: \(package.identifier)")
//                    print("Product Identifier: \(package.storeProduct.productIdentifier)")
//                    print("Price: \(package.storeProduct.price)")
//                    print("Description: \(package.storeProduct.localizedDescription)")
//                    print("---")
//                }
                
                // **Find the package by product identifier**
                guard let package = currentOffering.availablePackages.first(where: { $0.storeProduct.productIdentifier == productId }) else {
                    print("Package with product identifier \(productId) not found.")
                    return
                }
                
                // Proceed to purchase the package
                _ = try await Purchases.shared.purchase(package: package)
                await updateCustomerProductStatus()
            } else {
                print("No current offering is available.")
                return
            }
        } catch {
            print("Failed to fetch offerings or purchase product: \(error)")
        }
    }
    
    func restorePurchases() async {
        do {
            _ = try await Purchases.shared.restorePurchases()
            await updateCustomerProductStatus()
        } catch {
            print("Failed to restore purchases: \(error)")
        }
    }
    
    func updateCustomerProductStatus() async {
        do {
            let customerInfo = try await Purchases.shared.customerInfo()
            self.customerInfo = customerInfo
            isSubscribed = customerInfo.entitlements["premium"]?.isActive == true
        } catch {
            print("Failed to get customer info: \(error)")
        }
    }
}

class PurchaseProductDetails: ObservableObject, Identifiable {
    let id: UUID
    
    @Published var price: String
    @Published var productId: String
    @Published var duration: String
    @Published var durationPlanName: String
    @Published var hasTrial: Bool
    
    init(price: String = "", productId: String = "", duration: String = "", durationPlanName: String = "", hasTrial: Bool = false) {
        self.id = UUID()
        self.price = price
        self.productId = productId
        self.duration = duration
        self.durationPlanName = durationPlanName
        self.hasTrial = hasTrial
    }
}

