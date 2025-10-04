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
            let friendDTO: FriendDTO = try await self.apiService.request(FriendEndPoints.getFriend1(), policy: .networkAnd5xx)
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
            let friendDTO: FriendDTO = try await self.apiService.request(FriendEndPoints.getFriend2(), policy: .networkAnd5xx)
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
            let friendDTO: FriendDTO = try await self.apiService.request(FriendEndPoints.getFriend3(), policy: .networkAnd5xx)
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
            let friendDTO: FriendDTO = try await self.apiService.request(FriendEndPoints.getFriend4(), policy: .networkAnd5xx)
            return friendDTO.toDomain()
        } catch let apiError as APIError {
            throw DomainError.from(apiError: apiError)
        } catch let domainError as DomainError {
            throw domainError
        } catch {
            throw DomainError.unknown(message: error.localizedDescription)
        }
 
    }
    
    
    
}
