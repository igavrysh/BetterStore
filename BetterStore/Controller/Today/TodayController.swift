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
    
    var appFullscreenController: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        
        collectionView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        collectionView.register(TodayCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelectItemAtIndexPath")
        
        let appFullscreenController = AppFullscreenController()
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
        
        redView.frame = startingFrame
        redView.layer.cornerRadius = 0
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            redView.frame = self.view.frame
            
            
            guard let tabBarController = self.tabBarController else { return }
            let frame = tabBarController.tabBar.frame
            let height = frame.size.height
            let offsetY = height
            self.tabBarController?.tabBar.frame = tabBarController.tabBar.frame.offsetBy(dx: 0, dy: offsetY)
            /*
            self.tabBarController?.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
           */
        }, completion: nil)
    }
    
    @objc func handleRemoveRedView(recognizer: UITapGestureRecognizer) {
        print("handleRemoveRedView")
        // access startingFrame
        
        // frames aren't reliable enough for animations
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            recognizer.view?.frame = self.statingFrame ?? .zero
            recognizer.view?.layer.cornerRadius = 16
            
            /*
            self.tabBarController?.tabBar.transform = CGAffineTransform(translationX: 0, y: 0)
             */
            guard let tabBarController = self.tabBarController else { return }
            let frame = tabBarController.tabBar.frame
            let height = frame.size.height
            let offsetY = -height
            self.tabBarController?.tabBar.frame = tabBarController.tabBar.frame.offsetBy(dx: 0, dy: offsetY)
            
        }, completion: { _ in
            recognizer.view?.removeFromSuperview()
            self.appFullscreenController.removeFromParent()
        })
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TodayCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 64, height: 450)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 32, left: 0, bottom: 32, right: 0)
    }
}
