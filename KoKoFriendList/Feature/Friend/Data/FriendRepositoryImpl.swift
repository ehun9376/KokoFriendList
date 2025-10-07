//
//  FriendRepositoryImpl.swift
//  KoKoFriendList
//
//  Created by 陳逸煌 on 2025/10/4.
//

import Foundation

class FriendRepositoryImpl: FriendRepository {
 
    

    
 
    var apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    func fetchFriends1() async throws -> [FriendModel] {
        
        do {
            let friendDTO: FriendDTO = try await self.apiService.request(FriendEndPoints.getFriend1())
            return friendDTO.toDomain()
        } catch let apiError as APIError {
            throw DomainError.from(apiError: apiError)
        } catch let domainError as DomainError {
            throw domainError
        } catch {
            throw DomainError.unknown(message: error.localizedDescription)
        }
        
    }
    
    func fetchFriends2() async throws -> [FriendModel] {
        
        do {
            let friendDTO: FriendDTO = try await self.apiService.request(FriendEndPoints.getFriend2())
            return friendDTO.toDomain()
        } catch let apiError as APIError {
            throw DomainError.from(apiError: apiError)
        } catch let domainError as DomainError {
            throw domainError
        } catch {
            throw DomainError.unknown(message: error.localizedDescription)
        }
   
    }
    
    func fetchFriendsAndInviteList() async throws -> [FriendModel] {
        
        do {
            let friendDTO: FriendDTO = try await self.apiService.request(FriendEndPoints.getFriend3())
            return friendDTO.toDomain()
        } catch let apiError as APIError {
            throw DomainError.from(apiError: apiError)
        } catch let domainError as DomainError {
            throw domainError
        } catch {
            throw DomainError.unknown(message: error.localizedDescription)
        }
  
    }
    
    func fetchEmptyFriends() async throws -> [FriendModel] {
        
        do {
            let friendDTO: FriendDTO = try await self.apiService.request(FriendEndPoints.getFriend4())
            return friendDTO.toDomain()
        } catch let apiError as APIError {
            throw DomainError.from(apiError: apiError)
        } catch let domainError as DomainError {
            throw domainError
        } catch {
            throw DomainError.unknown(message: error.localizedDescription)
        }
 
    }
    
    func fetchFriendBadge(_ type: FriendListPageType) async -> [FriendListTab : Int] {
        switch type {
        case .empty:
            return [.friends: 0, .chat: 0]
        case .friendListOnly:
            return [.friends: 0, .chat: 100]
        case .friendListAndInvite:
            return [.friends: 2, .chat: 100]
        }
        
    }
    
    
    
}
