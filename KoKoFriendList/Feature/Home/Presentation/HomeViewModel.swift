//
//  HomeViewModel.swift
//  KoKoFriendList
//
//  Created by 陳逸煌 on 2025/10/6.
//

import Combine


class HomeViewModel {
    
    @Published var tabBarItems: [TabBarItem] = TabBarItem.allCases
    
    @Published var currentTab: TabBarItem  = .friend
    
    var friendListPageType: FriendListPageType
    
  
    
    init(initTab: TabBarItem, friendListPageType: FriendListPageType) {
        self.currentTab = initTab
        self.friendListPageType = friendListPageType
    }
    
    func setTab(_ tab: TabBarItem) {
        if self.currentTab == tab {
            return
        }
        self.currentTab = tab
    }
    
}

