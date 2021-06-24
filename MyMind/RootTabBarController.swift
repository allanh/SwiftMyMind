//
//  RootTabBarController.swift
//  MyMind
//
//  Created by Barry Chen on 2021/6/24.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

final class RootTabBarController: UITabBarController {

    private var contentViewControlelrs: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        generateHomeViewController()
        generateMainFunctionEntryViewController()
        viewControllers = contentViewControlelrs
    }

    private func generateHomeViewController() {
        let viewController = HomeViewController()
        viewController.tabBarItem.image = UIImage(named: "home")
        viewController.tabBarItem.title = "首頁"
        contentViewControlelrs.append(viewController)
    }

    private func generateMainFunctionEntryViewController() {
        let viewController = MainFunctionEntryViewController()
        viewController.tabBarItem.image = UIImage(named: "main_function")
        viewController.tabBarItem.title = "功能"
        contentViewControlelrs.append(viewController)
    }
}
