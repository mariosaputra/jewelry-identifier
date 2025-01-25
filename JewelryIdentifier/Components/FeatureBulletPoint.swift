//
//  FeatureBulletPoint.swift
//  JewelryIdentifier
//
//  Created by Mario Saputra on 2024/07/23.
//

import SwiftUI

struct FeatureBulletPoint: View {
    var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.navbar)
            Text(text)
                .fontWeight(.medium)
                .foregroundColor(.fontTitle)
        }
    }
}

#Preview {
    FeatureBulletPoint(text: "Sample feature text")
}
