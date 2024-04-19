//
//  GetListCharacterUseCase.swift
//  RickMortyMarcosSuarez
//
//  Created by Marcos Suarez Ayala on 17/4/24.
//

import Foundation

protocol GetListCharacterUseCase {
    var isLastPage: Bool { get set }
    func getCharacterList(pageNumber: Int, textSearch: String, filters: [String]) async throws -> [CharacterInfo]
}

final class DefaultGetListCharacterUseCase: GetListCharacterUseCase {
    
    var isLastPage: Bool = false
    private var nextUrlString: String? = nil
    
    private let repository: CharacterListRepository
    
    init(repository: CharacterListRepository = DefaultCharacterListRepository()) {
        self.repository = repository
    }
    
    func getCharacterList(pageNumber: Int, textSearch: String, filters: [String]) async throws  -> [CharacterInfo] {
        do {
            let response = try await repository.getCharacterList(pageNumber: pageNumber, textSearch: textSearch, filters: filters)
            isLastPage = response.info.next == nil
            nextUrlString = response.info.next
            return response.characters
        } catch {
            throw error
        }
    }
}
