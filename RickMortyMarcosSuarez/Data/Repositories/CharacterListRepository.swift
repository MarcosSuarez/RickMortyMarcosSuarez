//
//  CharacterListRepository.swift
//  RickMortyMarcosSuarez
//
//  Created by Marcos Suarez Ayala on 16/4/24.
//

import Foundation

protocol CharacterListRepository {
    func getCharacterList(pageNumber: Int) async throws -> CharacterListResponse
}

final class DefaultCharacterListRepository {
    
    private let apiService: HTTPClient
    
    init(apiService: HTTPClient = URLSessionHTTPClient()) {
        self.apiService = apiService
    }
}

extension DefaultCharacterListRepository: CharacterListRepository {
    func getCharacterList(pageNumber: Int) async throws -> CharacterListResponse {
        do {
            let endPoint = URLCharacters.baseUrl + URLCharacters.characterUrl + "\(URLCharacters.pagination)\(pageNumber)"
            let response:CharacterListResponse = try await apiService.getDataFromRequest(from: endPoint)
            return response
        } catch {
            throw error
        }
    }
}
