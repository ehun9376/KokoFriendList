//
//  FriendRepository.swift
//  KoKoFriendList
//
//  Created by 陳逸煌 on 2025/10/4.
//

protocol FriendRepository {
    
    func fetchFriends1() async throws -> [FriendModel]
    func fetchFriends2() async throws -> [FriendModel]
    func fetchFriendsAndInviteList() async throws -> [FriendModel]
    func fetchEmptyFriends() async throws -> [FriendModel]
    
    
}
