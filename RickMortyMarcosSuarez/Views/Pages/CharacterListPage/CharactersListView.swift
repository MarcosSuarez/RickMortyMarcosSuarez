//
//  CharactersListView.swift
//  RickMortyMarcosSuarez
//
//  Created by Marcos Suarez Ayala on 17/4/24.
//

import SwiftUI

struct CharactersListView: View {
    
    @StateObject var viewModel = CharactersListViewModel()
    @State private var loadingList: Bool = true
    
    var body: some View {
        NavigationStack {
            VStack {
                if loadingList {
                    Text("Loading characters list...")
                        .multilineTextAlignment(.center)
                        .font(.largeTitle)
                        .fontDesign(.serif)
                        .frame(maxWidth: 300)
                        
                } else {
                    /*
                    FilterAndSearchView { textSearch in
                        
                    } onFilterPressed: { filter in
                        
                    }
                    */
                    
                    listCharacters
                }
            }
            .offset(y: loadingList ? -40 : 0)
            .navigationTitle("Rick & Morty")
            .navigationDestination(for: CharacterInfo.self) { character in
                CharacterDetailView(character: character)
            }
        }
        .task {
            await viewModel.loadCharacters()
            loadingList = false
        }
       
    }
    
    private var listCharacters: some View {
        List {
            ForEach(Array(viewModel.characters.enumerated()), id: \.offset) { index, character in
                NavigationLink(value: character) {
                    VStack {
                        CharacterListCell(
                            urlString: character.image,
                            name: character.name,
                            gender: character.gender.rawValue,
                            specie: character.species
                        )
                        .padding(8)
                        
                        if index == viewModel.characters.endIndex - 1, viewModel.isLoading {
                            Divider()
                            LoadingCell()
                                .padding()
                        }
                        
                    }
                    .task {
                        let reloadAtIndex = viewModel.characters.endIndex - 5
                        if index > reloadAtIndex {
                            await viewModel.loadCharacters()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    CharactersListView()
        .toolbar(.visible, for: .navigationBar)
        .environmentObject(ImageLoader())
}
