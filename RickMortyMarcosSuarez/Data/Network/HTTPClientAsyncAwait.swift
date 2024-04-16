//
//  HTTPClientAsyncAwait.swift
//  RickMortyMarcosSuarez
//
//  Created by Marcos Suarez Ayala on 16/4/24.
//

import Foundation

enum AppError: Error, Equatable {
    case serviceError
    case invalidUrl
    case parseError
}

protocol HTTPClient {
    func getDataFromRequest<Response: Codable>(from url: String) async throws -> Response
}

final class URLSessionHTTPClient: HTTPClient {
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getDataFromRequest<Response: Decodable>(from url: String) async throws -> Response {
        guard let url = URL(string: url) else {
            throw AppError.invalidUrl
        }
        do {
            let (data, response) =  try await session.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
                throw AppError.serviceError
            }
            return try JSONDecoder().decode(Response.self, from: data)
        } catch _ as DecodingError {
            throw AppError.parseError
        } catch {
            throw AppError.serviceError
        }
    }
}
