//
//  FriendListRepoTests.swift
//  KoKoFriendList
//
//  Created by 陳逸煌 on 2025/10/4.
//

import XCTest
@testable import KoKoFriendList

@MainActor
class FriendListRepoTests: XCTestCase {
    
    func test_repo_fetchFriends1_return_friends() async {
        let mockAPI = MockAPIService()
        
        mockAPI.result = .success(FriendDTO(response: [.init(name: "test", status: 1, isTop: "1", fid: "001", updateDate: "20210906")]))
        let repo = FriendRepositoryImpl(apiService: mockAPI)
        
        do {
            let friends = try await repo.fetchFriends1()
            XCTAssertEqual(friends.first?.name, "test")
            XCTAssertEqual(friends.first?.isTop, true)
            XCTAssertEqual(friends.first?.fid, "001")
            XCTAssertEqual(friends.first?.updateDate, "20210906".toDate())
            XCTAssertEqual(friends.count, 1)
            XCTAssertEqual(friends.first?.status, .finish)
        } catch {
            XCTFail("should not throw error")
        }
    }
    
    func test_repo_fetchFriends1_throw_error_when_api_return_error() async {
        let mockAPI = MockAPIService()
        mockAPI.result = .failure(.unknown)
        
        let sut = FriendRepositoryImpl(apiService: mockAPI)
        
        do {
            _ = try await sut.fetchFriends1()
            XCTFail("shoud be failed")
        } catch {
            
        }
    }
    
    func test_repo_throw_error_when_decode_error() async {
        let mockAPI = MockAPIService()
        mockAPI.result = .success(FriendDTO(response: []))
        
        let sut = FriendRepositoryImpl(apiService: mockAPI)
        
        do {
            _ = try await sut.fetchFriends1()
        } catch {
            XCTFail("shoud be failed")
          
        }
    }
    
}
