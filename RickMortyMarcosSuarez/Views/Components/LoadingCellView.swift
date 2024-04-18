//
//  LoadingCellView.swift
//  RickMortyMarcosSuarez
//
//  Created by Marcos Suarez Ayala on 18/4/24.
//

import SwiftUI

struct LoadingCellView: View {
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            ProgressView()
            Text("Loading more characters...")
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding()
    }
}

#Preview {
    LoadingCellView()
}
