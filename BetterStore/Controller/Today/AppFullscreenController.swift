//
//  AppFullscreenController.swift
//  BetterStore
//
//  Created by new on 12/27/19.
//  Copyright © 2019 Ievgen Gavrysh. All rights reserved.
//

import UIKit

class AppFullscreenController: UITableViewController {
    
    var dismissHandler: (() -> ())?
    var todayItem: TodayItem?
    
    fileprivate let headerCellId = "headerCellId"
    fileprivate let descriptionCellId = "descriptionCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.register(AppFullscreenHeaderCell.self, forCellReuseIdentifier: headerCellId)
        tableView.register(AppFullscreenDescriptionCell.self, forCellReuseIdentifier: descriptionCellId)
    }
     
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.item == 0 {
            let headerCell = tableView.dequeueReusableCell(withIdentifier: headerCellId, for: indexPath) as! AppFullscreenHeaderCell
            headerCell.closeButton.addTarget(self, action: #selector(handleDismiss(_:)), for: .touchUpInside)
            headerCell.todayCell.todayItem = todayItem
            return headerCell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: descriptionCellId, for: indexPath) as!AppFullscreenDescriptionCell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 450
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    @objc func handleDismiss(_ button: UIButton) {
        button.isHidden = true
        tableView.showsVerticalScrollIndicator = false
        dismissHandler?()
    }
}
