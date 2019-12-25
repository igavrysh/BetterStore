//
//  AppsSearchControllerViewController.swift
//  BetterStore
//
//  Created by new on 12/24/19.
//  Copyright © 2019 Ievgen Gavrysh. All rights reserved.
//

import UIKit
import SDWebImage

class AppsSearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    fileprivate let cellId = "id1234"
    
    fileprivate var appResults = [Result]()
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
        collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: cellId)
        
        fetchITunesApps()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 350)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appResults.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchResultCell
        let appResult = appResults[indexPath.item]
        cell.nameLabel.text = appResult.trackName
        cell.categoryLabel.text = appResult.primaryGenreName
        cell.ratingsLabel.text = "Rating: \(appResult.averageUserRating ?? 0)"
        
        let url = URL(string: appResult.artworkUrl100)
        cell.appIconImageView.sd_setImage(with: url)
        
        if (appResult.screenshotUrls.count > 0) {
            cell.screenshot1ImageView.sd_setImage(with: URL(string: appResult.screenshotUrls[0]))
        }
        
        if (appResult.screenshotUrls.count > 1) {
            cell.screenshot2ImageView.sd_setImage(with: URL(string: appResult.screenshotUrls[1]))
        }
        
        if (appResult.screenshotUrls.count > 2) {
            cell.screenshot3ImageView.sd_setImage(with: URL(string: appResult.screenshotUrls[2]))

        }
        
        return cell
    }

    fileprivate func fetchITunesApps() {
        Service.shared.fetchApps { (results, error) in
            
            if let error = error {
                print("Failed to fetch apps: ", error)
                return
            }
            
            self.appResults = results
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}
