//
//  FilterRowView.swift
//  RickMortyMarcosSuarez
//
//  Created by Marcos Suarez Ayala on 18/4/24.
//

import SwiftUI

struct FilterRowView: View {
    
    var title: String? = nil
    var categories:[String] = []
    var onSelectedItem: ((String) -> Void)? = nil
    
    @State private var selectedItem: String = ""
    
    init(title: String? = nil, categories:[String], onSelectedItem: ((String)->Void)?) {
        self.title = title
        self.onSelectedItem = onSelectedItem
        self.categories = categories
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            if let title {
                Text(title)
            }
            ScrollView(.horizontal) {
                HStack {
                    ForEach(categories, id: \.self) { category in
                        Text(category.capitalized)
                            .font(.callout)
                            .frame(minWidth: 30)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 10)
                            .background(isSelected(category) ? .green : .gray.opacity(0.2))
                            .foregroundColor(isSelected(category) ? .white : .secondary)
                            .cornerRadius(16)
                            .onTapGesture {
                                if selectedItem == category {
                                    selectedItem = ""
                                } else {
                                    selectedItem = category
                                }
                                onSelectedItem?(selectedItem)
                            }
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func isSelected(_ category: String) -> Bool {
        category == selectedItem
    }
}

#Preview {
    FilterRowView(title: "Gender By:", categories: Gender.allCases.compactMap{$0.rawValue}) { selection in
    }
    .padding()
}
