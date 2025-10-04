//
//  FriendListViewModel.swift
//  KoKoFriendList
//
//  Created by 陳逸煌 on 2025/10/4.
//

import Combine
import Foundation

enum PageType {
    case empty
    case friendListOnly
    case friendListAndSInvite
}

protocol FriendListViewModel {
    var friends: [FriendModel] { get set }
    var user: UserModel? { get set }
    func fetchFriends() async
    func fetchUserInfo() async
}




class FriendListViewModelImpl: FriendListViewModel, ObservableObject {
    
    @MainActor @Published var friends: [FriendModel] = []
    
    @MainActor @Published var user: UserModel?
    
    var getFriendListUseCase: FriendListFetchingUseCase
    
    var getUserInfoUseCase: GetUserUseCase
    
    
    init(getFriendListUseCase: FriendListFetchingUseCase,
         getUserInfoUseCase: GetUserUseCase) {
        
        self.getFriendListUseCase = getFriendListUseCase
        self.getUserInfoUseCase = getUserInfoUseCase
    }
    
    
    
    func fetchFriends() async {
        do {
            self.friends = try await self.getFriendListUseCase.execute()
            
        } catch let error as DomainError {
            // TODO: - Toast
            print(error.localizedDescription)
        } catch {
            // Handle any non-DomainError errors to make the catch exhaustive
            print(error.localizedDescription)
        }
    }
    
    
    func fetchUserInfo() async {
        do {
            let user = try await self.getUserInfoUseCase.execute()
            self.user = user
        } catch let error as DomainError {
            // TODO: - Toast
            print(error.localizedDescription)
        } catch {
            // Handle any non-DomainError errors to make the catch exhaustive
            print(error.localizedDescription)
        }
    }
}
