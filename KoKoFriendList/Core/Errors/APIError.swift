//
//  APIError.swift
//  CombineTest
//
//  Created by 陳逸煌 on 2025/9/23.
//

import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case transport(Error)
    case server(status: Int)
    case decoding(Error)
    case unauthorized
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL."
        case .transport(let e): return "Network error: \(e.localizedDescription)"
        case .server(let s): return "Server error (\(s))."
        case .decoding(let e): return "Decoding error: \(e.localizedDescription)"
        case .unauthorized: return "Unauthorized access."
        case .unknown: return "Unknown error."
        }
    }
}

