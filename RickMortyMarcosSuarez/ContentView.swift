//
//  ContentView.swift
//  RickMortyMarcosSuarez
//
//  Created by Marcos Suarez Ayala on 16/4/24.
//

import SwiftUI

struct ContentView: View {
    private let repository = DefaultCharacterListRepository()
    @State private var lista:[CharacterInfo] = []
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                ForEach(lista) { detalle in
                    Text(detalle.name) + Text(detalle.gender.rawValue)
                }
            }
        }
        .padding()
        .task {
            do {
                let page1 = try await repository.getCharacterList(pageNumber: "2")
                lista = page1.characters
            } catch {
                print(error)
            }
            
        }
    }
}

#Preview {
    ContentView()
}
