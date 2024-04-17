//
//  CharacterListCell.swift
//  RickMortyMarcosSuarez
//
//  Created by Marcos Suarez Ayala on 17/4/24.
//

import SwiftUI

struct CharacterListCell: View {
    @EnvironmentObject var imageLoader: ImageLoader
    
    @State private var image: UIImage?
    var urlString: String = "https://rickandmortyapi.com/api/character/avatar/2.jpeg"
    var name: String = "Nombre personaje"
    var gender: String = "Female"
    var specie: String = "Human"
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            LogoCharacter(image: image)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(name)
                    .font(.title2)
                    .fontWeight(.semibold)
                VStack(alignment: .leading, spacing: 4) {
                    Text("*Gender*: \(gender)")
                    Text("*Specie*: \(specie)")
                }
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.trailing, 16)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .task {
            image = try? await imageLoader.image(urlString)
        }
    }
}

#Preview {
    CharacterListCell()
        .padding()
        .environmentObject(ImageLoader())
}
