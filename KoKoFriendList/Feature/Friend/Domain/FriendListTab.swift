//
//  FriendListTab.swift
//  KoKoFriendList
//
//  Created by 陳逸煌 on 2025/10/7.
//

enum FriendListTab: CaseIterable {
    case friends
    case chat

    var title: String {
        switch self {
        case .friends: 
            return "好友"
        case .chat:
            return "聊天"
        }
    }
 
}
