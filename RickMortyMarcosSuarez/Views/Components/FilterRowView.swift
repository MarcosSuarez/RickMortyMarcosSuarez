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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let title {
                Text(title)
                    .padding(.leading)
            }
            ScrollView(.horizontal) {
                HStack(spacing: 4) {
                    ForEach(items, id: \.self) { item in
                        Text(item.capitalized)
                            .font(.callout)
                            .frame(minWidth: 30)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 10)
                            .background(item == selectedItem ? .green : .gray.opacity(0.2))
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
}

#Preview {
    FilterRowView(title: "Gender By:",
                  items: (Gender.allCases.compactMap{ $0.rawValue }),
                  selectedItem: .constant(Gender.unknown.rawValue)
    )
}
