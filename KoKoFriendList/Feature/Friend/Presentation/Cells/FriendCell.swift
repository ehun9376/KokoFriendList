//
//  FriendCell.swift
//  KoKoFriendList
//
//  Created by 陳逸煌 on 2025/10/8.
//

import UIKit

class FriendCellRowModel: CellRowModel {
    
    var isTop: Bool = false
    
    var imageURL: String?
    
    var name: String = ""
    
    var status: FriendStatus
  
    var cellDidSelectAction: ((any CellRowModel) -> ())?
    
    init(
        isTop: Bool,
        imageURL: String? = nil,
        name: String,
        status: FriendStatus,
        cellDidSelectAction: ((any CellRowModel) -> Void)? = nil
    ) {
        self.isTop = isTop
        self.imageURL = imageURL
        self.name = name
        self.status = status
        self.cellDidSelectAction = cellDidSelectAction
    }
    
    func getTableViewCellInitType() -> TableViewCellInitType {
        return .nib(nibName: "FriendCell", bundle: nil, cellID: "FriendCell")
    }
    
    func cellDidSelect(model: any CellRowModel) {
        self.cellDidSelectAction?(model)
    }
    
}

class FriendCell: UITableViewCell {
    
    @IBOutlet weak var startImageView: UIImageView!
    
    @IBOutlet weak var headImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var buttonStackView: UIStackView!
    
    @IBOutlet weak var lineView: UIView!
    
    override func awakeFromNib() {
        
        self.selectionStyle = .none
        
        self.startImageView.image = .init(named: "FriendsStar")
        
        self.buttonStackView.axis = .horizontal
        self.buttonStackView.spacing = 10
        
        self.nameLabel.textColor = .gray595959
        self.nameLabel.font = .systemFont(ofSize: 14)
        
        self.headImageView.layer.cornerRadius = 20
        
        self.startImageView.isHidden = true
        
        self.lineView.backgroundColor = .grayE4E4E4
    }
    
    func createTransferButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("轉帳", for: .normal)
        button.setTitleColor(.pinkEC008C, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.layer.borderColor = UIColor.pinkEC008C.cgColor
        button.layer.borderWidth = 1
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 24),
            button.widthAnchor.constraint(equalToConstant: 45)
        ])
        return button
    }
    
    func createStatusButton(_ status: FriendStatus) -> UIButton? {
        switch status {
        case .finish:
            let button = UIButton()
            button.setImage(.init(systemName: "ellipsis"), for: .normal)
            button.tintColor = .grayA0A0A0
            return button
        case .invited:
            return nil
        case .inviting:
            let button = UIButton()
            button.setTitle(status.title, for: .normal)
            button.setTitleColor(.grayA0A0A0, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 14)
            button.layer.borderColor = UIColor.grayA0A0A0.cgColor
            button.layer.borderWidth = 1
            NSLayoutConstraint.activate([
                button.heightAnchor.constraint(equalToConstant: 24),
                button.widthAnchor.constraint(equalToConstant: 60)
            ])

            return button
            
        }
        
    }
    
}

extension FriendCell: CellViewBase {
    func setupCellView(model: any CellRowModel) {
        guard let model = model as? FriendCellRowModel else { return }
        
        self.startImageView.isHidden = !model.isTop
        
        self.nameLabel.text = model.name
        
        self.buttonStackView.removeAllArrangedSubviews()
        
        self.buttonStackView.addArrangedSubview(self.createTransferButton())
        
        if let button = self.createStatusButton(model.status) {
            self.buttonStackView.addArrangedSubview(button)
        }
        
        
        
        if let _ = model.imageURL {
            //TODO : - 下載圖片
        } else {
            self.headImageView.image = .init(named: "FriendsListDefault")
        }
    }
}
