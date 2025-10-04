//
//  UserRepositoryImpl.swift
//  KoKoFriendList
//
//  Created by 陳逸煌 on 2025/10/4.
//

import Foundation

class UserRepositoryImpl: UserRepository {
    
    var apiService: any APIServiceProtocol
    
    init(apiService: any APIServiceProtocol) {
        self.apiService = apiService
    }
    
    
    func fetchUser() async throws -> UserModel {
        do {
            let userDTO: UserResponseDTO = try await apiService.request(UserEndPoints.getUser(), policy: .networkAnd5xx)
            return try userDTO.toDomain()
        } catch let apiError as APIError {
            throw DomainError.from(apiError: apiError)
        } catch let domainError as DomainError {
            throw domainError
        } catch {
            throw DomainError.unknown(message: error.localizedDescription)
        }
        
    }
    
}
