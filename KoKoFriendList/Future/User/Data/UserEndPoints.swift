//
//  UserEndPoints.swift
//  KoKoFriendList
//
//  Created by 陳逸煌 on 2025/10/4.
//

class UserEndPoints {
    static func getUser() -> Endpoint {
        return .init(url: .dimanyen, path: "/man.json", method: .get, query: nil, headers: nil, body: nil, contentType: .none)
    }
}
