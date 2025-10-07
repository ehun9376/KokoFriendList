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
        
        let viewModel = FriendListViewModel(getFriendListUseCase: self.contianer.resolveFriendListUseCase(for: .friendListOnly),
                                            getUserInfoUseCase: self.contianer.resolve(),
                                            getBadgeUseCase: self.contianer.resolve(),
                                            type: .friendListOnly)
        await viewModel.fetchFriends()
        
        //不管比數應該要fid不重複
        let fids = viewModel.friends.map({$0.fid})
        
        if fids.count <= 0 {
            XCTFail("Should be have some data")
        } else {
            XCTAssertEqual(Set(fids).count, fids.count)
        }
        
        
    }
    
    func test_load_empty() async {
        let viewModel = FriendListViewModel(getFriendListUseCase: self.contianer.resolveFriendListUseCase(for: .empty),
                                            getUserInfoUseCase: self.contianer.resolve(),
                                            getBadgeUseCase: self.contianer.resolve(),
                                            type: .empty)
        await viewModel.fetchFriends()
        XCTAssertTrue(viewModel.friends.count <= 0)
    }
    
    func test_load_user_in_friendListOnly() async {
        let viewModel = FriendListViewModel(getFriendListUseCase: self.contianer.resolveFriendListUseCase(for: .friendListOnly),
                                            getUserInfoUseCase: self.contianer.resolve(),
                                            getBadgeUseCase: self.contianer.resolve(),
                                            type: .friendListOnly)
        await viewModel.fetchUserInfo()
        XCTAssertNotNil(viewModel.user)
    }
    
    func test_load_user_in_friendListAndSInvite() async {
        let viewModel = FriendListViewModel(getFriendListUseCase: self.contianer.resolveFriendListUseCase(for: .friendListAndInvite),
                                            getUserInfoUseCase: self.contianer.resolve(),
                                            getBadgeUseCase: self.contianer.resolve(),
                                            type: .friendListAndInvite)
        await viewModel.fetchUserInfo()
        XCTAssertNotNil(viewModel.user)
    }
    
    func test_load_user_in_empty() async {
        let viewModel = FriendListViewModel(getFriendListUseCase: self.contianer.resolveFriendListUseCase(for: .empty),
                                            getUserInfoUseCase: self.contianer.resolve(),
                                            getBadgeUseCase: self.contianer.resolve(),
                                            type: .empty)
        await viewModel.fetchUserInfo()
        XCTAssertNotNil(viewModel.user)
    }
    
    
    
    
}
