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
    
    let tabView = TabView()
    
    let tableView = UITableView()
    
    let viewModel: FriendListViewModel
    
    var adapter: TableViewAdapter?
    
    var cancellables = Set<AnyCancellable>()
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchData()
    }
  
    
    func setupView() {
        self.topStackView.backgroundColor = .grayFCFCFC
        self.topStackView.axis = .vertical
        self.topStackView.spacing = 0
        self.topStackView.translatesAutoresizingMaskIntoConstraints = false
        self.topStackView.setContentHuggingPriority(.defaultLow, for: .vertical)
        self.topStackView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        self.tableView.separatorStyle = .none
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.switcher.configure(tabs: FriendListTab.allCases, currentTab: self.viewModel.currentTab) { [weak self] tab in
            guard let self = self else { return }
            self.viewModel.currentTab = tab
        }

        self.topStackView.addArrangedSubview(self.topUserInfoView)
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
            await self.viewModel.fetchFriends()
            await self.viewModel.fetchUserInfo()
        }
    }
    
    func setupBinding()  {
        self.viewModel.$user
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                guard let self = self else { return }
                self.topUserInfoView.configure(user)
            
            }
            .store(in: &self.cancellables)
        
        self.viewModel.$friends
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] _ in
                guard let self = self else { return }
                self.setupRow(self.viewModel.currentTab)
            }
            .store(in: &self.cancellables)
        
        self.viewModel.$currentTab
            .receive(on: DispatchQueue.main)
            .sink { [weak self] tab in
                guard let self = self else { return }
                self.setupRow(self.viewModel.currentTab)
            
            }
            .store(in: &self.cancellables)
        
        self.viewModel.$tabBadge
            .receive(on: DispatchQueue.main)
            .sink { [weak self] tabs in
                guard let self = self else { return }
                for tab in tabs {
                    self.switcher.setBadge(for: tab.key, count: tab.value)
                }
            
            }
            .store(in: &self.cancellables)
        
        self.viewModel.$isOnFocus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isOnFocus in
                guard let self = self else { return }
                self.setIsOnFocus(isOnFocus)
            
            }
            .store(in: &self.cancellables)
    }
    
    func fetchData() {
        Task {
            await self.viewModel.fetchFriends()
            await self.viewModel.fetchUserInfo()
            await self.viewModel.fetchBadge()
        }
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
          }
    }
    
    func setupRow(_ tab: FriendListTab) {
        
        var rowModels: [CellRowModel] = []
        
        switch tab {
            
        case .friends:
            
            if self.viewModel.friends.isEmpty {
                
                let emptyRow = EmptyDataCellRowModel(imageName: "FriendsEmpty",
                                                     title: "就從加好友開始吧:)",
                                                     message: "與好友們一起用 KOKO 聊起來！\n還能互相收付款、發紅包喔：）",
                                                     buttonTitle: "加好友",
                                                     butttonImageName: "AddFriendWhite",
                                                     bottomAttr: self.createKokoIDAttributedString())
                rowModels.append(emptyRow)
            } else {
                for friend in self.viewModel.friends {
                    let rowModel = FriendCellRowModel(isTop: friend.isTop,
                                                      imageURL: nil,
                                                      name: friend.name,
                                                      status: friend.status)
                    rowModels.append(rowModel)
                }

            }
            
        case .chat:
            break
            
        }
        
        self.adapter?.updateRowModels(rowModels)
        
    }
    
    
    func createKokoIDAttributedString() -> NSAttributedString {
        
        var attributedString = NSMutableAttributedString(string: "")
        attributedString = attributedString.add(text: "幫助好友更快找到你？", attrDict: [.foregroundColor: UIColor.grayA0A0A0, .font: UIFont.systemFont(ofSize: 13)])
        
        attributedString = attributedString.add(text: "設定 KOKO ID", attrDict: [.foregroundColor: UIColor.pinkEC008C, .font: UIFont.systemFont(ofSize: 13), .underlineStyle: NSUnderlineStyle.single.rawValue, .underlineColor: UIColor.pinkEC008C])
    
        
        return attributedString
    }
    
    @objc func atmTapped() { }
    
    @objc func transferTapped() { }
    
    @objc func scanTapped() { }
    

 
    
}
