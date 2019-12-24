//
//  BaseTabBarControllerViewController.swift
//  BetterStore
//
//  Created by new on 12/24/19.
//  Copyright © 2019 Ievgen Gavrysh. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {
    
    // 2 - refactor out repeated logic inside of viewDidLoad
    // 3 - maybe introduc our AppsSearchController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let todayController = UIViewController()
        todayController.view.backgroundColor = .white
        todayController.navigationItem.title = "Today"
        
        let todayNavController = UINavigationController(rootViewController: todayController)
        todayNavController.tabBarItem.title = "Today"
        todayNavController.navigationBar.prefersLargeTitles = true
        todayNavController.tabBarItem.image = UIImage(named: "today")

        //view.backgroundColor = .white
        let redViewController = UIViewController()
        redViewController.view.backgroundColor = .white
        redViewController.navigationItem.title = "Apps"
        
        let redNavController = UINavigationController(rootViewController: redViewController)
        redNavController.tabBarItem.title = "Apps"
        redNavController.navigationBar.prefersLargeTitles = true
        redNavController.tabBarItem.image = UIImage(named: "apps")
        
        let blueViewController = UIViewController()
        blueViewController.view.backgroundColor = .white
        blueViewController.navigationItem.title = "Search"
        
        let blueNavController = UINavigationController(rootViewController: blueViewController)
        blueNavController.tabBarItem.title = "Search"
        blueNavController.navigationBar.prefersLargeTitles = true
        blueNavController.tabBarItem.image = UIImage(named: "search")
        
        //tabBar.tintColor = .yellow
        //tabBar.barTintColor = .green
        
        viewControllers = [
            todayNavController,
            redNavController,
            blueNavController
        ]
    }

}
