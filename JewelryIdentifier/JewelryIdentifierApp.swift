import SwiftUI
import SwiftData
import RevenueCat

@main
struct JewelryIdentifierApp: App {
    
     init() {
         Purchases.configure(withAPIKey: "appl_LjtIvOAdgjMMWqFCoEUDUcfevuf")
     }
    
    var body: some Scene {
        WindowGroup {
            SplashScreen()
                .accentColor(.fontTitle)
                .modelContainer(for: [JewelryInfo.self])
        }
        
    }
}
