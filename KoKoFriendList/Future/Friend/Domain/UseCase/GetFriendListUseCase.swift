//
//  FetchFriendListUseCase.swift
//  KoKoFriendList
//
//  Created by 陳逸煌 on 2025/10/4.
//

class GetFriendListUseCase: FriendListFetchingUseCase {
    var repository: FriendRepository
    
    init(repository: FriendRepository) {
        self.repository = repository
    }
    
    func execute() async throws -> [FriendModel] {
        async let friends1Task = self.repository.fetchFriends1()
        async let friends2Task = self.repository.fetchFriends2()
        
        var friends1: [FriendModel] = []
        var friends2: [FriendModel] = []
        var error1: Error?
        var error2: Error?
        
        do {
            friends1 = try await friends1Task
        } catch {
            error1 = error
        }
        
        do {
            friends2 = try await friends2Task
        } catch {
            error2 = error
        }
        
        if error1 != nil && error2 != nil {
            throw DomainError.unknown(message: "Failed to fetch friends from all sources.")
        }
        
        var bestByFID: [String: FriendModel] = [:]
        
        for friend in friends1 + friends2 {
            if let existing = bestByFID[friend.fid] {
                if friend.updateDate > existing.updateDate {
                    bestByFID[friend.fid] = friend
                }
            } else {
                bestByFID[friend.fid] = friend
            }
        }
        
        return Array(bestByFID.values)
    }
 
}
