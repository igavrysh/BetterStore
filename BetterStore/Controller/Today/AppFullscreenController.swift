//
//  AppFullscreenController.swift
//  BetterStore
//
//  Created by new on 12/27/19.
//  Copyright © 2019 Ievgen Gavrysh. All rights reserved.
//

import UIKit

class AppFullscreenController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var dismissHandler: (() -> ())?
    var todayItem: TodayItem?
    
    fileprivate let headerCellId = "headerCellId"
    fileprivate let descriptionCellId = "descriptionCellId"
    
    let tableView = UITableView(frame: .zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.clipsToBounds = true
        
        view.addSubview(tableView)
        tableView.fillSuperview()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.register(AppFullscreenHeaderCell.self, forCellReuseIdentifier: headerCellId)
        tableView.register(AppFullscreenDescriptionCell.self, forCellReuseIdentifier: descriptionCellId)
        tableView.contentInsetAdjustmentBehavior = .never
        let height = UIApplication.shared.statusBarFrame.height
        tableView.contentInset = .init(top: 0, left: 0, bottom: height, right: 0)
        setupCloseButton()
    }
    
    let closeButton: UIButton = {
       let button = UIButton(type: .system)
       button.setImage(UIImage(named: "close_button"), for: .normal)
       return button
    }()
     
    fileprivate func setupCloseButton() {
        view.addSubview(closeButton)
        closeButton.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: nil,
            bottom: nil,
            trailing: view.trailingAnchor,
            padding: .init(top: 0, left: 0, bottom: 0, right: 0),
            size: .init(width: 80, height: 40))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.isScrollEnabled = false
            scrollView.isScrollEnabled = true
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.item == 0 {
            let headerCell = tableView.dequeueReusableCell(withIdentifier: headerCellId, for: indexPath) as! AppFullscreenHeaderCell
            closeButton.addTarget(self, action: #selector(handleDismiss(_:)), for: .touchUpInside)
            headerCell.todayCell.todayItem = todayItem
            headerCell.todayCell.layer.cornerRadius = 0
            headerCell.clipsToBounds = true
            headerCell.todayCell.backgroundView = nil
            return headerCell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: descriptionCellId, for: indexPath) as!AppFullscreenDescriptionCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return TodayController.cellSize
        }
        return UITableView.automaticDimension //tableView(tableView, heightForRowAt: indexPath)
    }
    
    @objc func handleDismiss(_ button: UIButton) {
        button.isHidden = true
        tableView.showsVerticalScrollIndicator = false
        dismissHandler?()
    }
}
