//
//  CharacterRepositoryTest.swift
//  RickMortyMarcosSuarezTests
//
//  Created by Marcos Suarez Ayala on 16/4/24.
//

import XCTest
@testable import RickMortyMarcosSuarez

final class CharacterListRepositoryTest: XCTestCase {

    var sut: CharacterListRepository? = nil

    override func tearDownWithError() throws {
        sut = nil
    }

    func testResponse_FirstPage_Success() async throws {
        sut = DefaultCharacterListRepository(apiService: FakeHttpClient(pageNumber: .first))
        
        do {
            let characterList = try await sut?.getCharacterList(pageNumber: 1, textSearch: "", filters: [])
            
            XCTAssertNotNil(characterList, "Receive nil when array expected")
            XCTAssertEqual(characterList?.characters.count, 20)
            XCTAssertEqual(characterList?.characters.first?.id, 1)
            XCTAssertEqual(characterList?.characters.last?.id, 20)
            XCTAssertNil(characterList?.info.prev)
        } catch {
            XCTFail("expected success receive \(error.localizedDescription)")
        }
    }
    
    func testResponse_SecondPage_Success() async throws {
        sut = DefaultCharacterListRepository(apiService: FakeHttpClient(pageNumber: .two))
        
        do {
            let characterList = try await sut?.getCharacterList(pageNumber: 1, textSearch: "", filters: [])
            
            XCTAssertNotNil(characterList, "Receive nil when array expected")
            XCTAssertEqual(characterList?.characters.count, 20)
            XCTAssertEqual(characterList?.characters.first?.id, 21)
            XCTAssertEqual(characterList?.characters.last?.id, 40)
            XCTAssertNotNil(characterList?.info.prev)
            XCTAssertNotNil(characterList?.info.next)
        } catch {
            XCTFail("expected success receive \(error.localizedDescription)")
        }
    }
    
    func testResponse_LastPage_Success() async throws {
        sut = DefaultCharacterListRepository(apiService: FakeHttpClient(pageNumber: .last))
        do {
            let characterList = try await sut?.getCharacterList(pageNumber: 1, textSearch: "", filters: [])
            
            XCTAssertNotNil(characterList, "Receive nil when array expected")
            XCTAssertEqual(characterList?.characters.count, 6)
            XCTAssertEqual(characterList?.characters.first?.id, 821)
            XCTAssertEqual(characterList?.characters.last?.id, 826)
            XCTAssertNil(characterList?.info.next)
        } catch {
            XCTFail("expected success receive \(error.localizedDescription)")
        }
    }
    
    func testResponse_Empty_Success() async throws {
        sut = DefaultCharacterListRepository(apiService: FakeHttpClient(pageNumber: .empty))
        do {
            let characterList = try await sut?.getCharacterList(pageNumber: 1, textSearch: "", filters: [])
            
            XCTAssertNotNil(characterList, "Receive nil when array expected")
            XCTAssertTrue(characterList?.characters.isEmpty ?? false)
            XCTAssertNil(characterList?.info.prev)
            XCTAssertNil(characterList?.info.next)
        } catch {
            XCTFail("expected success receive \(error.localizedDescription)")
        }
    }
    
    
    func testResponse_BadURL_Fails() async throws {
        let fakeHttpClient = FakeHttpClient(pageNumber: .empty)
        fakeHttpClient.appError = .invalidUrl
        
        sut = DefaultCharacterListRepository(apiService: fakeHttpClient)
        
        do {
            let _ = try await sut?.getCharacterList(pageNumber: 1, textSearch: "", filters: [])
            XCTFail("Success when expect error")
        } catch let appError as AppError {
            XCTAssertEqual(appError, AppError.invalidUrl)
        } catch {
            XCTFail("Expected invalidUrl, get \(error)")
        }
    }
    
    func testResponse_ErrorDecode_Fails() async throws {
        let fakeHttpClient = FakeHttpClient(pageNumber: .errorDecoder)
        sut = DefaultCharacterListRepository(apiService: fakeHttpClient)
        
        do {
            let _ = try await sut?.getCharacterList(pageNumber: 1, textSearch: "", filters: [])
            XCTFail("Success when expect error")
        } catch let error as AppError {
            XCTAssertEqual(error, AppError.parseError)
        } catch {
            XCTFail("Expected invalidUrl, get \(error)")
        }
    }
    
    // MARK: - Helpers
    private class FakeHttpClient: HTTPClient {
    
        var appError: AppError?
        
        enum TestPageNumber: String {
            case first = "GetAllCharactersPage01"
            case two = "GetAllCharactersPage02"
            case last = "GetAllCharactersPage42"
            case errorDecoder = "GetAllCharactersErrorDecoder"
            case empty = "GetAllCharactersEmpty"
        }
        
        private let pageNumber: TestPageNumber
        
        init(pageNumber: TestPageNumber) {
            self.pageNumber = pageNumber
        }
        
        func getDataFromRequest<Response: Codable>(from url: String) async throws -> Response {
            do {
                let data: Data = try getDataFromJson()
                let response = try JSONDecoder().decode(Response.self, from: data)
                return response
            } catch _ as DecodingError {
                throw AppError.parseError
            } catch {
                throw error
            }
        }
        
        private func getDataFromJson() throws -> Data {
            
            if let error = appError { throw error }
            
            guard let path = Bundle(for: type(of: self)).path(forResource: pageNumber.rawValue, ofType: "json") else {
                throw AppError.invalidUrl
            }
            return try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        }
    }
}
