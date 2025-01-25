//
//  TitleView.swift
//  JewelryIdentifier
//
//  Created by Mario Saputra on 2024/08/09.
//

import SwiftUI

struct TitleView: View {
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 10) {
            
            Text("Jewelry Identifier")
                .font(.system(size: 38, weight: .heavy, design: .rounded))
                .foregroundColor(.fontTitle)
                .padding(20)

            
            Text("AI-Powered Jewelry Identifier App")
                .font(.system(size: 20, weight: .medium, design: .rounded))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(20)
            
            Text("Turn your phone into a jewelry expert. Snap, identify, and discover the history and value of jewelry with AI-powered analysis.")
                .font(.system(size: 16, weight: .regular, design: .rounded))
                .foregroundColor(.silver)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    TitleView()
}
