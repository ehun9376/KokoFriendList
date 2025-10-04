//
//  FriendEndPoints.swift
//  KoKoFriendList
//
//  Created by 陳逸煌 on 2025/10/4.
//

class FriendEndPoints {
    static func getFriend1() -> Endpoint {
        return .init(url: .dimanyen, path: "/friend1.json", method: .get)
    }
    
    static func getFriend2() -> Endpoint {
        return .init(url: .dimanyen, path: "/friend2.json", method: .get)
    }
    
    static func getFriend3() -> Endpoint {
        return .init(url: .dimanyen, path: "/friend3.json", method: .get)
    }
    
    static func getFriend4() -> Endpoint {
        return .init(url: .dimanyen, path: "/friend4.json", method: .get)
    }
}
