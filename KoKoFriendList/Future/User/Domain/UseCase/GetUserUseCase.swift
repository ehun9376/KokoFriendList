//
//  FetchUserUseCase.swift
//  KoKoFriendList
//
//  Created by 陳逸煌 on 2025/10/4.
//


import Foundation

class GetUserUseCase {
    private let repository: any UserRepository
    
    init(repository: any UserRepository) {
        self.repository = repository
    }
    
    func execute() async throws -> UserModel {
        try await repository.fetchUser()
    }
}
