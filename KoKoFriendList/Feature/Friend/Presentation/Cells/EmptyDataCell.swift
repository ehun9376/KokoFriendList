//
//  EmptyFriendCell.swift
//  KoKoFriendList
//
//  Created by 陳逸煌 on 2025/10/7.
//

import UIKit

class EmptyDataCellRowModel: CellRowModel {
    
  
    var imageName: String = ""
    
    var title: String = ""
    
    var message: String = ""
    
    var buttonTitle: String = ""
    
    var butttonImageName: String?
    
    var bottomAttr: NSAttributedString?
    
    var buttonAction: (()->())?
    
    var cellDidSelectAction: ((any CellRowModel) -> ())?

    
    init(imageName: String,
         title: String,
         message: String,
         buttonTitle: String,
         butttonImageName: String? = nil,
         bottomAttr: NSAttributedString? = nil,
         buttonAction: (()->())? = nil,
         cellDidSelectAction: ((any CellRowModel) -> Void)? = nil) {
        self.imageName = imageName
        self.title = title
        self.message = message
        self.buttonTitle = buttonTitle
        self.butttonImageName = butttonImageName
        self.bottomAttr = bottomAttr
        self.cellDidSelectAction = cellDidSelectAction
    }
    
    
    func getTableViewCellInitType() -> TableViewCellInitType {
        return .nib(nibName: "EmptyDataCell", bundle: nil, cellID: "EmptyDataCell")
    }
    
    func cellDidSelect(model: any CellRowModel) {
        self.cellDidSelectAction?(model)
    }
    
}

class EmptyFriendCell: UITableViewCell {
    
    @IBOutlet weak var emptyImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var actionButton: UIButton!
    
    @IBOutlet weak var bottomMessageLabel: UILabel!
    
    @IBOutlet weak var buttonImageView: UIImageView!
    
    override func awakeFromNib() {
        self.selectionStyle = .none
        
        self.titleLabel.textColor = .black
        self.titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        self.titleLabel.numberOfLines = 0
        self.titleLabel.textAlignment = .center
        
        self.messageLabel.textColor = .grayA0A0A0
        self.messageLabel.font = .systemFont(ofSize: 16)
        self.messageLabel.numberOfLines = 0
        self.messageLabel.textAlignment = .center
        
        self.emptyImageView.contentMode = .scaleAspectFit
        
        self.actionButton.setTitleColor(.white, for: .normal)
        
        self.bottomMessageLabel.numberOfLines = 0
        self.bottomMessageLabel.textAlignment = .center
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.actionButton.setGradientBackground(startColor: .green56B30B, endColor: .greenA6CC42)
    }
    
    
}

extension EmptyFriendCell: CellViewBase {
    func setupCellView(model: any CellRowModel) {
        guard let model = model as? EmptyDataCellRowModel else { return }
        
        self.emptyImageView?.image = .init(named: model.imageName)
        self.titleLabel.text = model.title
        self.messageLabel.text = model.message
        self.bottomMessageLabel.attributedText = model.bottomAttr
        self.actionButton.setTitle(model.buttonTitle, for: .normal)
        self.buttonImageView.image = .init(named: model.butttonImageName ?? "")
        
        
    }
    
}
