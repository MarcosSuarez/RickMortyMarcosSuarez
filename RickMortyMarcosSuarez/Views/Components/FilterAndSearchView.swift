//
//  FilterAndSearchView.swift
//  RickMortyMarcosSuarez
//
//  Created by Marcos Suarez Ayala on 17/4/24.
//

import SwiftUI

struct FilterAndSearchView: View {
    /// Closure with  ( search text , [ selected filters ] )
    var updateSearch: ((String,[String])->Void)? = nil
    
    @State private var filterPressed: Bool = false
    @State private var searchText: String = ""
    @State private var speciesSelected: String = ""
    @State private var genderSelected: String = ""
    @State private var statusSelected: String = ""
    
    var body: some View {
        VStack {
            headerView
            if filterPressed {
                filtersView
                    .animation(.easeIn, value: filterPressed)
            }
        }
    }
    
    private var filtersView: some View {
        VStack {
            FilterRowView(title: "By Species:",
                          items: Species.allCases.compactMap{$0.rawValue},
                          selectedItem: $speciesSelected)
            .onChange(of: speciesSelected) {
                updateSearch?(searchText, createFilterString())
            }
            
            FilterRowView(title: "By Gender:",
                          items: Gender.allCases.compactMap{$0.rawValue},
                          selectedItem: $genderSelected)
            .onChange(of: genderSelected) {
                updateSearch?(searchText, createFilterString())
            }
            
            FilterRowView(title: "By Status:",
                          items: Status.allCases.compactMap{$0.rawValue},
                          selectedItem: $statusSelected)
            .onChange(of: statusSelected) {
                updateSearch?(searchText, createFilterString())
            }
        }
        .padding(.leading, 4)
    }
    
    private var headerView: some View {
        HStack(alignment: .center) {
            HStack {
                TextField("Search by name", text: $searchText)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .padding(.leading)
                    .onChange(of: searchText) {
                        updateSearch?(searchText, createFilterString())
                    }
                
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
            
            // Filter button
            Button {
                filterPressed.toggle()
            } label: {
                Image(systemName: "line.3.horizontal.decrease.circle" + "\(hasFilter ? ".fill" : "")")
                    .font(.title)
                    .foregroundColor(hasFilter ? .green : .secondary)
            }
        }
        .font(.headline)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
    
    private var hasFilter: Bool {
        !(speciesSelected.isEmpty && genderSelected.isEmpty && statusSelected.isEmpty)
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
