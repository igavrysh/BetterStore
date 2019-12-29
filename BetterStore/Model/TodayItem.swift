//
//  TodayItem.swift
//  BetterStore
//
//  Created by new on 12/28/19.
//  Copyright © 2019 Ievgen Gavrysh. All rights reserved.
//

import UIKit

struct TodayItem {
    
    let category: String
    let title: String
    let image: UIImage
    let description: String
    let backgroundColor: UIColor
    
    // enum
    let cellType: CellType
    
    let apps: [FeedResult]
    
    enum CellType: String {
        case single, multiple
    }
}
