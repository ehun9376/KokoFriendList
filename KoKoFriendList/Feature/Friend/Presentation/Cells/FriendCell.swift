//
//  FriendCell.swift
//  KoKoFriendList
//
//  Created by 陳逸煌 on 2025/10/8.
//

import UIKit

class FriendCellRowModel: CellRowModel {
    
    var isLoading: Bool = false
    
    var isTop: Bool = false
    
    var imageURL: String?
    
    var name: String = ""
    
    var status: FriendStatus
  
    var cellDidSelectAction: ((any CellRowModel) -> ())?
    
    init(
        isLoading: Bool = false,
        isTop: Bool = false,
        imageURL: String? = nil,
        name: String = "",
        status: FriendStatus = .finish,
        cellDidSelectAction: ((CellRowModel) -> ())? = nil
    ) {
        self.isLoading = isLoading
        self.isTop = isTop
        self.imageURL = imageURL
        self.name = name
        self.status = status
        self.cellDidSelectAction = cellDidSelectAction
    }
    
    func getTableViewCellInitType() -> TableViewWidgetsInitType {
        return .nib(nibName: "FriendCell", bundle: nil, viewID: "FriendCell")
    }
    
    func cellDidSelect(model: any CellRowModel) {
        self.cellDidSelectAction?(model)
    }
    
}

class FriendCell: UITableViewCell {
    
    @IBOutlet weak var starImageView: UIImageView!
    
    @IBOutlet weak var headImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var buttonStackView: UIStackView!
    
    @IBOutlet weak var lineView: UIView!
    
    override func awakeFromNib() {
        
        self.selectionStyle = .none
        
        self.starImageView.image = .init(named: "FriendsStar")
        
        self.buttonStackView.axis = .horizontal
        self.buttonStackView.spacing = 10
        
        self.nameLabel.textColor = .gray595959
        self.nameLabel.font = .systemFont(ofSize: 14)
        
        self.headImageView.layer.cornerRadius = 20
        
        self.starImageView.isHidden = true
        
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

extension FriendCell: TableViewWidgetBinding {
    
    
    func setupView(model: any TableViewWidgetViewModel) {
        guard let model = model as? FriendCellRowModel else { return }
        
        if model.isLoading {
            self.starImageView.isHidden = false
            self.addFlashLayer()
           
        } else {
            self.removeFlashOverlay()
            self.starImageView.isHidden = !model.isTop
            
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
    
    func addFlashLayer() {
        self.starImageView.addFlashLayer(frame: .init(x: 0, y: 0, width: 20, height: 20))
        self.nameLabel.addFlashLayer(frame: .init(x: 0, y: 0, width: 50, height: 25))
        self.buttonStackView.addFlashLayer(frame: .init(x: 0, y: 0, width: 50, height: 25))
        self.headImageView.addFlashLayer(frame: .init(x: 0, y: 0, width: 40, height: 40), cornerRadius: 20)
    }
    
    func removeFlashOverlay() {
        self.starImageView.removeFlashLayer()
        self.nameLabel.removeFlashLayer()
        self.buttonStackView.removeFlashLayer()
        self.headImageView.removeFlashLayer()
    }
    
}
