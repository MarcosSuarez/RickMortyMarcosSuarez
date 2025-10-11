//
//  CharacterListView.swift
//  RickMortyMarcosSuarez
//
//  Created by Marcos Suarez Ayala on 9/2/25.
//

import SwiftUI

struct CharacterListView: View {
    
    var isLoading: Bool
    var characters: [CharacterInfo]
    var isLastLoadFinished: Bool
    var nextLoad: () async -> Void
    
    var body: some View {
        List {
            ForEach(Array(characters.enumerated()), id: \.offset) { index, character in
                NavigationLink(value: character) {
                    VStack {
                        CharacterListCell(
                            urlString: character.image,
                            name: character.name,
                            gender: character.gender.rawValue,
                            specie: character.species
                        )
                        .padding(8)
                        
                        if index == characters.endIndex - 1, isLoading {
                            Divider()
                            LoadingCellView()
                                .padding()
                        }
                    }
                    .task {
                        if isLastLoadFinished {
                            await rulesViewToAnticipateNextLoad(index: index)
                        }
                    }
                }
            }
        }
    }
    
    private func rulesViewToAnticipateNextLoad(index: Int) async {
        let reloadAtIndex = Double(index) * 100 / Double(characters.endIndex)
        
        if reloadAtIndex > 80.0 {
            await nextLoad()
        }
    }
}

#Preview {
    CharacterListView(isLoading: false,
                      characters: [],
                      isLastLoadFinished: true,
                      nextLoad: {} )
}
