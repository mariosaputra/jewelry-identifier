//
//  Camera_Translation_AIApp.swift
//  JewelryIdentifier
//
//  Created by Mario Saputra on 2024/02/27.
//

import SwiftUI
import SwiftData
import WishKit
import RevenueCat
@main
struct JewelryIdentifierApp: App {
    
    

    init() {
        
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: "appl_tfakZADmaxQmVajmrNftVlMoMgw")

        WishKit.configure(with: "054CBB32-BD11-4905-8CDE-9AA8EDC045D2")
        WishKit.theme.primaryColor = .black
        WishKit.config.buttons.addButton.bottomPadding = .large
        WishKit.config.buttons.saveButton.textColor = .set(light: .red, dark: .red)
        WishKit.config.emailField = .none
    }
    
    var body: some Scene {
        WindowGroup {
            SplashScreen()
                .modelContainer(for: [RockInfo.self])
        }
        
    }
}
