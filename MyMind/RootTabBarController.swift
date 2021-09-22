//
//  RootTabBarController.swift
//  MyMind
//
//  Created by Barry Chen on 2021/6/24.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
final class RootTabBarController: UITabBarController {

    override var childForStatusBarStyle: UIViewController? {
        return selectedViewController
    }
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
        addCustomBackNavigationItem()
        title = "My Mind 買賣後台"
        navigationItem.backButtonTitle = ""
        addRightBarItem()
        generateHomeViewController()
        generateMainFunctionEntryViewController()
        generateAccountViewController()
        viewControllers = contentViewControlelrs
    }
    private func loadNotifications() {
        let announcementLoader = MyMindAnnouncementAPIService.shared
        
        announcementLoader.notifications()
            .done { notifications in
                self.navigationItem.rightBarButtonItem?.updateBadge(number: notifications.unreaded)
            }
            .catch { error in
                ToastView.showIn(self, message: error.localizedDescription)
            }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadNotifications()
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.pingFangTCSemibold(ofSize: 18)
        ]
        appearance.backgroundColor = UIColor(hex: "060d32")
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    @objc
    private func showAnnouncement(_ sender: Any?) {
        show(AnnouncementListViewController(announcementListLoader: MyMindAnnouncementAPIService.shared), sender: nil)
    }
    private func addRightBarItem() {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "bell")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(showAnnouncement(_:)), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = barButton
    }
    private func generateHomeViewController() {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Home") as? HomeViewController {
            viewController.authorization = authorization
            viewController.tabBarItem.image = UIImage(named: "home")
            viewController.tabBarItem.title = "首頁"
            contentViewControlelrs.append(viewController)
       } else {
            let viewController = HomeViewController()
            viewController.tabBarItem.image = UIImage(named: "home")
            viewController.tabBarItem.title = "首頁"
            contentViewControlelrs.append(viewController)
        }
    }

    private func generateMainFunctionEntryViewController() {
        let viewController = MainFunctionEntryViewController()
        viewController.authorization = authorization
        viewController.tabBarItem.image = UIImage(named: "functions")
        viewController.tabBarItem.title = "功能"
        contentViewControlelrs.append(viewController)
    }
    
    private func generateAccountViewController() {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Setting") as? SettingViewController {
            viewController.delegate = self
            viewController.tabBarItem.image = UIImage(named: "account_icon")
            viewController.tabBarItem.title = "帳號"
            contentViewControlelrs.append(viewController)
        }
    }
}
extension RootTabBarController: MixedDelegate {
    func didSignOut() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    func didCancel() {
        self.navigationController?.popViewController(animated: true)
    }
}
