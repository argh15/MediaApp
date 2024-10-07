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

    var localizedDescription: String {
        switch self {
        case .invalidData:
            return "Error: Parsing Failed."
        case .unexpectedError:
            return "Error: Unexpected Error."
        case .fileNotFound:
            return "Error: File Not Found."
        }
    }
}
