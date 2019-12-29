//
//  TodayMultipleViewController.swift
//  BetterStore
//
//  Created by new on 12/28/19.
//  Copyright © 2019 Ievgen Gavrysh. All rights reserved.
//

import UIKit

class TodayMultipleAppsController: BaseListController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    
    var results = [FeedResult]()
    
    fileprivate let spacing: CGFloat = 16
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
        collectionView.isScrollEnabled = false
        
        collectionView.register(MultipleAppCell.self, forCellWithReuseIdentifier: cellId)
        
        
        /*
        Service.shared.fetchGames { (appGroup, err) in
            self.results = appGroup?.feed.results ?? []
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }*/
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(4, results.count)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MultipleAppCell
        cell.app = self.results[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height: CGFloat = (view.frame.height - 3 * spacing) / 4
        return .init(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
}
