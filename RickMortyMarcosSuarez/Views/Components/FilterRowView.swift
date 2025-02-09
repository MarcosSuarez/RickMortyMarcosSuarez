//
//  FilterRowView.swift
//  RickMortyMarcosSuarez
//
//  Created by Marcos Suarez Ayala on 18/4/24.
//

import SwiftUI

struct FilterRowView: View {
    
    var title: String? = nil
    var items: [String] = []
    @Binding var selectedItem: String
    var backgroundColor:(selected: Color, unSelected: Color) = (.green, .gray.opacity(0.2))
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let title {
                Text(title)
                    .padding(.leading)
            }
            ScrollView(.horizontal) {
                HStack(spacing: 4) {
                    ForEach(getItems(), id: \.self) { item in
                        Text(item.capitalized)
                            .font(.callout)
                            .frame(minWidth: 45)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 10)
                            .background(getBackgroundColor(item: item))
                            .foregroundColor(item == selectedItem ? .white : .secondary)
                            .cornerRadius(16)
                            .onTapGesture {
                                if selectedItem == item {
                                    selectedItem = ""
                                } else {
                                    selectedItem = item
                                }
                            }
                    }
                }
                .padding(.horizontal)
            }
            .scrollIndicators(.hidden)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func getItems() -> [String] {
        items.filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    }
    
    private func getBackgroundColor(item: String) -> Color {
        item == selectedItem ? backgroundColor.selected : backgroundColor.unSelected
    }
}

#Preview {
    // Xcode 16
    // @Previewable @State var selectedItem = "K"
    struct PreviewWrapper: View {
        @State var selectedItem = "☠️"
        private let items = [" ", "🕘", "\n", " 🫸🏼 🫷🏽 ", "😎", "☠️", "", "👤", "   ", "👥"]
        private let backgroundColors:(Color, Color) = (.red, .green.opacity(0.4))
        
        var body: some View {
            VStack {
                FilterRowView(title: "Select One:",
                              items: items,
                              selectedItem: $selectedItem,
                              backgroundColor: backgroundColors)
                
                FilterRowView(title: "Gender By:",
                              items: (Gender.allCases.compactMap{ $0.rawValue }),
                              selectedItem: .constant(Gender.unknown.rawValue))
            }
        }
    }
    return PreviewWrapper()
}
