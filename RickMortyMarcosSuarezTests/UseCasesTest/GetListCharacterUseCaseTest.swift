//
//  GetListCharacterUseCaseTest.swift
//  RickMortyMarcosSuarezTests
//
//  Created by Marcos Suarez Ayala on 17/4/24.
//

import XCTest
@testable import RickMortyMarcosSuarez

final class GetListCharacterUseCaseTest: XCTestCase {

    private var sut: GetListCharacterUseCase? = nil

    override func tearDownWithError() throws {
        sut = nil
    }

    func testSuccessCase_loadOnePageOfOne() async {
        let repository = CharacterListRepositoryMock()
        sut = DefaultGetListCharacterUseCase(repository: repository)
        repository.prevPage = "somePrevPage"
        repository.nextPage = nil
        
        do {
            let characters = try await sut?.getCharacterList(pageNumber: "1")
            XCTAssertTrue(sut?.isLastPage ?? false)
            XCTAssertTrue(characters?.isEmpty ?? false)
        } catch {
            XCTFail("Expected success and receive \(error)")
        }
    }
    
    func testSuccessCase_loadNotLastPage() async {
        let repository = CharacterListRepositoryMock()
        sut = DefaultGetListCharacterUseCase(repository: repository)
        repository.prevPage = "somePrevPage"
        repository.nextPage = "someNextPage"
        do {
            let characters = try await sut?.getCharacterList(pageNumber: "1")
            XCTAssertFalse(sut?.isLastPage ?? true)
            XCTAssertTrue(characters?.isEmpty ?? false)
        } catch {
            XCTFail("Expected success and receive \(error)")
        }
    }
    
    func testCaseFailure_loadPage() async {
        let repository = CharacterListRepositoryMock()
        sut = DefaultGetListCharacterUseCase(repository: repository)
        repository.prevPage = "somePrevPage"
        repository.nextPage = "someNextPage"
        repository.error = AppError.invalidUrl
        do {
            let characters = try await sut?.getCharacterList(pageNumber: "1")
            XCTFail("Expected error and receive \(characters!)")
        } catch let errorApp as AppError {
            XCTAssertNotNil(errorApp)
            XCTAssertEqual(errorApp, AppError.invalidUrl)
        } catch {
            XCTFail("Waiting invalidUrl and received: \(error)")
        }
    }
    
    // MARK: - Helpers
    private final class CharacterListRepositoryMock: CharacterListRepository {
        var error: Error?
        var nextPage: String?
        var prevPage: String?
        
        func getCharacterList(pageNumber: String) async throws -> CharacterListResponse {
            if let error {
                throw error
            } else {
                CharacterListResponse(
                    info: Info(
                        count: 999,
                        pages: 10,
                        next: nextPage,
                        prev: prevPage
                    ),
                    characters: []
                )
            }
        }
    }
}
