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
                    listCharacters
                        .environmentObject(ImageLoader())
                }
            }
            .offset(y: loadingList ? -40 : 0)
            .navigationTitle("Rick & Morty")
        }
        .task {
            await viewModel.loadCharacters()
            loadingList = false
        }
       
    }
    
    private var listCharacters: some View {
        List {
            ForEach(Array(viewModel.characters.enumerated()), id: \.offset) { index, character in
                
                CharacterListCell(
                    urlString: character.image,
                    name: character.name,
                    gender: character.gender.rawValue,
                    specie: character.species
                )
                .padding(8)
                .task {
                    let reloadAtIndex = viewModel.characters.endIndex - 5
                    if index > reloadAtIndex {
                        await viewModel.loadCharacters()
                    }
                }
                
                if index == viewModel.characters.endIndex - 1, viewModel.isLoading {
                    HStack(alignment: .center, spacing: 16) {
                        ProgressView()
                        Text("Loading more characters...")
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
    }
}

#Preview {
    CharactersListView()
        .toolbar(.visible, for: .navigationBar)
}
