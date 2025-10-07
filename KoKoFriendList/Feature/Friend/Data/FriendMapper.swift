//
//  FriendMapper.swift
//  KoKoFriendList
//
//  Created by 陳逸煌 on 2025/10/4.
//

import Foundation

extension FriendDTO {
    func toDomain() -> [FriendModel] {
        
        return self.response.map({
            return FriendModel(name: $0.name, status: .init(rawValue: $0.status) ?? FriendStatus.finish, isTop: $0.isTop == "1" , fid: $0.fid, updateDate: $0.updateDate.toDate() ?? Date())
        })
        
    }
}
