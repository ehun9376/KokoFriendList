//
//  SearchBarHeaderView.swift
//  KoKoFriendList
//
//  Created by 陳逸煌 on 2025/10/8.
//

import UIKit

struct SearchFriendHeaderViewModel: TableViewWidgetViewModel {
    func getTableViewCellInitType() -> TableViewWidgetsInitType {
        return .nib(nibName: "SearchFriendHeaderView", bundle: nil, viewID: "SearchFriendHeaderView")
    }
    
    var searchAction: ((String) -> ())?
    
    var focusAction: ((Bool) -> ())?
    
    init(
        searchAction: ((String) -> Void)? = nil,
        focusAction: ((Bool) -> Void)? = nil
    ) {
        self.searchAction = searchAction
        self.focusAction = focusAction
    }
 
}

class SearchFriendHeaderView: UITableViewHeaderFooterView {
    
    var focusAction: ((Bool) -> ())?
    
    var searchAction: ((String) -> ())?
    
    @IBOutlet weak var searchFriendBar: UISearchBar!
    
    @IBOutlet weak var searchFriendImageView: UIImageView!
    
    
    override func awakeFromNib() {
        self.searchFriendBar.delegate = self
        self.searchFriendBar.placeholder = "想轉一筆給誰呢?"
        self.searchFriendImageView.image = .init(named: "AddFriends")
    }
    
}

extension SearchFriendHeaderView: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.focusAction?(true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.focusAction?(false)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchAction?(searchBar.text ?? "")
        self.focusAction?(false)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchAction?(searchText)
    }
        
}

extension SearchFriendHeaderView: TableViewWidgetBinding {
    func setupView(model: TableViewWidgetViewModel) {
        guard let model = model as? SearchFriendHeaderViewModel else { return }
        self.searchAction = model.searchAction
        self.focusAction = model.focusAction
    }
}

