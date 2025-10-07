//
//  EnterViewController.swift
//  KoKoFriendList
//
//  Created by 陳逸煌 on 2025/10/6.
//

import UIKit

class EnterViewController: UIViewController {
    
    let stackView = UIStackView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    func setupView() {
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.axis = .vertical
        self.stackView.spacing = 15
        self.view.addSubview(self.stackView)
        NSLayoutConstraint.activate([
            self.stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        
        for type in FriendListPageType.allCases {
            self.stackView.addArrangedSubview(self.createButton(type))
        }
        
        let tipLabel = UILabel()
        tipLabel.text = "點擊KO按鈕就可以退回上頁"
        self.stackView.addArrangedSubview(tipLabel)
    }
    
    func createButton(_ type: FriendListPageType) -> SimpleButton {
        let button = SimpleButton()
        button.setTitle(type.enterButtonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setBackgroundColor(.pinkEC008C, for: .normal)
        button.setActionClosure { [weak self] in
            guard let self = self else { return }
            self.presentHomeViewController(type)
        }
        
        return button
    }
    
    func presentHomeViewController(_ type: FriendListPageType)  {
        let viewController = HomeViewController(viewModel: .init(initTab: .friend, friendListPageType: type))
        viewController.modalPresentationStyle = .fullScreen
        
        self.present(viewController, animated: true)
    }
    
    
}
