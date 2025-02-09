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
    @Published var isLastLoadFinished: Bool = true
    
    enum FilterType: Equatable, Hashable {
        case speciesSelected(String)
        case statusSelected(String)
        case genderSelected(String)
    }
    
    var filters = Set<FilterType>() {
        didSet {
            Task {
                await searchWith(text: searchText)
            }
        }
    }
    
    var searchText: String = "" {
        didSet {
            Task {
                await searchWith(text: searchText)
            }
        }
    }
    
    var hasFilterSelected: Bool {
        !createFilterString().isEmpty
    }
    
    private let useCase: GetListCharacterUseCase
    private var currentPage: Int = 1
    private var loadMorePages: Bool = true
    private var lastSearchText: String = ""
    private var lastFilters: [String] = []
    private var searchingInit: Bool = false
    
    init(useCase: GetListCharacterUseCase = DefaultGetListCharacterUseCase()) {
        self.useCase = useCase
    }
    
    func loadCharacters() async {
        loadMorePages = !useCase.isLastPage || searchingInit
        guard !isLoading && loadMorePages else { return }
        
        await MainActor.run {
            isLoading = true
            isLastLoadFinished = false
        }
        
        do {
            //try await Task.sleep(nanoseconds: 2_000_000_000)
            let newCharacters = try await useCase.getCharacterList(pageNumber: currentPage,
                                                                   textSearch: lastSearchText,
                                                                   filters: lastFilters)
            await MainActor.run {
                characters += newCharacters
                currentPage += 1
                isLoading = false
                isLastLoadFinished = true
            }
        } catch {
            await MainActor.run {
                isLoading = false
                isLastLoadFinished = true
            }
        }
    }
    
    @MainActor
    func searchWith(text: String) {
        searchingInit = true
        guard isLastLoadFinished else { return }
        isLastLoadFinished = false
        currentPage = 1 // New search
        characters = []
        lastSearchText = text
        lastFilters = createFilterString()
        Task {
            await loadCharacters()
            isLastLoadFinished = true
            searchingInit = false
        }
    }
    
    private func createFilterString() -> [String] {
        var response: [String] = []
        
        for filter in filters {
            switch filter {
            case .speciesSelected(let species) where !species.isEmpty :
                response.append("species=\(species.lowercased())")
                
            case .statusSelected(let status) where !status.isEmpty :
                response.append("status=\(status.lowercased())")
                
            case .genderSelected(let gender) where !gender.isEmpty :
                response.append("gender=\(gender.lowercased())")
                
            default:
                break
            }
        }
        return response
    }
}
