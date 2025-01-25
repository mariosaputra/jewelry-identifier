//
//  Enums.swift
//  JewelryIdentifier
//
//  Created by Mario Saputra on 2024/03/04.
//

import Foundation

enum AlertType: Identifiable {
    case resetConfirmation
    case deletionCompleted
    
    var id: Int {
        switch self {
        case .resetConfirmation:
            return 0
        case .deletionCompleted:
            return 1
        }
    }
}

enum OpenAIError: Error {
    case rateLimit
    case dataExceedsLimit
    case invalidImage
    case systemError
}
