//
//  FirendListViewController.swift
//  KoKoFriendList
//
//  Created by 陳逸煌 on 2025/10/6.
//

import UIKit
import Combine

class FriendListViewController: UIViewController {
    
    let topStackView = UIStackView()
    
    let topUserInfoView = TopUserInfoView()
    
    let switcher = FunctionSwitcher()
    
    let inviteFriendsView = InviteFriendsView()
    
    let tabView = TabView()
    
    let tableView = UITableView()
    
    let viewModel: FriendListViewModel
    
    var adapter: TableViewAdapter?
    
    var cancellable = Set<AnyCancellable>()
    
    init(viewModel: FriendListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.setupNavigationBarItems()
        self.setupView()
        self.setupAdapter()
        self.setupBinding()
        self.setupLazyLoadingRow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task { [weak self] in
            guard let self = self else { return }
            await self.fetchData()
        }
        
    }
    
    
    func setupView() {
        self.topStackView.backgroundColor = .grayFCFCFC
        self.topStackView.axis = .vertical
        self.topStackView.spacing = 0
        self.topStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.tableView.sectionHeaderTopPadding = 0
        self.tableView.separatorStyle = .none
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.switcher.configure(tabs: FriendListTab.allCases, currentTab: self.viewModel.currentTab) { [weak self] tab in
            guard let self = self else { return }
            self.viewModel.currentTab = tab
        }
        
        self.topStackView.addArrangedSubview(self.topUserInfoView)
        self.topStackView.addArrangedSubview(self.inviteFriendsView)
        self.topStackView.addArrangedSubview(self.switcher)
        
        
        self.view.addSubview(self.tableView)
        
        self.view.addSubview(self.topStackView)
        
        NSLayoutConstraint.activate([
            self.topStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.topStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.topStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            self.tableView.topAnchor.constraint(equalTo: self.topStackView.bottomAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    func setupNavigationBarItems() {
        let withdrawButton = UIBarButtonItem(image: .init(named: "NavPinkWithdraw")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(atmTapped))
        let transferButton = UIBarButtonItem(image: .init(named: "NavPinkTransfer")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(transferTapped))
        self.navigationItem.leftBarButtonItems = [withdrawButton, transferButton]
        
        let scanButton = UIBarButtonItem(image: .init(named: "NavPinkScan")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(scanTapped))
        self.navigationItem.rightBarButtonItem = scanButton
    }
    
    func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .grayFCFCFC
        appearance.shadowColor = .clear
        
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
    }
    
    
    func setupAdapter() {
        self.adapter = .init(tableView: self.tableView)
        self.adapter?.addRefreshControl { [weak self] in
            guard let self = self else { return }
            await self.fetchData()
        }
    }
    
    func setupBinding()  {
        self.viewModel.$user
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                guard let self = self else { return }
                self.topUserInfoView.configure(user)
                
            }
            .store(in: &self.cancellable)
        
        Publishers.CombineLatest3(self.viewModel.$filteredFriends, self.viewModel.$friends , self.viewModel.$currentTab)
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] filteredFriends, friends, tab in
                guard let self = self else { return }
                
                switch tab {
                case .friends:
                    self.setupFriendRow(filteredFriends: filteredFriends, friends: friends)
                case .chat:
                    self.setupChatRow()
                }
                
                
            }
            .store(in: &self.cancellable)

        self.viewModel.$tabBadge
            .receive(on: DispatchQueue.main)
            .sink { [weak self] tabs in
                guard let self = self else { return }
                for tab in tabs {
                    self.switcher.setBadge(for: tab.key, count: tab.value)
                }
                
            }
            .store(in: &self.cancellable)
        
        self.viewModel.$isOnFocus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isOnFocus in
                guard let self = self else { return }
                self.setIsOnFocus(isOnFocus)
                
            }
            .store(in: &self.cancellable)
        
        self.viewModel.$invites
            .receive(on: DispatchQueue.main)
            .sink { [weak self] inviteFriends in
                guard let self = self else { return }
                self.inviteFriendsView.configure(with: inviteFriends)
            }
            .store(in: &self.cancellable)
    }
    
    func fetchData() async {
        await self.viewModel.fetchFriends()
        await self.viewModel.fetchUserInfo()
        await self.viewModel.fetchBadge()
    }
    
    func setIsOnFocus(_ isOnFocus: Bool) {

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) { [weak self] in
            guard let self else { return }
        
            self.topUserInfoView.alpha = isOnFocus ? 0 : 1
            self.switcher.alpha = isOnFocus ? 0 : 1
            self.view.layoutIfNeeded()
            
        } completion: { [weak self] _ in
            guard let self else { return }
            self.topUserInfoView.isHidden = isOnFocus
            self.switcher.isHidden = isOnFocus
            self.inviteFriendsView.isHidden = isOnFocus || (self.viewModel.invites?.isEmpty ?? true)
            if !isOnFocus {
                self.view.endEditing(true)
            }
            
        }
    }
    
    func setupLazyLoadingRow() {
        let sectionModel: SectionModel = .init(headerViewModel: nil, rowModels: [])

        for _ in 0...5 {
            let lazyLoadingFriendRow = FriendCellRowModel(isLoading: true)
            sectionModel.rowModels.append(lazyLoadingFriendRow)
        }
        self.adapter?.updateRowModels([sectionModel])
    }
    
    func setupFriendRow(filteredFriends: [FriendModel]? = nil, friends: [FriendModel]? = nil) {
        
        let sectionModel: SectionModel = .init(headerViewModel: nil, rowModels: [])
        
        //兩個都是 nil 就表示還在Loading
        guard let filteredFriends = filteredFriends, let friends = friends else {
            self.setupLazyLoadingRow()
            return
        }
        
        
        //原始資料是空的就表示沒有好友
        guard !friends.isEmpty else {
            let emptyRow = EmptyDataCellRowModel()
            sectionModel.rowModels.append(emptyRow)
            self.adapter?.updateRowModels([sectionModel])
            return
        }
        
        let searchBarHeaderViewModel = SearchFriendHeaderViewModel(searchAction: { [weak self] text in
            guard let self = self else { return }
            self.viewModel.filterFriends(by: text)
        },
                                                                   focusAction: { [weak self] focus in
            guard let self = self else { return }
            
            self.setIsOnFocus(focus)
        })
        
        sectionModel.headerViewModel = searchBarHeaderViewModel
        
        for friend in filteredFriends {
            let rowModel = FriendCellRowModel(isTop: friend.isTop,
                                              imageURL: nil,
                                              name: friend.name,
                                              status: friend.status)
            sectionModel.rowModels.append(rowModel)
        }
        
        self.adapter?.updateRowModels([sectionModel])

    }
    
    func setupChatRow() {
        self.adapter?.updateRowModels([])
    }
    
    
    
    @objc func atmTapped() { }
    
    @objc func transferTapped() { }
    
    @objc func scanTapped() { }
    
    
    
    
}
