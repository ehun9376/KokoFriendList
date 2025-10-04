//
//  APIClient.swift
//  Job1111_V6
//
//  Created by 陳逸煌 on 2025/9/23.
//

import Foundation
import Combine

protocol APIServiceProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint, policy: RetryPolicy?) async throws -> T
}



class APIService: APIServiceProtocol {
    
    var session: URLSession
    var decoder: JSONDecoder
    var encoder: JSONEncoder
    
    init(
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder(),
        encoder: JSONEncoder = JSONEncoder()
    ) {
        self.session = session
        self.decoder = decoder
        self.encoder = encoder
    }
    
    func request<T: Decodable>(_ endpoint: Endpoint, policy: RetryPolicy?) async throws -> T {
        let urlText = endpoint.url.getURL()
        
        guard let url = URL(string: urlText) else {
            throw APIError.invalidURL
        }
        
        var comps = URLComponents(url: url,
                                  resolvingAgainstBaseURL: false)
        
        comps?.path = endpoint.path
        comps?.queryItems = endpoint.query
        
        guard let compsURL = comps?.url else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: compsURL)
        request.httpMethod = endpoint.method.rawValue.uppercased()
        
        endpoint.headers?.forEach {
            request.setValue($1, forHTTPHeaderField: $0)
        }
        
        if let body = endpoint.body,
           !body.isEmpty,
           let encodedBody = try? self.encoder.encode(body) {
            request.httpBody = encodedBody
        }
        
        if let contentType = endpoint.contentType {
            request.setValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
        }
        
        do {
            let (data, response) = try await self.session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.unknown
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw APIError.server(status: httpResponse.statusCode)
            }
            
            return try self.decoder.decode(T.self, from: data)
            
        } catch let error as APIError {
            throw error
        } catch let decodingError as DecodingError {
            throw APIError.decoding(decodingError)
        } catch {
            throw APIError.transport(error)
        }
    }
}
