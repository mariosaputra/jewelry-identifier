//
//  SettingScreen.swift
//  JewelryIdentifier
//
//  Created by Mario Saputra on 2024/03/02.
//

import SwiftUI
import StoreKit
import MessageUI
import RevenueCat
import RevenueCatUI

struct SettingScreen: View {

    @Environment(\.modelContext) private var context
    @Environment(\.requestReview) var requestReview
    
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false
    
    @State private var showingLanguagePicker:Bool = false
    @State private var showingPrivacyPolicy = false
    @State private var showingTermsOfService = false
    @State private var showingContactForm = false
    @State private var showPurchaseSheet = false
    @State private var showSupportSheet = false
    
    @StateObject var purchaseModel: PurchaseModel = PurchaseModel()

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                List {
                    
                    Section(header: Text("App").font(.headline).foregroundColor(.color1)) {

                        Button(action: {
    
                            Task {
                                await purchaseModel.updateCustomerProductStatus()
                                if !purchaseModel.isSubscribed {
                                    showPurchaseSheet = true
                                }
                                else {
                                }
                            }
    
                        })
                        {
                            HStack {
                                Image(systemName: "gift.fill")
                                Text("Upgrade to Premium")
                            }
                        }

                        
                        Button(action: {
                            if let url = URL(string: "https://apps.apple.com/app/id6740074022?action=write-review") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            HStack {
                                Image(systemName: "star.fill")
                                Text("Rate the app")
                            }
                        }
                        
                    }
                
                    
                    Section(header: Text("Support").font(.headline).foregroundColor(.color1)) {

                        
                        if (MFMailComposeViewController.canSendMail()) {
                            
                            Button(action: {
                                self.isShowingMailView.toggle()
                            }) {
                                
                                HStack {
                                    
                                    Image(systemName: "envelope")
                                    Text("Email Developer")

                                }
                            }
                            .sheet(isPresented: $isShowingMailView) {
                                MailView(result: self.$result, 
                                        toRecipients: ["support@marioapps.com"],
                                        subject: "Jewelry Identifier Support")
                            }
                            
                        } else {
                            
                            Button(action: {
                                showingContactForm = true
                            }) {
                                
                                HStack {
                                    Image(systemName: "doc")
                                    Text("Contact Developer")
                                }
                            }
                            
                        }

                        
                        Button(action: {
                            showingPrivacyPolicy = true
                        }) {
                            
                            HStack {
                                Image(systemName: "doc")
                                Text("Privacy Policy")
                            }
                        }
                        
                        Button(action: {
                            showingTermsOfService = true
                        }) {
                            
                            HStack {
                                Image(systemName: "doc")
                                Text("Term of Services")
                            }
                        }
                        
                    }
                    
                    Section(header: Text("Info").font(.headline).foregroundColor(.color1)) {
                        
                        

                        HStack {
                            Image(systemName: "person")
                            Text("User ID: \(Purchases.shared.appUserID)")
                                .lineLimit(1)
                                .truncationMode(.middle)
                            Button(action: {
                                UIPasteboard.general.string = Purchases.shared.appUserID
                            }) {
                                Image(systemName: "doc.on.doc")
                                    .foregroundColor(.blue)
                            }
                        }
                    
                        HStack {
                            Image(systemName: "v.square")
                            Text("App Version: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown")")
                        }
                        
                        

    
                    }
                    
//                    Section(header: Text("More Apps You'll Love").font(.headline).foregroundColor(.navbar)) {
//                        ForEach(myApps, id: \.id) { app in
//                            Button(action: {
//                                if let url = URL(string: app.appStoreUrl) {
//                                    UIApplication.shared.open(url)
//                                }
//                            }) {
//                                HStack {
//                                    Image(app.iconName)
//                                        .resizable()
//                                        .aspectRatio(contentMode: .fit)
//                                        .frame(width: 30, height: 30)
//                                        .cornerRadius(6)
//                                    Text(app.name)
//                                }
//                            }
//                        }
//                    }

                    
                }
    //            .background(Color("AccentColor"))
    //            .navigationTitle("Setting")
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarBackground(.navbar, for: .navigationBar)
                .toolbarColorScheme(.dark, for: .navigationBar)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Setting")
                            .font(.system(.title2, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(.fontTitle)
                    }
                }
                .listStyle(PlainListStyle())
                .background(Color.clear)
                
                .toolbar {
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "xmark.circle")
                                .foregroundColor(.fontTitle)
                                .imageScale(.medium)
                        }
                    }

                }
                
            }
        }
        .fullScreenCover(isPresented: $showingContactForm) {
            ContactFormView()
        }
        .fullScreenCover(isPresented: $showingPrivacyPolicy) {
            PrivacyPolicyView()
        }
        .fullScreenCover(isPresented: $showingTermsOfService) {
            TOSView()
        }
        .fullScreenCover(isPresented: $showPurchaseSheet) {
//            PurchaseView(isPresented: $showPurchaseSheet)
            if let offerings = purchaseModel.offerings,
               let promoOffering = offerings.offering(identifier: "promo") {
                PaywallView(offering: promoOffering, displayCloseButton: true)
            }
        }
    }
}

#Preview {
    SettingScreen()
}

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) var dismiss
    
    var privacyUrl: String {
        "https://marioapps.com/apps/jewelryid/privacy.html"
    }

    var body: some View {
        NavigationView {
            WebView(url: URL(string: privacyUrl)!)
                .navigationBarTitle(Text("Privacy Policy"), displayMode: .inline)
                .navigationBarItems(leading: Button("Close") {
                    dismiss()
                }
                .foregroundColor(.fontTitle))
        }
    }
}


struct TOSView: View {
    @Environment(\.dismiss) var dismiss
    
    var tosUrl: String {
        "https://marioapps.com/apps/jewelryid/tos.html"
    }

    var body: some View {
        NavigationView {
            WebView(url: URL(string: tosUrl)!)
                .navigationBarTitle(Text("Term of Services"), displayMode: .inline)
                .navigationBarItems(leading: Button("Close") {
                    dismiss()
                }
                .foregroundColor(.fontTitle))
        }
    }
}

struct ContactFormView: View {
    @Environment(\.dismiss) var dismiss
    
    var formUrl: String {
        "https://tally.so/r/w41OdX"
    }

    var body: some View {
        NavigationView {
            WebView(url: URL(string: formUrl)!)
                .navigationBarTitle(Text("Contact"), displayMode: .inline)
                .navigationBarItems(leading: Button("Close") {
                    dismiss()
                }
                .foregroundColor(.navbar))
        }
    }
}

// Define a struct to hold app information
struct MyApp: Identifiable {
    let id = UUID()
    let name: String
    let iconName: String
    let appStoreUrl: String
}

// Create an array of your apps
let myApps: [MyApp] = [
    MyApp(name: "Plant Identifier", iconName: "app1Icon", appStoreUrl: "https://apps.apple.com/app/id6504149002"),
]
