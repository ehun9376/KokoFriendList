//
//  TabButton.swift
//  KoKoFriendList
//
//  Created by 陳逸煌 on 2025/10/7.
//

import UIKit

class TabButton: UIView {
    
    var simpleButton = SimpleButton()
    
    var badgeLabel = UILabel()
    
    convenience init(
        title: String,
        action: (()->())?
    ) {
        self.init(frame: .zero)
        self.simpleButton.setTitle(title, for: .normal)
        self.simpleButton.setActionClosure(action)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        self.simpleButton.translatesAutoresizingMaskIntoConstraints = false
        self.simpleButton.setTitleColor(.lightGray, for: .normal)
        self.simpleButton.setTitleColor(.black, for: .selected)
        self.simpleButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        
        self.badgeLabel.textColor = .white
        self.badgeLabel.backgroundColor = .pinkF9B2DC
        self.badgeLabel.font = .systemFont(ofSize: 12, weight: .medium)
        self.badgeLabel.textAlignment = .center
        self.badgeLabel.layer.cornerRadius = 10
        self.badgeLabel.clipsToBounds = true
        self.badgeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.badgeLabel.isHidden = true
        
        self.addSubview(self.simpleButton)
        self.addSubview(self.badgeLabel)
        
        NSLayoutConstraint.activate([
            self.simpleButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            self.simpleButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.simpleButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            self.badgeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            self.badgeLabel.leadingAnchor.constraint(equalTo: self.simpleButton.trailingAnchor, constant: -3),
            self.badgeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.badgeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 20),
            self.badgeLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func setBadge(count: Int?) {
        if let count = count, count > 0 {
            self.badgeLabel.isHidden = false
            if count > 99 {
                self.badgeLabel.text = "99+"
            } else {
                self.badgeLabel.text = "\(count)"
            }
        } else {
            self.badgeLabel.isHidden = true
        }
    }
 
}
