//
//  CharacterDetailView.swift
//  RickMortyMarcosSuarez
//
//  Created by Marcos Suarez Ayala on 17/4/24.
//

import SwiftUI

struct CharacterDetailView: View {
    @EnvironmentObject var imageLoader: ImageLoader
    var character: CharacterInfo
    @State private var image: UIImage?
    
    var body: some View {
        VStack(spacing: 0) {
            imageHeader
            
            details
                .padding(.horizontal)
                .offset(y: -14)
        }
        .navigationTitle(character.name)
        .task {
            image = try? await imageLoader.image(character.image)
        }
    }
    
    private var imageHeader: some View {
        VStack {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .cornerRadius(25)
            } else {
                Image(systemName: "person.crop.rectangle")
                    .resizable()
                    .fontWeight(.ultraLight)
                    .foregroundStyle(.ultraThinMaterial)
            }
        }
        .scaledToFit()
        .padding(.horizontal, 20)
        .shadow(radius: 10)
    }
    
    private var details: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 16) {
                statusImage
                Divider()
                Text("*Gender*: \(character.gender.rawValue)")
                Divider()
                Text("*Specie*: \(character.species)")
                Divider()
                if !character.type.isEmpty {
                    Text("*Type*: \(character.type)")
                    Divider()
                }
                Text("*Location*: \(character.location.name)")
                Divider()
                if !listOfEpisodes.isEmpty {
                    Text("*Episodes*: \(listOfEpisodes.uppercased())")
                        .multilineTextAlignment(.leading)
                }
            }
            .font(.headline)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                    .fill(.clear)
            )
            .padding()
            .shadow(radius: 10)
        }
        .scrollIndicators(.hidden)
    }
    
    private var statusImage: some View {
        let systemName: String
        
        switch character.status {
        case .alive: systemName = "figure"
        case .dead: systemName = "figure.fall"
        case .unknown: systemName = "pawprint"
        }
        
        return HStack {
            Text("*Status*: \(character.status.rawValue)")
            
            Image(systemName: systemName)
                .resizable()
                .scaledToFit()
                .fontWeight(.ultraLight)
                .foregroundStyle(.secondary)
                .frame(maxHeight: 25)
        }
    }
    
    private var listOfEpisodes: String {
        character.episode.compactMap { URL(string: $0)?.lastPathComponent }.joined(separator: ", ")
    }
}

#Preview {
    NavigationStack {
        CharacterDetailView(
            character: CharacterInfo(
                id: 1,
                name: "Rick Sanchez",
                status: .alive,
                species: "Human",
                type: "",
                gender: .male,
                origin: Location(name: "Earth (C-137)",
                                 url: "https://rickandmortyapi.com/api/location/1"),
                location: Location(name: "Citadel of Ricks",
                                   url: "https://rickandmortyapi.com/api/location/3"),
                image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
                episode: [
                    "https://rickandmortyapi.com/api/episode/1",
                    "https://rickandmortyapi.com/api/episode/2",
                    "https://rickandmortyapi.com/api/episode/3",
                    "https://rickandmortyapi.com/api/episode/4",
                    "https://rickandmortyapi.com/api/episode/5"
                ],
                url: "https://rickandmortyapi.com/api/character/1",
                created: "2017-11-04T18:48:46.250Z"
            )
        )
        .environmentObject(ImageLoader())
    }
}
