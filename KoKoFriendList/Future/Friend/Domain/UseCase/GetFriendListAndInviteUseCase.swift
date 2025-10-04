//
//  FriendListAndInviteUseCase.swift
//  KoKoFriendList
//
//  Created by 陳逸煌 on 2025/10/4.
//

class GetFriendListAndInviteUseCase: FriendListFetchingUseCase {
    var repository: FriendRepository
    
    init(repository: FriendRepository) {
        self.repository = repository
    }
    
    func execute() async throws -> [FriendModel] {
        try await repository.fetchFriendsAndInviteList()
    }
}
