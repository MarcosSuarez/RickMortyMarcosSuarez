//
//  CharactersListViewModel.swift
//  RickMortyMarcosSuarez
//
//  Created by Marcos Suarez Ayala on 17/4/24.
//

import Foundation

final class CharactersListViewModel: ObservableObject {
    
    @Published var characters: [CharacterInfo] = []
    @Published var isLoading: Bool = false
    
    private let useCase: GetListCharacterUseCase
    private var currentPage: Int = 1
    private var loadMorePages: Bool = true
    
    init(useCase: GetListCharacterUseCase = DefaultGetListCharacterUseCase()) {
        self.useCase = useCase
    }
    
    func loadCharacters() async {
        loadMorePages = !useCase.isLastPage
        
        guard !isLoading && loadMorePages else { return }
        
        await MainActor.run {
            isLoading = true
        }

        do {
            //try await Task.sleep(nanoseconds: 2_000_000_000)
            let newCharacters = try await useCase.getCharacterList(pageNumber: "\(currentPage)")
            
            await MainActor.run {
                characters += newCharacters
                currentPage += 1
                isLoading = false
            }
        } catch {
            await MainActor.run {
                isLoading = false
            }
        }
    }
}
