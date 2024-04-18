//
//  FilterAndSearchView.swift
//  RickMortyMarcosSuarez
//
//  Created by Marcos Suarez Ayala on 17/4/24.
//

import SwiftUI

struct FilterAndSearchView: View {
    
    var onSearchPressed: ((String)->Void)? = nil
    var onFilterPressed: (([String])->Void)? = nil
    
    @State private var filterPressed: Bool = true
    @State private var searchText: String = ""
    @State private var speciesSelected: String = ""
    @State private var genderSelected: String = ""
    @State private var statusSelected: String = ""
    
    var body: some View {
        VStack {
            headerView
            if filterPressed {
                filtersView
                    .padding(.horizontal)
            }
            Text(searchText)
        }
        .animation(.bouncy, value: filterPressed)
    }
    
    private var filtersView: some View {
        VStack {
            FilterRowView(title: "By Species:", categories: Species.allCases.compactMap{$0.rawValue}) { selected in
                speciesSelected = selected
                onFilterPressed?(createFilterString())
            }
            
            FilterRowView(title: "By Gender:", categories: Gender.allCases.compactMap{$0.rawValue}) { selected in
                genderSelected = selected
                onFilterPressed?(createFilterString())
                
            }
            
            FilterRowView(title: "By Status:", categories: Status.allCases.compactMap{$0.rawValue}) { selected in
                statusSelected = selected
                onFilterPressed?(createFilterString())
            }
        }
    }
    
    private var headerView: some View {
        HStack(alignment: .center) {
            HStack {
                
                TextField(
                    "Search by name",
                    text: $searchText
                )
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .padding(.leading)
                
                Spacer()
                Button {
                    onSearchPressed?(searchText)
                } label: {
                    Image(systemName: "text.magnifyingglass")
                        .foregroundColor(.primary)
                }
                .padding(.trailing, 6)
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 25.0)
                    .fill(.gray.tertiary)
                    .stroke(.secondary)
            )
            Button {
                filterPressed.toggle()
            } label: {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .font(.title)
                    .foregroundColor(.primary)
            }
        }
        .font(.title2)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(8)
    }
    
    private func createFilterString() -> [String] {
        var response: [String] = []
        if !speciesSelected.isEmpty {
            response.append("species=\(speciesSelected.lowercased())")
        }
        if !statusSelected.isEmpty {
            response.append("status=\(statusSelected.lowercased())")
        }
        if !genderSelected.isEmpty {
            response.append("gender=\(genderSelected.lowercased())")
        }
        return response
    }
}

#Preview {
    VStack {
        FilterAndSearchView()
    }
}
