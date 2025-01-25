//
//  MiscView.swift
//  JewelryIdentifier
//
//  Created by Mario Saputra on 2024/07/31.
//

import SwiftUI
import MarkdownUI

func infoSection(title: String, content: String) -> some View {
    VStack(alignment: .leading, spacing: 5) {
        Text(title).font(.headline)
        Markdown(content)
            .textSelection(.enabled)
    }
}
