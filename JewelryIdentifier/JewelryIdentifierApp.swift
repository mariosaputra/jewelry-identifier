import SwiftUI
import SwiftData
import RevenueCat
import FirebaseCore
import StableID

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct JewelryIdentifierApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
     init() {
         
         Purchases.configure(withAPIKey: "appl_LjtIvOAdgjMMWqFCoEUDUcfevuf")
         Purchases.shared.attribution.enableAdServicesAttributionTokenCollection()
         
         StableID.configure()
         setRevenueCatUserID()

     }
    
    var body: some Scene {
        WindowGroup {
            SplashScreen()
                .accentColor(.fontTitle)
                .modelContainer(for: [JewelryInfo.self])
        }
        
    }
    
    func setRevenueCatUserID() {
        Purchases.shared.logIn(StableID.id) { (customerInfo, created, error) in
            if let error = error {
                print("Error logging in to RevenueCat: \(error.localizedDescription)")
            } else {
                print("Successfully logged in to RevenueCat with user ID: \(StableID.id))")
            }
        }
    }
}
