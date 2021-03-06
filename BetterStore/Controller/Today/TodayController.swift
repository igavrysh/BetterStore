//
//  TodayController.swift
//  BetterStore
//
//  Created by new on 12/26/19.
//  Copyright © 2019 Ievgen Gavrysh. All rights reserved.
//

import UIKit

class TodayController: BaseListController, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
    var statingFrame: CGRect?
    
    fileprivate let cellId = "cellId"
    fileprivate let multipleCellId = "multipleCellId"
    fileprivate var anchoredConstraints: AnchoredConstraints?
    
    static let cellSize: CGFloat = 500
    
    var items = [TodayItem]()
    
    var activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .large)
        aiv.color = .darkGray
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    var appFullscreenController: AppFullscreenController!
    
    let blurVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(blurVisualEffectView)
        blurVisualEffectView.fillSuperview()
        blurVisualEffectView.alpha = 0
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.centerInSuperview()
        
        fetchData()
        
        navigationController?.isNavigationBarHidden = true
        
        collectionView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        collectionView.register(TodayCell.self, forCellWithReuseIdentifier: TodayItem.CellType.single.rawValue)
        collectionView.register(
            TodayMultipleAppCell.self,
            forCellWithReuseIdentifier: TodayItem.CellType.multiple.rawValue)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.superview?.setNeedsLayout()
    }
    
    fileprivate func fetchData() {
        let dispatchGroup = DispatchGroup()
        
        var topGrossingGroup: AppGroup?
        var gamesGroup: AppGroup?
        
        dispatchGroup.enter()
        Service.shared.fetchTopGrossing { (appGroup, err) in
            topGrossingGroup = appGroup
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        Service.shared.fetchGames { (appGroup, err) in
            gamesGroup = appGroup
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            print("Finished fetching")
            self.activityIndicatorView.stopAnimating()
            
            self.items = [
                TodayItem.init(
                    category: "LIFE HACK",
                    title: "Utilizing your Time",
                    image: UIImage(named: "garden")!,
                    description: "All the tools and apps you need to intelligently organize your life the right way.",
                    backgroundColor: .white,
                    cellType: .single,
                    apps: []),
                TodayItem.init(
                    category: "Daily List",
                    title: topGrossingGroup?.feed.title ?? "",
                    image: UIImage(named: "garden")!,
                    description: "",
                    backgroundColor: .white,
                    cellType: .multiple,
                    apps: topGrossingGroup?.feed.results ?? []),
                TodayItem.init(
                    category: "Daily List",
                    title: gamesGroup?.feed.title ?? "",
                    image: UIImage(named: "garden")!,
                    description: "",
                    backgroundColor: .white,
                    cellType: .multiple,
                    apps: gamesGroup?.feed.results ?? []),
                TodayItem.init(
                    category: "HOLIDAYS",
                    title: "Travel on a Budget",
                    image: UIImage(named: "holiday")!,
                    description: "Find our all you needto know on how to travel without packing everything!",
                    backgroundColor: UIColor.init(
                        red: 248.0 / 255.0,
                        green: 248.0 / 255.0,
                        blue: 185.0 / 255.0,
                        alpha: 1),
                    cellType: .single,
                    apps: [])
            ]
            
            self.collectionView.reloadData()
        }
    }
    
    fileprivate func showDailyListFullscreen(_ indexPath: IndexPath) {
        let fullController = TodayMultipleAppsController(mode: .fullscreen)
        fullController.apps = self.items[indexPath.item].apps
        fullController.modalPresentationStyle = .fullScreen
        let navigationController = BackEnabledNavigationController(rootViewController: fullController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch items[indexPath.item].cellType {
        case .multiple:
            showDailyListFullscreen(indexPath)
        default:
            showSingleAppFullscreen(indexPath: indexPath)
        }
    }
    
    fileprivate func setupSingleAppFullscreenController(_ indexPath: IndexPath) {
        let appFullscreenController = AppFullscreenController()
        appFullscreenController.todayItem = items[indexPath.row]
        appFullscreenController.dismissHandler = { [weak self] () -> () in
            self?.handleAppFullscreenDismissal()
        }
        self.appFullscreenController = appFullscreenController
        appFullscreenController.view.layer.cornerRadius = 16
        
        // #1 setup our pan gesture
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleDrag(gesture:)))
        gesture.delegate = self
        appFullscreenController.view.addGestureRecognizer(gesture)
        
        // #2 add blur effect view
        
        // # not to interfere with our UITableView scrollin
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    var appFullscreenBeginOffset: CGFloat = 0
    
    @objc fileprivate func handleDrag(gesture: UIPanGestureRecognizer) {
        if gesture.state == .began {
            appFullscreenBeginOffset = appFullscreenController.tableView.contentOffset.y
        }
        
        let translationY = gesture.translation(in: appFullscreenController.view).y
        
        if appFullscreenController.tableView.contentOffset.y > 0 {
            return
        }
        
        if gesture.state == .changed {
            if translationY > 0 {
                let trueOffset = translationY - appFullscreenBeginOffset
                
                var scale = 1 - trueOffset / 1000
                scale = min(1, scale)
                scale = max(0.5, scale)
                //print(trueOffset, scale)
                
                let transform: CGAffineTransform = .init(scaleX: scale, y: scale)
                self.appFullscreenController.view.transform = transform
            }

        } else if gesture.state == .ended {
            if translationY > 0 {
                handleAppFullscreenDismissal()
            }
        }
    }
    
    fileprivate func startingStartingCellFrame(_ indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        // absolute coordiantes of cell
        guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
        
        self.statingFrame = startingFrame
    }
    
    fileprivate func setupAppFullscreenStartingPosition(_ indexPath: IndexPath) {
        let fullscreenView = appFullscreenController.view!
        view.addSubview(fullscreenView)
        
        addChild(appFullscreenController)

        self.collectionView.isUserInteractionEnabled = false
        
        startingStartingCellFrame(indexPath)
         
        guard let startingFrame = self.statingFrame else { return }
        
        self.anchoredConstraints = fullscreenView.anchor(
            top: view.topAnchor,
            leading: view.leadingAnchor,
            bottom: nil,
            trailing: nil,
            padding: .init(top: startingFrame.origin.y, left: startingFrame.origin.x, bottom: 0, right: 0),
            size: .init(width: startingFrame.width, height: startingFrame.height))
        self.view.layoutIfNeeded()
    }
    
    fileprivate func beginAnimationAppFullscreen() {
        UIView.animate(
            withDuration: 0.7,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.7,
            options: .curveEaseOut,
            animations: {
                self.blurVisualEffectView.alpha = 1
                
                self.anchoredConstraints?.top?.constant = 0
                self.anchoredConstraints?.leading?.constant = 0
                self.anchoredConstraints?.width?.constant = self.view.frame.width
                self.anchoredConstraints?.height?.constant = self.view.frame.height

              // starts animation
              self.view.layoutIfNeeded()
              
              self.tabBarController?.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
              
              guard let cell = self.appFullscreenController.tableView.cellForRow(at: [0, 0])
                  as? AppFullscreenHeaderCell else { return }
              cell.todayCell.topConstraint.constant = 48
              cell.layoutIfNeeded()
            },
            completion: nil)
    }
    
    fileprivate func showSingleAppFullscreen(indexPath: IndexPath) {
        setupSingleAppFullscreenController(indexPath)
        
        setupAppFullscreenStartingPosition(indexPath)
        
        beginAnimationAppFullscreen()
    }
    
    fileprivate func handleAppFullscreenDismissal() {
        UIView.animate(
        withDuration: 0.7,
        delay: 0,
        usingSpringWithDamping: 0.7,
        initialSpringVelocity: 0.7,
        options: .curveEaseOut,
        animations: {
            self.blurVisualEffectView.alpha = 0
            
            self.appFullscreenController.view.transform = .identity
            self.appFullscreenController.tableView.contentOffset = .zero
          
            self.appFullscreenController.view?.layer.cornerRadius = 16
        
            guard let startingFrame = self.statingFrame else { return }
            self.anchoredConstraints?.top?.constant = startingFrame.origin.y
            self.anchoredConstraints?.leading?.constant = startingFrame.origin.x
            self.anchoredConstraints?.width?.constant = startingFrame.width
            self.anchoredConstraints?.height?.constant = startingFrame.height
          
            self.view.layoutIfNeeded()
            guard let cell = self.appFullscreenController.tableView.cellForRow(at: [0, 0])
                as? AppFullscreenHeaderCell else { return }
            self.appFullscreenController.closeButton.alpha = 0
            cell.todayCell.topConstraint.constant = 24
            cell.layoutIfNeeded()
        },
        completion: { _ in
          self.appFullscreenController.view.removeFromSuperview()
          self.appFullscreenController.removeFromParent()
            self.collectionView.isUserInteractionEnabled = true
        })
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(
      _ collectionView: UICollectionView,
      cellForItemAt
      indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cellId = items[indexPath.item].cellType.rawValue
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        
        if let cell = cell as? BaseTodayCell {
            cell.todayItem = items[indexPath.item]
        }
        
        (cell as? TodayMultipleAppCell)?.multipleAppsController.collectionView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(handleMultipleAppsTap(gesture:))))
        
        return cell
    }
    
    @objc fileprivate func handleMultipleAppsTap(gesture: UIGestureRecognizer) {
        let tappedView = gesture.view
        var superview = tappedView?.superview
        while superview != nil {
            if let cell = superview as? TodayMultipleAppCell {
                guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
                let apps = self.items[indexPath.item].apps
                
                let fullController = TodayMultipleAppsController(mode: .fullscreen)
                fullController.apps = apps
                
                let navController = BackEnabledNavigationController(rootViewController: fullController)
                
                navController.modalPresentationStyle = .fullScreen
                present(navController, animated: true)
                return
            }
            superview = superview?.superview
        }
    }
    
    func collectionView(
      _ collectionView: UICollectionView,
      layout collectionViewLayout: UICollectionViewLayout,
      sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return .init(width: view.frame.width - 64, height: TodayController.cellSize)
    }
    
    func collectionView(
      _ collectionView: UICollectionView,
      layout collectionViewLayout: UICollectionViewLayout,
      minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 32
    }
    
    func collectionView(
      _ collectionView: UICollectionView,
      layout collectionViewLayout: UICollectionViewLayout,
      insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return .init(top: 32, left: 0, bottom: 32, right: 0)
    }
}
