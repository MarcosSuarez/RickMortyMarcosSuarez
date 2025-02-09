//
//  FilterAndSearchView.swift
//  RickMortyMarcosSuarez
//
//  Created by Marcos Suarez Ayala on 17/4/24.
//

import SwiftUI

struct FilterAndSearchView: View {
    
    @Binding var searchText: String
    @Binding var showDetail: Bool
    var showFilterFill: Bool = false
    
    var body: some View {
        HStack(alignment: .center) {
            HStack {
                TextField("Search by name", text: $searchText)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .padding(.leading)
                
                Spacer()
                
                Image(systemName: "text.magnifyingglass")
                    .foregroundColor(.secondary)
                    .padding(.trailing, 8)
            }
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 12.0)
                    .fill(.gray.tertiary)
                    .stroke(.secondary)
            )
            
            filterButton
        }
        .font(.headline)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }

    private var filterButton: some View {
        Button {
            showDetail.toggle()
        } label: {
            Image(systemName: "line.3.horizontal.decrease.circle" + "\(showFilterFill ? ".fill" : "")")
                .font(.title)
                .foregroundColor(showFilterFill ? .green : .secondary)
        }
    }
}

#Preview {
    VStack {
        FilterAndSearchView(
            searchText: .constant(""),
            showDetail: .constant(true),
            showFilterFill: false)
        
        FilterAndSearchView(
            searchText: .constant("Hellloooo..."),
            showDetail: .constant(true),
            showFilterFill: true)
    }
}
