//
//  MockAPIService.swift
//  KoKoFriendList
//
//  Created by 陳逸煌 on 2025/10/4.
//

@testable import KoKoFriendList
import Foundation

class MockAPIService: APIServiceProtocol {
    
    var result: Result<Decodable, APIError>?
    
    
    func request<T>(_ endpoint: Endpoint) async throws -> T where T : Decodable {
        switch result {
        case .success(let success):
       
            return success as! T
       
        case .failure(let failure):
            throw failure
        case nil:
            throw APIError.unknown
        }
        
    }
    
}
