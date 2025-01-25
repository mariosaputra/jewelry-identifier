//
//  ContentView.swift
//  JewelryIdentifier
//
//  Created by Mario Saputra on 2024/02/27.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        
        TabView {
            
            Group {
                
                IdentifyScreen()
                    .tabItem {
                        VStack {
                            Image(systemName: "apple.meditate")
                            Text("Identify").padding(.top, 2) // Add padding to adjust space
                        }
                    }
                    .tag(1)
                
            }
            
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(.navbar, for: .tabBar)
            .toolbarColorScheme(.dark, for: .tabBar)
            
        }
    }
    
}

#Preview {
    ContentView()
}
