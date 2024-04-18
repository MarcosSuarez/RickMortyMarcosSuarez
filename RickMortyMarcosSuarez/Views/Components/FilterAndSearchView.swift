//
//  FilterAndSearchView.swift
//  RickMortyMarcosSuarez
//
//  Created by Marcos Suarez Ayala on 17/4/24.
//

import SwiftUI

struct FilterAndSearchView: View {
    
    var onChanges: ((String,[String])->Void)? = nil
    
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
            
            FilterRowView(title: "By Gender:",
                          items: Gender.allCases.compactMap{$0.rawValue},
                          selectedItem: $genderSelected)
            
            FilterRowView(title: "By Status:",
                          items: Status.allCases.compactMap{$0.rawValue},
                          selectedItem: $statusSelected)
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
            .padding(8)
    }
}
