//
//  UserUseCaseTests.swift
//  KoKoFriendList
//
//  Created by 陳逸煌 on 2025/10/4.
//

import XCTest
@testable import KoKoFriendList

@MainActor
class UserUseCaseTests: XCTestCase {
    
    class MockUserRepository: UserRepository {
        var result: Result<UserModel, DomainError> = .success(.init(name: "test", kokoid: "123"))
        
        func fetchUser() async throws -> UserModel {
            switch result {
            case .success(let user):
                return user
            case .failure(let error):
                throw error
            }
        }
    }
    
    
    func test_fetch_success() async {
        let repo = MockUserRepository()
        repo.result = .success(.init(name: "John", kokoid: "K123"))
        
        let sut = GetUserUseCase(repository: repo)
        
        do {
            let user = try await sut.execute()
            let name = user.name
            let kokoid = user.kokoid
            
            XCTAssertEqual(name, "John")
            XCTAssertEqual(kokoid, "K123")

        
        } catch {
            XCTFail(error.localizedDescription)
        }
        
     
    }
    
    func test_fetch_failure() async {
        let repo = MockUserRepository()
        repo.result = .failure(.decoding(message: "decoding error"))
        
        let sut = GetUserUseCase(repository: repo)
        
        
        do {
            let _ = try await sut.execute()
            XCTFail("shoud be failed")
        } catch {
            XCTAssertEqual(error as? DomainError, .decoding(message: "decoding error"))
            
        }
        
        
      
    }
}

