//
//  EmptyFriendCell.swift
//  KoKoFriendList
//
//  Created by 陳逸煌 on 2025/10/7.
//

import UIKit

struct EmptyDataCellRowModel: CellRowModel {

    var buttonAction: (()->())?
    
    var cellDidSelectAction: ((any CellRowModel) -> ())?

    
    init(
        buttonAction: (()->())? = nil,
        cellDidSelectAction: ((any CellRowModel) -> Void)? = nil
    ) {
        self.buttonAction = buttonAction
        self.cellDidSelectAction = cellDidSelectAction
    }
    
    
    func getTableViewCellInitType() -> TableViewWidgetsInitType {
        return .nib(nibName: "EmptyDataCell", bundle: nil, viewID: "EmptyDataCell")
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
        
        self.emptyImageView?.image = .init(named: "FriendsEmpty")
        
        self.titleLabel.textColor = .black
        self.titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        self.titleLabel.numberOfLines = 0
        self.titleLabel.textAlignment = .center
        self.titleLabel.text = "就從加好友開始吧:)"
        
        self.messageLabel.textColor = .grayA0A0A0
        self.messageLabel.font = .systemFont(ofSize: 16)
        self.messageLabel.numberOfLines = 0
        self.messageLabel.textAlignment = .center
        self.messageLabel.text = "與好友們一起用 KOKO 聊起來！\n還能互相收付款、發紅包喔：）"
        
        self.emptyImageView.contentMode = .scaleAspectFit
        
        self.actionButton.setTitleColor(.white, for: .normal)
        self.actionButton.setTitle("加好友", for: .normal)
        self.buttonImageView.image = .init(named: "AddFriendWhite")
        
        self.bottomMessageLabel.numberOfLines = 0
        self.bottomMessageLabel.textAlignment = .center
        self.bottomMessageLabel.attributedText = self.createKokoIDAttributedString()
 
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.actionButton.setGradientBackground(startColor: .green56B30B, endColor: .greenA6CC42)
    }
    
    func createKokoIDAttributedString() -> NSAttributedString {
        
        var attributedString = NSMutableAttributedString(string: "")
        attributedString = attributedString.add(text: "幫助好友更快找到你？", attrDict: [.foregroundColor: UIColor.grayA0A0A0, .font: UIFont.systemFont(ofSize: 13)])
        
        attributedString = attributedString.add(text: "設定 KOKO ID", attrDict: [.foregroundColor: UIColor.pinkEC008C, .font: UIFont.systemFont(ofSize: 13), .underlineStyle: NSUnderlineStyle.single.rawValue, .underlineColor: UIColor.pinkEC008C])
    
        
        return attributedString
    }
    
    
}

extension EmptyFriendCell: TableViewWidgetBinding {

    func setupView(model: any TableViewWidgetViewModel) {
        
      
        
        
    }
    
}
