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
        print("didSelectItemAtIndexPath")
        
        let appFullscreenController = AppFullscreenController()
        appFullscreenController.onCloseButtonTouchHandler = { [weak self] () -> () in
            self?.handleFullscreenRemove()
        }
        
        let redView = appFullscreenController.view!
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleRemoveRedView(recognizer:)))
        redView.addGestureRecognizer(recognizer)
        
        view.addSubview(redView)
        self.appFullscreenController = appFullscreenController
        
        addChild(appFullscreenController)

        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        // absolute coordiantes of cell
        guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
        
        self.statingFrame = startingFrame
        redView.translatesAutoresizingMaskIntoConstraints = false
        topConstraint = redView.topAnchor.constraint(equalTo: view.topAnchor, constant: startingFrame.origin.y)
        leadingConstraint = redView.leadingAnchor.constraint(
          equalTo: view.leadingAnchor,
          constant: startingFrame.origin.x)
        widthConstraint = redView.widthAnchor.constraint(equalToConstant: startingFrame.width)
        heightConstraint = redView.heightAnchor.constraint(equalToConstant: startingFrame.height)

        [topConstraint, leadingConstraint, widthConstraint, heightConstraint].forEach({ $0?.isActive = true })
        self.view.layoutIfNeeded()
        
        redView.layer.cornerRadius = 0
        
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
    
    @objc func handleRemoveRedView(recognizer: UITapGestureRecognizer) {
        print("handleRemoveRedView")
        self.handleFullscreenRemove()
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
        return 4
    }
    
    override func collectionView(
      _ collectionView: UICollectionView,
      cellForItemAt
      indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TodayCell
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
