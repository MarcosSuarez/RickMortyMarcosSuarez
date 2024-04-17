//
//  LogoCharacter.swift
//  RickMortyMarcosSuarez
//
//  Created by Marcos Suarez Ayala on 17/4/24.
//

import SwiftUI

struct LogoCharacter: View {
    
    var image: UIImage? = nil
    
    var body: some View {
        ZStack {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(12)
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.background)
                    .overlay {
                        Image(systemName: "person.fill")
                            .resizable()
                            .padding(8)
                    }
            }
        }
        .frame(width: 65, height: 65)
        .shadow(radius: 5)
    }
}

#Preview {
    LogoCharacter()
}
