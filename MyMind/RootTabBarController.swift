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
    var authorization: Authorization?
    convenience init() {
        self.init(authorization: nil)
        }
    init(authorization: Authorization?) {
        self.authorization = authorization
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Mind 買賣後台"
        navigationItem.backButtonTitle = ""
        generateHomeViewController()
        generateMainFunctionEntryViewController()
        viewControllers = contentViewControlelrs
    }

    private func generateHomeViewController() {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Home") as? HomeViewController {
            viewController.authorization = authorization
            viewController.tabBarItem.image = UIImage(named: "home")
            viewController.tabBarItem.title = "首頁"
//            let navigationViewController = UINavigationController(rootViewController: viewController)
            contentViewControlelrs.append(viewController)
       } else {
            let viewController = HomeViewController()
            viewController.tabBarItem.image = UIImage(named: "home")
            viewController.tabBarItem.title = "首頁"
//            let navigationViewController = UINavigationController(rootViewController: viewController)
            contentViewControlelrs.append(viewController)
        }
    }

    private func generateMainFunctionEntryViewController() {
        let viewController = MainFunctionEntryViewController()
        viewController.authorization = authorization
        viewController.tabBarItem.image = UIImage(named: "main_function")
        viewController.tabBarItem.title = "功能"
//        let navigationViewController = UINavigationController(rootViewController: viewController)
        contentViewControlelrs.append(viewController)
    }
}
