//
//  InviteFriendView.swift
//  KoKoFriendList
//
//  Created by 陳逸煌 on 2025/10/8.
//

import UIKit

class InviteFriendsView: UIView {
    
    private let invitesStack = UIStackView()
    
    private var invites: [FriendModel] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        self.isHidden = true
        
        self.backgroundColor = .grayFCFCFC
        
        self.invitesStack.axis = .vertical
        self.invitesStack.spacing = 8
        self.invitesStack.alignment = .fill
        self.invitesStack.distribution = .fill
        self.invitesStack.translatesAutoresizingMaskIntoConstraints = false

        
        self.addSubview(self.invitesStack)
        
        NSLayoutConstraint.activate([
            self.invitesStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            self.invitesStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            self.invitesStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            self.invitesStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with invites: [FriendModel]?) {
        guard let invites = invites, !invites.isEmpty else {
            self.isHidden = true
            return
        }
        self.isHidden = false
        self.invites = invites
        self.reloadInvites()
    }
    
    private func reloadInvites() {
        self.invitesStack.removeAllArrangedSubviews()
        
        for invite in self.invites {
            let card = self.createInviteCard(for: invite)
            self.invitesStack.addArrangedSubview(card)
        }
    }
    
    private func createInviteCard(for invite: FriendModel) -> UIView {
        let avatar = UIImageView(image: .init(named: "FriendsFemaleDefault"))
        avatar.contentMode = .scaleAspectFill
        avatar.layer.cornerRadius = 20
        avatar.clipsToBounds = true
        avatar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatar.widthAnchor.constraint(equalToConstant: 40),
            avatar.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        let nameLabel = UILabel()
        nameLabel.textColor = .black
        nameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        nameLabel.text = invite.name
        
        let messageLabel = UILabel()
        messageLabel.font = .systemFont(ofSize: 14)
        messageLabel.textColor = .gray595959
        messageLabel.text = "想加你為好友：）"
        
        let textStack = UIStackView(arrangedSubviews: [nameLabel, messageLabel])
        textStack.axis = .vertical
        textStack.spacing = 2
        
        let rejectButton = UIButton(type: .system)
        rejectButton.setImage(.init(named: "FriendsDelet")?.withRenderingMode(.alwaysOriginal), for: .normal)
        rejectButton.translatesAutoresizingMaskIntoConstraints = false
        rejectButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        rejectButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        let acceptButton = UIButton(type: .system)
        acceptButton.setImage(.init(named: "FriendsAgree")?.withRenderingMode(.alwaysOriginal), for: .normal)
        acceptButton.translatesAutoresizingMaskIntoConstraints = false
        acceptButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        acceptButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        let buttonStack = UIStackView(arrangedSubviews: [acceptButton, rejectButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 15
        
        let cardStack = UIStackView(arrangedSubviews: [avatar, textStack, buttonStack])
        cardStack.axis = .horizontal
        cardStack.alignment = .center
        cardStack.spacing = 12
        cardStack.distribution = .fill
        cardStack.backgroundColor = .white
        cardStack.layer.cornerRadius = 12
        cardStack.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        cardStack.isLayoutMarginsRelativeArrangement = true
        
        let wrapper = UIView()
        wrapper.addSubview(cardStack)
        cardStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cardStack.topAnchor.constraint(equalTo: wrapper.topAnchor),
            cardStack.leadingAnchor.constraint(equalTo: wrapper.leadingAnchor),
            cardStack.trailingAnchor.constraint(equalTo: wrapper.trailingAnchor),
            cardStack.bottomAnchor.constraint(equalTo: wrapper.bottomAnchor)
        ])
        wrapper.layer.shadowColor = UIColor.black.cgColor
        wrapper.layer.shadowOpacity = 0.05
        wrapper.layer.shadowRadius = 4
        wrapper.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        return wrapper
    }
    
}
