//
//  UserMapper.swift
//  KoKoFriendList
//
//  Created by 陳逸煌 on 2025/10/4.
//

extension UserResponseDTO {
    func toDomain() throws -> UserModel {
        if let first = self.response.first {
            return .init(name: first.name, kokoid: first.kokoid)
        } else {
            throw DomainError.decoding(message: "No user found")
        }
    }
}
