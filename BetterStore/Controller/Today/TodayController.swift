//
//  TodayController.swift
//  BetterStore
//
//  Created by new on 12/26/19.
//  Copyright © 2019 Ievgen Gavrysh. All rights reserved.
//

import UIKit

class TodayController: BaseListController, UICollectionViewDelegateFlowLayout {
    
    var statingFrame: CGRect?
    
    fileprivate let cellId = "cellId"
    
    let items = [
        TodayItem.init(
            category: "LIFE HACK",
            title: "Utilizing your Time",
            image: UIImage(named: "garden")!,
            description: "All the tools and apps you need to intelligently organize your life the right way.",
            backgroundColor: .white),
        TodayItem.init(
            category: "HOLIDAYS",
            title: "Travel on a Budget",
            image: UIImage(named: "holiday")!,
            description: "Find our all you needto know on how to travel without packing everything!",
            backgroundColor: .yellow)
    ]
    
    var appFullscreenController: AppFullscreenController!
    
    var topConstraint: NSLayoutConstraint?
    var leadingConstraint: NSLayoutConstraint?
    var widthConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        
        collectionView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        collectionView.register(TodayCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let appFullscreenController = AppFullscreenController()
        appFullscreenController.todayItem = items[indexPath.row]
        appFullscreenController.dismissHandler = { [weak self] () -> () in
            self?.handleFullscreenRemove()
        }
        
        let fullscreenView = appFullscreenController.view!
        
        view.addSubview(fullscreenView)
        self.appFullscreenController = appFullscreenController
        
        addChild(appFullscreenController)

        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        // absolute coordiantes of cell
        guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
        
        self.statingFrame = startingFrame
        fullscreenView.translatesAutoresizingMaskIntoConstraints = false
        topConstraint = fullscreenView.topAnchor.constraint(equalTo: view.topAnchor, constant: startingFrame.origin.y)
        leadingConstraint = fullscreenView.leadingAnchor.constraint(
          equalTo: view.leadingAnchor,
          constant: startingFrame.origin.x)
        widthConstraint = fullscreenView.widthAnchor.constraint(equalToConstant: startingFrame.width)
        heightConstraint = fullscreenView.heightAnchor.constraint(equalToConstant: startingFrame.height)

        [topConstraint, leadingConstraint, widthConstraint, heightConstraint].forEach({ $0?.isActive = true })
        self.view.layoutIfNeeded()
        
        fullscreenView.layer.cornerRadius = 0
        
        UIView.animate(
          withDuration: 0.7,
          delay: 0,
          usingSpringWithDamping: 0.7,
          initialSpringVelocity: 0.7,
          options: .curveEaseOut,
          animations: {
            self.topConstraint?.constant = 0
            self.leadingConstraint?.constant = 0
            self.widthConstraint?.constant = self.view.frame.width
            self.heightConstraint?.constant = self.view.frame.height
            // starts animation
            self.view.layoutIfNeeded()
          },
          completion: nil)
 
    }
    
    fileprivate func handleFullscreenRemove() {
        UIView.animate(
        withDuration: 0.7,
        delay: 0,
        usingSpringWithDamping: 0.7,
        initialSpringVelocity: 0.7,
        options: .curveEaseOut,
        animations: {
          self.appFullscreenController.tableView.contentOffset = .zero
          
          self.appFullscreenController.view?.layer.cornerRadius = 16
        
          guard let startingFrame = self.statingFrame else { return }
          self.topConstraint?.constant = startingFrame.origin.y
          self.leadingConstraint?.constant = startingFrame.origin.x
          self.widthConstraint?.constant = startingFrame.width
          self.heightConstraint?.constant = startingFrame.height
          
          self.view.layoutIfNeeded()
        },
        completion: { _ in
          self.appFullscreenController.view.removeFromSuperview()
          self.appFullscreenController.removeFromParent()
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TodayCell
        cell.todayItem = items[indexPath.item]
        return cell
    }
    
    func collectionView(
      _ collectionView: UICollectionView,
      layout collectionViewLayout: UICollectionViewLayout,
      sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return .init(width: view.frame.width - 64, height: 450)
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
