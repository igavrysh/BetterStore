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
        redViewController.navigationItem.title = "Apps"
        
        let redNavController = UINavigationController(rootViewController: redViewController)
        redNavController.tabBarItem.title = "RED NAV"
        redNavController.navigationBar.prefersLargeTitles = true
        redNavController.tabBarItem.image = UIImage(named: "apps")
        
        let blueViewController = UIViewController()
        blueViewController.view.backgroundColor = .blue
        blueViewController.navigationItem.title = "Search"
        
        let blueNavController = UINavigationController(rootViewController: blueViewController)
        blueNavController.tabBarItem.title = "BLUE NAV"
        blueNavController.navigationBar.prefersLargeTitles = true
        blueNavController.tabBarItem.image = UIImage(named: "search")
        
        viewControllers = [
            redNavController,
            blueNavController
        ]
    }
}
