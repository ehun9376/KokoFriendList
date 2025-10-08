//
//  TableViewAdapter.swift
//  CombineUser
//
//  Created by 陳逸煌 on 2025/9/24.
//

import UIKit

enum TableViewWidgetsInitType {
    case code(type: UITableViewCell.Type, cellID: String)
    case nib(nibName: String, bundle: Bundle?, viewID: String)
}

protocol TableViewWidgetViewModel {
    func getTableViewCellInitType() -> TableViewWidgetsInitType
}

protocol CellRowModel: TableViewWidgetViewModel {
    func cellDidSelect(model: CellRowModel)
    var cellDidSelectAction: ((CellRowModel) -> ())? { get set }
}

protocol TableViewWidgetBinding {
    func setupView(model: TableViewWidgetViewModel)
}

struct SectionModel {
    var headerViewModel: TableViewWidgetViewModel?
    var rowModels: [CellRowModel]
    
    init(
        headerViewModel: TableViewWidgetViewModel?,
        rowModels: [CellRowModel]
    ) {
        self.headerViewModel = headerViewModel
        self.rowModels = rowModels
    }
}

class TableViewAdapter: NSObject {
    
    var tableView: UITableView
    
    var sectionModels: [SectionModel] = []
    
    private var refreshControl: UIRefreshControl?
    private var refreshAction: (() -> ())?
    private var refreshAsyncAction: (() async -> ())?
    
    init(
        tableView: UITableView
    ) {
        self.tableView = tableView
        super.init()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func updateRowModels(_ models: [SectionModel]) {
        self.sectionModels = models
        self.regisCells(sections: models)
        self.tableView.reloadData()
    }
    
    func regisCells(sections: [SectionModel]) {

        for section in sections {
            if let type = section.headerViewModel?.getTableViewCellInitType() {
                switch type {
                case .nib(let nibName, let bundle, let cellID):
                    self.tableView.register(.init(nibName: nibName, bundle: bundle), forHeaderFooterViewReuseIdentifier: cellID)
                default:
                    fatalError("目前只支援nib的section header")
                }
            }
            
            for rowModel in section.rowModels {
                switch rowModel.getTableViewCellInitType() {
                case .code(let type, let cellID):
                    self.tableView.register(type, forCellReuseIdentifier: cellID)
                case .nib(let nibName, let bundle, let cellID):
                    self.tableView.register(.init(nibName: nibName, bundle: bundle), forCellReuseIdentifier: cellID)
                }
            }
        
        }
    }
    
    // MARK: - Refresh Control
        
    /// 添加下拉刷新功能（同步版本）
    /// - Parameter action: 下拉時要執行的閉包
    func addRefreshControl(action: (() -> ())?) {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        self.tableView.refreshControl = refresh
        self.refreshControl = refresh
        self.refreshAction = action
        self.refreshAsyncAction = nil
    }
    
    /// 添加下拉刷新功能（異步版本，自動結束動畫）
    /// - Parameter action: 下拉時要執行的異步閉包，執行完成後自動結束動畫
    func addRefreshControl(action: (() async -> ())?) {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        self.tableView.refreshControl = refresh
        self.refreshControl = refresh
        self.refreshAsyncAction = action
        self.refreshAction = nil
    }
    
    /// 移除下拉刷新功能
    func removeRefreshControl() {
        self.tableView.refreshControl = nil
        self.refreshControl = nil
        self.refreshAction = nil
        self.refreshAsyncAction = nil
    }
    
    /// 結束刷新動畫
    func endRefreshing() {
        self.refreshControl?.endRefreshing()
    }
    
    /// 開始刷新動畫
    func beginRefreshing() {
        self.refreshControl?.beginRefreshing()
    }
    
    @objc private func handleRefresh() {
        if let asyncAction = self.refreshAsyncAction {
            Task {
                await asyncAction()
                await MainActor.run {
                    self.endRefreshing()
                }
            }
        } else {
            self.refreshAction?()
        }
    }
}

extension TableViewAdapter: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sectionModels[section].rowModels.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.sectionModels[section].headerViewModel == nil ? 0.01 : UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.sectionModels[indexPath.section].rowModels[indexPath.row]
        
        switch model.getTableViewCellInitType() {
        case .code(_, let cellID), .nib(_, _, let cellID):
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
            if let cell = cell as? TableViewWidgetBinding {
                cell.setupView(model: model)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerModel = self.sectionModels[section].headerViewModel else { return nil }
        
        switch headerModel.getTableViewCellInitType() {
        case .nib(_, _, let viewID):
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: viewID) ?? UITableViewHeaderFooterView(reuseIdentifier: viewID)
            if let headerView = headerView as? TableViewWidgetBinding {
                headerView.setupView(model: headerModel )
            }
            return headerView
        default:
            fatalError("目前只支援nib的section header")
        }

    }
}

extension TableViewAdapter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.sectionModels[indexPath.section].rowModels[indexPath.row]
        model.cellDidSelect(model: model)
    }
}
