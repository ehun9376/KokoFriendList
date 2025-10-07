//
//  HomeViewController.swift
//  KoKoFriendList
//
//  Created by 陳逸煌 on 2025/10/6.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    
    var currentViewController: UIViewController = .init()
    
    let tabView = TabView()
    
    let viewModel: HomeViewModel
    
    var cancellables = Set<AnyCancellable>()

    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil) 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setupView()
        self.setupBinding()
    }
    
    func setupBinding()  {
        self.viewModel.$currentTab
            .receive(on: DispatchQueue.main)
            .sink { [weak self] tab in
                guard let self = self else { return }
                
                var vc = UIViewController()
                
                switch tab {
                case .friend:
                    let container = FriendListDIContainer()
                    let viewModel = FriendListViewModel(getFriendListUseCase: container.resolveFriendListUseCase(for: self.viewModel.friendListPageType), getUserInfoUseCase: container.resolve(), getBadgeUseCase: container.resolve(), type: self.viewModel.friendListPageType)
                    vc = UINavigationController(rootViewController: FriendListViewController(viewModel: viewModel))
                default:
                    vc  = .init()
                    
                }
                self.switchToViewController(vc)
            }
            .store(in: &self.cancellables)
    }
    
    func setupView() {
        
        
        self.tabView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.tabView)
        
        NSLayoutConstraint.activate([
            self.tabView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tabView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.tabView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        self.tabView.configureStackView(tabItems: self.viewModel.tabBarItems, initialTab: self.viewModel.currentTab)
        
        self.tabView.tabAction = { [weak self] tab in
            guard let self = self else { return }
            
            switch tab {
            case .home:
                self.dismiss(animated: true)
            default:
                self.viewModel.setTab(tab)
            }
            
            
        }
    }
    
    private func switchToViewController(_ newVC: UIViewController) {
        
        self.currentViewController.willMove(toParent: nil)
        self.currentViewController.view.removeFromSuperview()
        self.currentViewController.removeFromParent()
        
        
        self.addChild(newVC)
        self.view.insertSubview(newVC.view, belowSubview: self.tabView)
        
        newVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newVC.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            newVC.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            newVC.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            newVC.view.bottomAnchor.constraint(equalTo: self.tabView.topAnchor)
        ])
        
        newVC.didMove(toParent: self)
        self.currentViewController = newVC
    }

}

