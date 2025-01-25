//
//  ErrorHandler.swift
//  JewelryIdentifier
//
//  Created by Mario Saputra on 2024/07/24.
//

import Foundation

struct ErrorHandler {
    
    static func getMessage(for error: OpenAIError) -> String {
    
        switch error {
        case .rateLimit:
            return "Sorry, you've reached your limit for now. Please try again in an hour"
        case .dataExceedsLimit:
            return "The data transmitted exceeds the capacity limit. Please try again with different picture."
        case .invalidImage:
            return "Please make sure your image is below 20 MB in size and is of one the following formats: ['png', 'jpeg', 'gif', 'webp']"
        case .systemError:
            return "System error. Please try again."
        }
    }
    
    static func getError(from statusCode: Int) -> OpenAIError {
        switch statusCode {
        case 429:
            return .rateLimit
        case 413:
            return .dataExceedsLimit
        case 400:
            return .invalidImage
        default:
            return .systemError
        }
    }
}
