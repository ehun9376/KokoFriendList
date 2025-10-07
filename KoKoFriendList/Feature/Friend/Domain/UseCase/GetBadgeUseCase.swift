//
//  GetBadgeUseCase.swift
//  KoKoFriendList
//
//  Created by 陳逸煌 on 2025/10/7.
//

class GetBadgeUseCase {
    
    var repository: FriendRepository
    
    init(repository: FriendRepository) {
        self.repository = repository
    }
    
    func execute(_ type: FriendListPageType) async -> [FriendListTab: Int] {
        return await self.repository.fetchFriendBadge(type)
    }
    
}
