//
//  NextButton.swift
//  Wedding Speech AI
//
//  Created by Mario Saputra on 2024/02/19.
//

import SwiftUI

struct NextButton: View {
    
    var action: () -> Void
    
    var body: some View {
        
        Button(action: action) {
            Text("Start")
                .frame(minWidth: 0, maxWidth: .infinity) // Ensure text frame fills button
                .padding()
                .contentShape(Rectangle()) // Make sure the padding area is also tappable
        }
        .background(Color("AccentColor"))
        .foregroundColor(.white)
        .fontWeight(.bold)
        .cornerRadius(10)
        .padding(.horizontal)
    }
}
