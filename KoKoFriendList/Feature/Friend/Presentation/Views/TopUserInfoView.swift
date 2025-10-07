//
//  TopInfoView.swift
//  KoKoFriendList
//
//  Created by 陳逸煌 on 2025/10/6.
//

import UIKit

class TopUserInfoView: UIView {
    
    let nameIDStackView = UIStackView()
    
    let idStackView = UIStackView()
    
    let idTrailingStackView = UIStackView()
    
    let nameLabel = UILabel()
    
    let idLabel = UILabel()
    
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    func setupView() {
        
        self.backgroundColor = .grayFCFCFC
        
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.layer.cornerRadius = 25
        self.imageView.clipsToBounds = true
        self.imageView.contentMode = .scaleToFill
        self.imageView.image = .init(named: "FriendsFemaleDefault")
        
        self.nameLabel.font = .systemFont(ofSize: 18, weight: .bold)
        self.nameLabel.textColor = .black
        self.nameLabel.text = " " //因為字串不限制高度先有文字，才可以佔位子，下方新增呼吸動畫的時候才能出現在正確的地方
        
        self.idLabel.font = .systemFont(ofSize: 16)
        self.idLabel.textColor = .grayA0A0A0
        self.idLabel.text = " "
        
        self.idTrailingStackView.axis = .horizontal
        self.idTrailingStackView.spacing = 10
        self.idTrailingStackView.alignment = .center

        
        self.idStackView.axis = .horizontal
        self.idStackView.spacing = 10
        self.idStackView.alignment = .center
    
        self.nameIDStackView.axis = .vertical
        self.nameIDStackView.spacing = 10
        self.nameIDStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.imageView)
        
        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            self.imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
            self.imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            self.imageView.heightAnchor.constraint(equalToConstant: 50),
            self.imageView.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        self.addSubview(self.nameIDStackView)
        
        NSLayoutConstraint.activate([
            self.nameIDStackView.centerYAnchor.constraint(equalTo: self.imageView.centerYAnchor),
            self.nameIDStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20)
        ])
        
        self.nameIDStackView.addArrangedSubview(self.nameLabel)
        self.nameIDStackView.addArrangedSubview(self.idStackView)
        
        self.idStackView.addArrangedSubview(self.idLabel)
        self.idStackView.addArrangedSubview(self.idTrailingStackView)
   
    }
    
    
    func configure(_ model: UserModel?, new: Bool = false) {
        if let userModel = model {
            self.removeFlastLayer()
            self.nameLabel.text = userModel.name
            self.idLabel.text = "KOKO ID：\(userModel.kokoid)"
            self.configureOfIDTrailing(new)
        } else {
            self.setFlashLayer()
        }
    }
    
    func removeFlastLayer() {
        self.nameLabel.removeGrayOverlay()
        self.idLabel.removeGrayOverlay()
        self.imageView.removeGrayOverlay()

    }
    
    func setFlashLayer() {
        self.imageView.addFlashLayer(frame: .init(x: 0, y: 0, width: 50, height: 50), backgroundColor: .grayFCFCFC, cornerRadius: 20)
        
        self.nameLabel.addFlashLayer(frame: .init(x: 0, y: 0, width: 75, height: 25), backgroundColor: .grayFCFCFC, cornerRadius: 5)
        
        self.idLabel.addFlashLayer(frame: .init(x: 0, y: 0, width: 100, height: 20), backgroundColor: .grayFCFCFC, cornerRadius: 5)
    }
    
    private func configureOfIDTrailing(_ new: Bool) {
        
        for view in self.idTrailingStackView.subviews {
            view.removeFromSuperview()
        }
        
        
        let rightArrow = UIImageView()
        rightArrow.translatesAutoresizingMaskIntoConstraints = false
        rightArrow.contentMode = .scaleAspectFit
        rightArrow.image = .init(systemName: "chevron.right")
        rightArrow.tintColor = .grayA0A0A0
        
        let bedge = UIView()
        bedge.translatesAutoresizingMaskIntoConstraints = false
        bedge.backgroundColor = .pinkEC008C
        bedge.layer.cornerRadius = 5
        
        NSLayoutConstraint.activate([
            rightArrow.widthAnchor.constraint(equalToConstant: 16),
            rightArrow.heightAnchor.constraint(equalToConstant: 16),
            
            bedge.widthAnchor.constraint(equalToConstant: 10),
            bedge.heightAnchor.constraint(equalToConstant: 10)
        ])
 
        
        self.idTrailingStackView.addArrangedSubview(rightArrow)
        
        if new {
            self.idTrailingStackView.addArrangedSubview(bedge)
        }
        
    }
    
}
