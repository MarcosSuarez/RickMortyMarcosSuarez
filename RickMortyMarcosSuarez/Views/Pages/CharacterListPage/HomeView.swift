//
//  HomeView.swift
//  RickMortyMarcosSuarez
//
//  Created by Marcos Suarez Ayala on 17/4/24.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var viewModel = HomeViewModel()
    @State private var loadingList: Bool = true
    
    @State private var speciesSelected: String = ""
    @State private var genderSelected: String = ""
    @State private var statusSelected: String = ""
    
    @State private var filterPressed: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if loadingList {
                    loadingListView
                } else {
                    VStack {
                        FilterAndSearchView(
                            searchText: $viewModel.searchText,
                            showDetail: $filterPressed,
                            showFilterFill: viewModel.hasFilterSelected)
                        .padding(.bottom, 4)
                        
                        if filterPressed {
                            filtersView
                                .animation(.easeIn, value: filterPressed)
                        }
                        
                        CharacterListView(isLoading: viewModel.isLoading,
                                          characters: viewModel.characters,
                                          isLastLoadFinished: viewModel.isLastLoadFinished,
                                          nextLoad: viewModel.loadCharacters)
                    }
                }
            }
            .offset(y: loadingList ? -40 : 0)
            .navigationTitle("Rick & Morty")
            .navigationDestination(for: CharacterInfo.self) { character in
                CharacterDetailView(character: character)
            }
        }
        .task {
            if viewModel.isLastLoadFinished {
                await viewModel.loadCharacters()
                loadingList = false
            }
        }
       
    }
    
    private var loadingListView: some View {
        Text("Loading characters list...")
            .multilineTextAlignment(.center)
            .font(.largeTitle)
            .fontDesign(.serif)
            .frame(maxWidth: 300)
    }
    
    private var filtersView: some View {
        VStack {
            FilterRowView(title: "By Species:",
                          items: Species.allCases.compactMap{$0.rawValue},
                          selectedItem: $speciesSelected)
            .onChange(of: speciesSelected) { oldValue, newValue in
                viewModel.filters.update(with:.speciesSelected(newValue))
            }
            
            FilterRowView(title: "By Gender:",
                          items: Gender.allCases.compactMap{$0.rawValue},
                          selectedItem: $genderSelected)
            .onChange(of: genderSelected) { oldValue, newValue in
                viewModel.filters.update(with: .genderSelected(newValue))
            }
            
            FilterRowView(title: "By Status:",
                          items: Status.allCases.compactMap{$0.rawValue},
                          selectedItem: $statusSelected)
            .onChange(of: statusSelected) { oldValue, newValue in
                viewModel.filters.update(with: .statusSelected(newValue))
            }
        }
        .padding(.leading, 4)
    }
}

#Preview {
    HomeView()
        .toolbar(.visible, for: .navigationBar)
        .environmentObject(ImageLoader())
}
