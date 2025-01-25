//
//  LanguagePickerView.swift
//  JewelryIdentifier
//
//  Created by Mario Saputra on 2024/03/03.
//

import SwiftUI

struct LanguagePickerView: View {
    @Binding var selectedLanguage: String
    var languages: [String] = ["English", "Spanish", "French", "German", "Italian", "Portuguese", "Russian", "Chinese", "Japanese", "Korean"]
    @State private var searchText = ""

    var filteredLanguages: [String] {
        if searchText.isEmpty {
            return languages
        } else {
            return languages.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
    }

    var body: some View {
        NavigationView {
            List(filteredLanguages, id: \.self) { language in
                Button(language) {
                    self.selectedLanguage = language
                }
                .padding()
            }
            .navigationTitle("Select Language")
            .searchable(text: $searchText, prompt: "Search languages")
        }
    }
}
