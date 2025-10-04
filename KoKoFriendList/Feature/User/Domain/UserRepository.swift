//
//  UserRepository.swift
//  KoKoFriendList
//
//  Created by 陳逸煌 on 2025/10/4.
//

import Foundation


protocol UserRepository {
    func fetchUser() async throws -> UserModel
}
