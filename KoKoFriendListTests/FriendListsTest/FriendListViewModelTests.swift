//
//  FriendListViewModelTests.swift
//  KoKoFriendList
//
//  Created by 陳逸煌 on 2025/10/4.
//

import XCTest
@testable import KoKoFriendList

@MainActor
class FriendListViewModelTests: XCTestCase {
    
    
    let contianer = FriendListDIContainer()
    
    func test_load_only_friends_fid_no_reapt() async {
        
        let viewModel = FriendListViewModelImpl(getFriendListUseCase: self.contianer.resolveFriendListUseCase(for: .friendListOnly), getUserInfoUseCase: self.contianer.resolve())
        await viewModel.fetchFriends()
        
        //不管比數應該要fid不重複
        let fids = viewModel.friends.map({$0.fid})
        
        if fids.count <= 0 {
            XCTFail("Should be have some data")
        } else {
            XCTAssertEqual(Set(fids).count, fids.count)
        }
        
        
    }
    
    func test_load_friends_and_invite() async {
        
        let viewModel = FriendListViewModelImpl(getFriendListUseCase: self.contianer.resolveFriendListUseCase(for: .friendListAndSInvite), getUserInfoUseCase: self.contianer.resolve())
        await viewModel.fetchFriends()
        
        //call完API後，三個狀態都會有
        let status = viewModel.friends.map({$0.status})
        if status.count <= 0 {
            XCTFail("Should be have some data")
        } else {
            XCTAssertTrue(status.contains(.invited))
            XCTAssertTrue(status.contains(.inviting))
            XCTAssertTrue(status.contains(.finish))
        }
       
        
    }
    
    func test_load_empty() async {
        let viewModel = FriendListViewModelImpl(getFriendListUseCase: self.contianer.resolveFriendListUseCase(for: .empty), getUserInfoUseCase: self.contianer.resolve())
        await viewModel.fetchFriends()
        XCTAssertTrue(viewModel.friends.count <= 0)
    }
    
    func test_load_user_in_friendListOnly() async {
        let viewModel = FriendListViewModelImpl(getFriendListUseCase: self.contianer.resolveFriendListUseCase(for: .friendListOnly), getUserInfoUseCase: self.contianer.resolve())
        await viewModel.fetchUserInfo()
        XCTAssertNotNil(viewModel.user)
    }
    
    func test_load_user_in_friendListAndSInvite() async {
        let viewModel = FriendListViewModelImpl(getFriendListUseCase: self.contianer.resolveFriendListUseCase(for: .friendListAndSInvite), getUserInfoUseCase: self.contianer.resolve())
        await viewModel.fetchUserInfo()
        XCTAssertNotNil(viewModel.user)
    }
    
    func test_load_user_in_empty() async {
        let viewModel = FriendListViewModelImpl(getFriendListUseCase: self.contianer.resolveFriendListUseCase(for: .empty), getUserInfoUseCase: self.contianer.resolve())
        await viewModel.fetchUserInfo()
        XCTAssertNotNil(viewModel.user)
    }
    
    
    
    
}
