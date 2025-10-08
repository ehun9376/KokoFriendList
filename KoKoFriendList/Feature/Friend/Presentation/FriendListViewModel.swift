//
//  FriendListViewModel.swift
//  KoKoFriendList
//
//  Created by 陳逸煌 on 2025/10/4.
//

import Combine
import Foundation

class FriendListViewModel {
    
    @Published var friends: [FriendModel]?
    
    @Published var user: UserModel?
    
    @Published var invites: [FriendModel]?
    
    @Published var currentTab: FriendListTab = .friends
    
    @Published var tabBadge: [FriendListTab: Int] = [:]
    
    @Published var isOnFocus: Bool = false
    
    @Published var filteredFriends: [FriendModel]?

        
    var getBadgeUseCase: GetBadgeUseCase
    
    var getFriendListUseCase: FriendListFetchingUseCase
    
    var getUserInfoUseCase: GetUserUseCase
    
    var type: FriendListPageType
    
    
    init(
        getFriendListUseCase: FriendListFetchingUseCase,
        getUserInfoUseCase: GetUserUseCase,
        getBadgeUseCase: GetBadgeUseCase,
        type: FriendListPageType
    ) {
        self.getFriendListUseCase = getFriendListUseCase
        self.getUserInfoUseCase = getUserInfoUseCase
        self.getBadgeUseCase = getBadgeUseCase
        self.type = type
    }
    
    
    
    func fetchFriends() async {
        do {
            let dataSourece = try await self.getFriendListUseCase.execute()
            self.invites = dataSourece.filter({$0.status == .invited})
            self.friends = dataSourece.filter({$0.status != .invited})
            self.filteredFriends = self.friends
        } catch let error as DomainError {
            print(error.localizedDescription)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    func fetchUserInfo() async {
        do {
            let user = try await self.getUserInfoUseCase.execute()
            self.user = user
        } catch let error as DomainError {
            print(error.localizedDescription)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchBadge() async {
        
        let badge = await self.getBadgeUseCase.execute(self.type)
        self.tabBadge = badge
        
    }
    
    func filterFriends(by keyword: String) {
        guard let friends = self.friends else {
            self.filteredFriends = nil
            return
        }
        
        if keyword.isEmpty {
            self.filteredFriends = friends
        } else {
            self.filteredFriends = friends.filter { $0.name.contains(keyword) }
        }
        
    }
    
}
