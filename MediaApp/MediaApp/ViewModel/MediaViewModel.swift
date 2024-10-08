//
//  ViewModel.swift
//  MediaApp
//
//  Created by Argh on 10/7/24.
//

import UIKit

final class MediaViewModel {
    
    var onMediaItemsLoaded: (() -> Void)?
    private(set) var mediaItems: [Media] = []
    
    private(set) var fileParser: JSONFileParser
    private(set) var networkService: NetworkService
    
    init(fileParser: JSONFileParser, networkService: NetworkService) {
        self.fileParser = fileParser
        self.networkService = networkService
    }
    
    func loadMediaItems() {
        Task {
            do {
                if let items = try await fileParser.loadMediaItems(from: "media", model: [Media].self) {
                    mediaItems = items
                    onMediaItemsLoaded?()
                }
            } catch let error as CustomError {
                print(error.localizedDescription)
            } catch {
                print("An unexpected error occurred: \(error)")
            }
        }
    }
    
    func loadImage(urlString: String) async throws -> UIImage {
        let imageData = try await networkService.fetchImage(from: urlString)
        
        guard let loadedImage = UIImage(data: imageData) else {
            throw CustomError.dataToImageConversionFailed
        }
        return loadedImage
    }
}
