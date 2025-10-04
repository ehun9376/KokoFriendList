//
//  DomainError.swift
//  CombineTest
//
//  Created by 陳逸煌 on 2025/9/23.
//


import Foundation
enum DomainError: Error, Equatable {
    case network(message: String)
    case server(message: String)
    case decoding(message: String)
    case unknown(message: String)
    case invalidInput(message: String)
    case authenticationFailed(message: String)

    
    static func from(apiError: APIError) -> DomainError {
        switch apiError {
        case .invalidURL, .transport:
            return .network(message: apiError.localizedDescription)
        case .server:
            return .server(message: apiError.localizedDescription)
        case .decoding:
            return .decoding(message: apiError.localizedDescription)
        case .unknown:
            return .unknown(message: apiError.localizedDescription)
        case .unauthorized:
            return .authenticationFailed(message: apiError.localizedDescription)
        }
    }
}
