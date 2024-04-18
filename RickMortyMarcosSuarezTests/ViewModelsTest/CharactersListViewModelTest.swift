//
//  CharactersListViewModelTest.swift
//  RickMortyMarcosSuarezTests
//
//  Created by Marcos Suarez Ayala on 17/4/24.
//

import XCTest
@testable import RickMortyMarcosSuarez

final class CharactersListViewModelTest: XCTestCase {
    
    private var sut: CharactersListViewModel? = nil

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testSuccessCase_FirstPageloadCharacterList() async {
        sut = buildSut(pageNumber: 1, of: 2)
        
        await sut?.loadCharacters()
        
        XCTAssertEqual(sut?.characters.count, 4)
        XCTAssertEqual(sut?.isLoading, false)
    }
    
    func testSuccessCase_loadCharacterList_withTwoPages() async {
        sut = buildSut(pageNumber: 1, of: 2)
        
        await sut?.loadCharacters()
        await sut?.loadCharacters()
        
        XCTAssertEqual(sut?.characters.count, 8)
        XCTAssertEqual(sut?.isLoading, false)
    }
    
    func testSuccessCase_multipleCalls_justTwoPages() async {
        sut = buildSut(pageNumber: 1, of: 2)
        
        await sut?.loadCharacters()
        await sut?.loadCharacters()
        await sut?.loadCharacters()
        await sut?.loadCharacters()
        await sut?.loadCharacters()
        
        XCTAssertEqual(sut?.characters.count, 8)
        XCTAssertEqual(sut?.isLoading, false)
    }
    
    
    func testFailureCase() async {
        // TODO: - Failure test
    }

    // MARK: - Helpers:
    private func buildSut(pageNumber: Int, of lastPage: Int) -> CharactersListViewModel {
        let useCase = GetListCharacterUseCaseStub()
        useCase.lastPage = lastPage
        return CharactersListViewModel(useCase: useCase)
    }
    
    private final class GetListCharacterUseCaseStub: GetListCharacterUseCase {
        var isLastPage: Bool = false
        var lastPage: Int = .max
        var response: [CharacterInfo] = []
        
        func getCharacterList(pageNumber: Int) async throws -> [CharacterInfo] {
            isLastPage = pageNumber == lastPage
            guard !isLastPage else { return response }
            return builtListCharacterInfoMock(page: pageNumber)
        }
        
        private func builtListCharacterInfoMock(page: Int) -> [CharacterInfo] {
            for number in 0...3 {
                response.append(CharacterInfo(
                    id: page*10 + number,
                    name: "name\(page) ",
                    status: .alive,
                    species: "Humman",
                    type: "",
                    gender: .genderless,
                    origin: Location(name: "", url: ""),
                    location: Location(name: "", url: ""),
                    image: "",
                    episode: [],
                    url: "",
                    created: ""
                ))
            }
            return response
        }
    }
}
