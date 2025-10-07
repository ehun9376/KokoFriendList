//
//  TabType.swift
//  KoKoFriendList
//
//  Created by 陳逸煌 on 2025/10/6.
//

enum TabBarItem: CaseIterable {
    case money
    case friend
    case home
    case ledger
    case setting
    
    var buttonImageName: String {
        switch self {
        case .money:
            return "TabbarProductsOff"
        case .friend:
            return "TabbarFriendsOn"
        case .home:
            return "TabbarHomeOff"
        case .ledger:
            return "TabbarManageOff"
        case .setting:
            return "TabbarSettingOff"
        }
        
    }
}
