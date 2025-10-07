//
//  TableViewAdapter.swift
//  CombineUser
//
//  Created by 陳逸煌 on 2025/9/24.
//

import UIKit

//TODO: - 拓展成section

enum TableViewCellInitType {
    case code(type: UITableViewCell.Type, cellID: String)
    case nib(nibName: String, bundle: Bundle?, cellID: String)
}

protocol CellRowModel {
    func getTableViewCellInitType() -> TableViewCellInitType
    func cellDidSelect(model: CellRowModel)
    var cellDidSelectAction: ((CellRowModel) -> ())? { get set }
}

protocol CellViewBase {
    func setupCellView(model: CellRowModel)
}

class TableViewAdapter: NSObject {
    
    var tableView: UITableView
    
    var rowModels: [CellRowModel] = []
    
    private var refreshControl: UIRefreshControl?
    private var refreshAction: (() -> ())?
    private var refreshAsyncAction: (() async -> ())?
    
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func updateRowModels(_ models: [CellRowModel]) {
        self.rowModels = models
        self.regisCells(models: models)
        self.tableView.reloadData()
    }
    
    func regisCells(models: [CellRowModel]) {
        for model in models {
            switch model.getTableViewCellInitType() {
            case .code(let type, let cellID):
                self.tableView.register(type, forCellReuseIdentifier: cellID)
            case .nib(let nibName, let bundle, let cellID):
                self.tableView.register(UINib(nibName: nibName, bundle: bundle), forCellReuseIdentifier: cellID)
            }
        }
    }
    
    // MARK: - Refresh Control
        
    /// 添加下拉刷新功能（同步版本）
    /// - Parameter action: 下拉時要執行的閉包
    func addRefreshControl(action: @escaping () -> Void) {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        self.tableView.refreshControl = refresh
        self.refreshControl = refresh
        self.refreshAction = action
        self.refreshAsyncAction = nil
    }
    
    /// 添加下拉刷新功能（異步版本，自動結束動畫）
    /// - Parameter action: 下拉時要執行的異步閉包，執行完成後自動結束動畫
    func addRefreshControl(action: @escaping () async -> Void) {
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rowModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.rowModels[indexPath.row]
        
        switch model.getTableViewCellInitType() {
        case .code(_, let cellID), .nib(_, _, let cellID):
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
            if let cell = cell as? CellViewBase {
                cell.setupCellView(model: model)
            }
            return cell
        }
    }
}

extension TableViewAdapter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.rowModels[indexPath.row]
        model.cellDidSelect(model: model)
    }
}
