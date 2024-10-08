//
//  NetworkService.swift
//  MediaApp
//
//  Created by Argh on 10/7/24.
//

import Foundation

struct NetworkService {
    
    private let imageCache = NSCache<NSString, NSData>()
    private var currentTask: URLSessionDownloadTask?
    
    func fetchImage(from urlString: String?) async throws -> Data {
        guard let urlString = urlString else {
            throw CustomError.emptyURL
        }
        
        if let cachedData = imageCache.object(forKey: urlString as NSString) {
            return cachedData as Data
        }
        
        if currentTask != nil {
            throw CustomError.tooManyRequests
        }
        
        let imageData = try await downloadImage(from: urlString)
        
        imageCache.setObject(imageData as NSData, forKey: urlString as NSString)
        
        return imageData
    }
    
    private func downloadImage(from urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw CustomError.invalidURL
        }
                
        let (fileURL, response) = try await URLSession.shared.download(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw CustomError.invalidResponse
        }
        
        do {
            let imageData = try Data(contentsOf: fileURL)
            return imageData
        } catch {
            throw CustomError.invalidData
        }
    }
}
