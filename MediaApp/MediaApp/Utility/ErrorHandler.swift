//
//  ErrorHandler.swift
//  MediaApp
//
//  Created by Argh on 10/7/24.
//

import Foundation

enum CustomError: Error {
    case invalidData
    case unexpectedError
    case fileNotFound
    case invalidURL
    case invalidResponse
    case tooManyRequests
    case emptyURL
    case dataToImageConversionFailed

    var localizedDescription: String {
        switch self {
        case .invalidData:
            return "Error: Parsing Failed."
        case .unexpectedError:
            return "Error: Unexpected Error."
        case .fileNotFound:
            return "Error: File Not Found."
        case .invalidURL:
            return "Error: Invalid URL."
        case .invalidResponse:
            return "Error: Invalid response from server."
        case .tooManyRequests:
            return "Error: Too Many Requests."
        case .emptyURL:
            return "Error: No URL to fetch data."
        case .dataToImageConversionFailed:
            return "Error: Data to Image conversion failed."
        }
    }
}
