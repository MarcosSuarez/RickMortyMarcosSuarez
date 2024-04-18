//
//  ImageLoader.swift
//  RickMortyMarcosSuarez
//
//  Created by Marcos Suarez Ayala on 17/4/24.
//

import UIKit

actor ImageLoader: ObservableObject {
    enum DownloadState {
        case inProgress(Task<UIImage, Error>)
        case completed(UIImage)
        case failed
    }
    
    private(set) var cache: [String: DownloadState] = [:]
    
    func add(_ image: UIImage, forKey key: String) {
        cache[key] = .completed(image)
    }
    
    func image(_ urlString: String) async throws -> UIImage {
        if let cached = cache[urlString] {
            switch cached {
            case .completed(let image):
                return image
            case .inProgress(let task):
                return try await task.value
            case .failed: throw AppError.serviceError
            }
        }
        
        let download: Task<UIImage, Error> = Task.detached {
            guard let url = URL(string: urlString) else {
                throw AppError.invalidUrl
            }
            let data = try await URLSession.shared.data(from: url).0
            guard let uiimage = UIImage(data: data) else {
                throw AppError.parseError
            }
            return uiimage
        }
        
        cache[urlString] = .inProgress(download)
        
        do {
            let result = try await download.value
            add(result, forKey: urlString)
            return result
        } catch {
            cache[urlString] = .failed
            throw error
        }
    }
    
    func clear() {
        cache.removeAll()
    }
}
