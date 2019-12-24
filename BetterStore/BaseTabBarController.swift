//
//  BaseTabBarControllerViewController.swift
//  BetterStore
//
//  Created by new on 12/24/19.
//  Copyright © 2019 Ievgen Gavrysh. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .yellow
        let redViewController = UIViewController()
        redViewController.view.backgroundColor = .red
        redViewController.tabBarController?.title = "RED"
        
        let yellowViewController = UIViewController()
        yellowViewController.view.backgroundColor = .yellow
        yellowViewController.tabBarController?.title = "YELLOW"
        
        let blueViewController = UIViewController()
        blueViewController.view.backgroundColor = .blue
        blueViewController.tabBarController?.title = "BLUE"
        
        viewControllers = [
            redViewController,
            yellowViewController,
            blueViewController
        ]
    }
}
