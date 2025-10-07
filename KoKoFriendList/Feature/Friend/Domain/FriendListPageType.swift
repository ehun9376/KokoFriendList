//
//  FriendListPageType.swift
//  KoKoFriendList
//
//  Created by 陳逸煌 on 2025/10/7.
//

enum FriendListPageType: CaseIterable {
    case empty
    case friendListOnly
    case friendListAndInvite
    
    var enterButtonTitle: String {
        switch self {
        case .empty:
            return "無好友畫面"
        case .friendListOnly:
            return "只有好友列表"
        case .friendListAndInvite:
            return "好友列表含邀請"
        }
    }
}
