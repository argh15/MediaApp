//
//  ViewModel.swift
//  MediaApp
//
//  Created by Argh on 10/7/24.
//

import Foundation

final class ViewModel {
    
    var onMediaItemsLoaded: (() -> Void)?
    private(set) var mediaItems: [Media] = []
    
    private let fileParser: JSONFileParser
    
    init(fileParser: JSONFileParser) {
        self.fileParser = fileParser
    }
    
    func loadMediaItems() {
        Task {
            do {
                if let items = try await fileParser.loadMediaItems(from: "media", model: [Media].self) {
                    mediaItems = items
                    onMediaItemsLoaded?()
                }
            } catch {
                print("Error loading media items: \(error)")
            }
        }
    }
}
