//
//  FriendListUseCaseTests.swift
//  KoKoFriendList
//
//  Created by 陳逸煌 on 2025/10/4.
//

import XCTest
@testable import KoKoFriendList

@MainActor
class FriendListUseCaseTests: XCTestCase {
    
    class MockFirendsRepository: FriendRepository {
        
        var result: Result<[FriendModel], DomainError> = .success([])
        
        var fetchFriends2Result: Result<[FriendModel], DomainError> = .success([])
        
        func fetchFriends1() async throws -> [FriendModel] {
            
            switch result {
            case .success(let friends):
                return friends
            case .failure:
                throw DomainError.unknown(message: "")
            }
            
        }
        
        func fetchFriends2() async throws -> [FriendModel] {
            switch fetchFriends2Result {
            case .success(let friends):
                return friends
            case .failure:
                throw DomainError.unknown(message: "")
            }
        }
        
        func fetchFriendsAndInviteList() async throws -> [FriendModel] {
            switch result {
            case .success(let friends):
                return friends
            case .failure:
                throw DomainError.unknown(message: "")
            }
        }
        
        func fetchEmptyFriends() async throws -> [FriendModel] {
            switch result {
            case .success(let friends):
                return friends
            case .failure:
                throw DomainError.unknown(message: "")
            }
        }
        
        
       
    }
    
    
    func test_fetch_friend_list_merged_fid_no_repeat() async {
        let repo = MockFirendsRepository()
        repo.result = .success([.init(name: "test", status: .invited, isTop: true, fid: "001", updateDate: Date())])
        repo.fetchFriends2Result = .success([.init(name: "test", status: .invited, isTop: true, fid: "002", updateDate: Date())])
        
        let sut = GetFriendListUseCase(repository: repo)
        
        do {
            let friends = try await sut.execute()
            //沒有重複應該要有兩個
            XCTAssertEqual(friends.count, 2)

        
        } catch {
            XCTFail(error.localizedDescription)
        }
        
     
    }
    
    func test_fetch_friend_list_merged_fid_repeat() async {
        
        let repo = MockFirendsRepository()
        repo.result = .success([.init(name: "test", status: .invited, isTop: true, fid: "001", updateDate: Date())])
        
        let newerDate = Date() + 1000
        repo.fetchFriends2Result = .success([.init(name: "test", status: .invited, isTop: true, fid: "001", updateDate: newerDate)])
        
        let sut = GetFriendListUseCase(repository: repo)
        
        do {
            let friends = try await sut.execute()
            //重複只會剩一個
            XCTAssertEqual(friends.count, 1)
            //應該要剩下date新的的那個
            let updateDate = friends.first?.updateDate
            XCTAssertEqual(updateDate, newerDate)

        
        } catch {
            XCTFail(error.localizedDescription)
        }
        
     
    }
    
    func test_fetch_friend_list_merged_1_failed() async {
        
        let repo = MockFirendsRepository()
        repo.result = .success([.init(name: "test", status: .invited, isTop: true, fid: "001", updateDate: Date())])
        
        repo.fetchFriends2Result = .failure(.network(message: "lost"))
        
        let sut = GetFriendListUseCase(repository: repo)
        
        do {
            let friends = try await sut.execute()
            //一個成功一個失敗要剩一個
            XCTAssertEqual(friends.count, 1)
      

        
        } catch {
            XCTFail(error.localizedDescription)
        }
        
     
    }
    
    func test_fetch_friend_list_merged_2_failed() async {
        
        let repo = MockFirendsRepository()
        repo.result = .failure(.network(message: "lost"))
        
        repo.fetchFriends2Result = .failure(.network(message: "lost"))
        
        let sut = GetFriendListUseCase(repository: repo)
        
        do {
            let _ = try await sut.execute()
            //一個成功一個失敗要剩一個
            XCTFail("Should not reach here")
        
        } catch {
         
        }
        
     
    }
    
    
    func test_fetch_friend_list_and_invite() async {
        let repo = MockFirendsRepository()
        
        repo.result = .success([.init(name: "test1", status: .invited, isTop: true, fid: "001", updateDate: Date()), .init(name: "test2", status: .inviting, isTop: true, fid: "002", updateDate: Date())])
        
        let sut = GetFriendListUseCase(repository: repo)

        do {
            let friends = try await sut.execute()
            //沒邏輯應該要直接回傳
            XCTAssertEqual(friends.count, 2)


        
        } catch {
            XCTFail(error.localizedDescription)
        }

    }
    
    func test_fetch_friend_empty() async {
        let repo = MockFirendsRepository()
        
        repo.result = .success([.init(name: "test1", status: .invited, isTop: true, fid: "001", updateDate: Date()), .init(name: "test2", status: .inviting, isTop: true, fid: "002", updateDate: Date())])
        
        let sut = GetFriendListEmptyUseCase(repository: repo)

        do {
            let friends = try await sut.execute()
            
            let fid1 = friends.first?.fid
            let fid2 = friends.last?.fid
                        

            //沒這個usecase也沒邏輯應該要直接回傳
            XCTAssertEqual(friends.count, 2)
            XCTAssertEqual(fid1, "001")
            XCTAssertEqual(fid2, "002")

        
        } catch {
            XCTFail(error.localizedDescription)
        }
        
    }
   
    
    
}

