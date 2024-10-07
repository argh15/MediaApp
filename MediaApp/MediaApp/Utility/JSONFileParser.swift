//
//  JSONFileParser.swift
//  MediaApp
//
//  Created by Argh on 10/7/24.
//

import Foundation

struct JSONFileParser {
    
    func loadMediaItems<T: Codable>(from jsonFileName: String, model: T.Type) async throws -> T? {
        guard let url = Bundle.main.url(forResource: jsonFileName, withExtension: "json") else {
            throw CustomError.fileNotFound
        }
        
        let decoder = JSONDecoder()
        
        do {
            let data = try Data(contentsOf: url)
            let decodedData = try decoder.decode(model, from: data)
            return decodedData
        } catch {
            throw CustomError.invalidData
        }
    }
}
