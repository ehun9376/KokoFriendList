//
//  GetFriendListProtocol.swift
//  KoKoFriendList
//
//  Created by 陳逸煌 on 2025/10/4.
//

protocol FriendListFetchingUseCase {
    func execute() async throws -> [FriendModel]
}
