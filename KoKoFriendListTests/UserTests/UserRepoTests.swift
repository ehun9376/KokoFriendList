//
//  UserRepoTests.swift
//  KoKoFriendList
//
//  Created by 陳逸煌 on 2025/10/4.
//

import XCTest
@testable import KoKoFriendList

@MainActor
class UserRepoTests: XCTestCase {
    
  
    
    
    func test_repo_return_user_model() async {
        let mockAPI = MockAPIService()
        let userRespond: UserResponseDTO = UserResponseDTO(response: [.init(name: "test", kokoid: "test")])
        mockAPI.result = .success(userRespond)
        
        let sut = UserRepositoryImpl(apiService: mockAPI)
        
        do {
            let model: UserModel = try await sut.fetchUser()
            let name = model.name
            let id = model.kokoid
            
            XCTAssertEqual(name, "test")
            XCTAssertEqual(id, "test")


        } catch {
                XCTFail("shoud not be failed")
        }
        
        
    }
    
    func test_repo_throw_error_when_api_return_error() async {
        let mockAPI = MockAPIService()
        mockAPI.result = .failure(.unknown)
        
        let sut = UserRepositoryImpl(apiService: mockAPI)
        
        do {
            _ = try await sut.fetchUser()
            XCTFail("shoud be failed")
        } catch {
            
        }
    }
    
    func test_repo_throw_error_when_decode_error() async {
        let mockAPI = MockAPIService()
        mockAPI.result = .success(UserResponseDTO(response: []))
        
        let sut = UserRepositoryImpl(apiService: mockAPI)
        
        do {
            _ = try await sut.fetchUser()
        } catch {
            XCTAssertEqual(error as? DomainError,  .decoding(message: "No user found") )
          
        }
    }
}
