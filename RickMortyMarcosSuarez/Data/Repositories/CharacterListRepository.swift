//
//  CharacterListRepository.swift
//  RickMortyMarcosSuarez
//
//  Created by Marcos Suarez Ayala on 16/4/24.
//

import Foundation

protocol CharacterListRepository {
    func getCharacterList(pageNumber: Int, textSearch: String, filters: [String]) async throws -> CharacterListResponse
}

final class DefaultCharacterListRepository {
    
    private let apiService: HTTPClient
    
    init(apiService: HTTPClient = URLSessionHTTPClient()) {
        self.apiService = apiService
    }
}

extension DefaultCharacterListRepository: CharacterListRepository {
    func getCharacterList(pageNumber: Int, textSearch: String, filters: [String]) async throws -> CharacterListResponse {
        do {
            let endPoint = createEndPoint(pageNumber: pageNumber, textSearch: textSearch, filters: filters)
            let response:CharacterListResponse = try await apiService.getDataFromRequest(from: endPoint)
            return response
        } catch {
            throw error
        }
    }
}

private extension DefaultCharacterListRepository {
    func createEndPoint(pageNumber: Int, textSearch: String, filters: [String]) -> String {
        var endPoint = URLCharacters.baseUrl + URLCharacters.characterUrl + "\(URLCharacters.pagination)\(pageNumber)"
        if !textSearch.isEmpty {
            endPoint += "&name=\(textSearch)"
        }
        if !filters.isEmpty {
            filters.forEach { endPoint += "&\($0)" }
        }
        return endPoint
    }
}
