//
//  DIContainer.swift
//  KoKoFriendList
//
//  Created by 陳逸煌 on 2025/10/4.
//


protocol Resolver {
    func resolve<T>() -> T
    func register<T>(_ type: T.Type, factory: @escaping () -> T)

}

class FriendListDIContainer: Resolver {
    
    private var factories: [ObjectIdentifier: Any] = [:]

    init(
        
    ) {
        self.register(APIServiceProtocol.self) {
            return APIService()
        }
        
        self.register(UserRepository.self) { [weak self] in
            guard let self else { fatalError() }
            return UserRepositoryImpl(apiService: self.resolve())
        }
        
        self.register(GetUserUseCase.self) { [weak self] in
            guard let self else { fatalError() }
            return .init(repository: self.resolve())
        }
        
        self.register(FriendRepository.self) { [weak self] in
            guard let self else { fatalError() }
            
            return FriendRepositoryImpl(apiService: self.resolve())
        }
        
        self.register(GetFriendListUseCase.self) { [weak self] in
            guard let self else { fatalError() }
            return .init(repository: self.resolve())
        }
        
        self.register(GetBadgeUseCase.self) { [weak self] in
            guard let self else { fatalError() }
            return .init(repository: self.resolve())
        }
        
        self.register(GetFriendListAndInviteUseCase.self) { [weak self] in
            guard let self else { fatalError() }
            return .init(repository: self.resolve())
        }
        
        self.register(GetFriendListEmptyUseCase.self) { [weak self] in
            guard let self else { fatalError() }
            return .init(repository: self.resolve())
        }
      
    }

    func resolve<T>() -> T {
        if let factory = factories[ObjectIdentifier(T.self)] as? () -> T {
            return factory()
        } else {
            fatalError("No such type: \(T.self)")
        }
    }
    

    func register<T>(_ type: T.Type, factory: @escaping () -> T) {
        factories[ObjectIdentifier(type)] = factory
    }
    
    func resolveFriendListUseCase(for type: FriendListPageType) -> FriendListFetchingUseCase {
         switch type {
         case .empty:
             let useCase: GetFriendListEmptyUseCase = self.resolve()
             return useCase
         case .friendListOnly:
             let useCase: GetFriendListUseCase = self.resolve()
             return useCase
         case .friendListAndInvite:
             let useCase: GetFriendListAndInviteUseCase = self.resolve()
             return useCase
         }
     }
}
