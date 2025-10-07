//
//  TabView.swift
//  KoKoFriendList
//
//  Created by 陳逸煌 on 2025/10/6.
//

import UIKit

class TabView: UIView {
    
    let stackView = UIStackView()
    
    let lineView = UIView()
    
    var tabButtons: [UIButton] = []
    
    var tabAction: ((TabBarItem) -> ())?
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")

    }
    
    func setupView() {
        
        self.lineView.backgroundColor = .gray.withAlphaComponent(0.5)
        self.lineView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.lineView)
        
        NSLayoutConstraint.activate([
            self.lineView.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            self.lineView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.lineView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.lineView.heightAnchor.constraint(equalToConstant: 0.5)
            
        ])
        
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.axis = .horizontal
        self.stackView.alignment = .center
        self.stackView.distribution = .equalSpacing
        self.stackView.spacing = 0
        
        self.addSubview(self.stackView)
        
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.topAnchor),
            self.stackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            self.stackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            self.stackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    
    
    func configureStackView(tabItems: [TabBarItem], initialTab: TabBarItem? = nil) {
        
        self.stackView.removeAllArrangedSubviews()
        
        for tab in tabItems {
            let button = self.createTabButton(tab: tab)
            if initialTab == tab {
                button.isSelected = true
            }
            
            button.setActionClosure({ [weak self] in
                guard let self = self else { return }
                for tabButton in self.tabButtons {
                    tabButton.isSelected = false
                }
                
                button.isSelected = true
                self.tabAction?(tab)
            })
            
            
            self.tabButtons.append(button)
            self.stackView.addArrangedSubview(button)
        }
        
    }
    
    func createTabButton(tab: TabBarItem) -> SimpleButton {
        let button = SimpleButton(type: .custom)
        
      
        if tab == .home {
            button.setImage(.init(named: tab.buttonImageName), for: .normal)
            button.setImage(.init(named: tab.buttonImageName), for: .selected)
        } else {
            button.setImage(.init(named: tab.buttonImageName)?.withRenderingMode(.alwaysTemplate), for: .normal)
            button.setImage(.init(named: tab.buttonImageName)?.withRenderingMode(.alwaysTemplate), for: .selected)
            
            button.setTintColor(.gray, for: .normal)
            button.setTintColor(.systemPink, for: .selected)
        }
        
    
        return button
        
    }
    
    
}
