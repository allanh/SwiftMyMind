//
//  RootTabBarController.swift
//  MyMind
//
//  Created by Barry Chen on 2021/6/24.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//
import WidgetKit
import UIKit
import Firebase

final class RootTabBarController: UITabBarController {
    override var childForStatusBarStyle: UIViewController? {
        return selectedViewController
    }
    private var contentViewControlelrs: [UIViewController] = []
    var authorization: Authorization?
    var section: Int?
    
    convenience init() {
        self.init(authorization: nil, section: nil)
    }
    
    init(authorization: Authorization?, section: Int?) {
        self.authorization = authorization
        self.section = section
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        addCustomBackNavigationItem()
        title = "My Mind 買賣後台"
        navigationItem.backButtonTitle = ""
        navigationItem.setHidesBackButton(true, animated: false)
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
        if authorization == nil {
            authorizationAccount()
        }
        setNavigationBarBackgroundColor(UIColor.prussianBlue)
    }
        
    private func authorizationAccount() {
        MyMindEmployeeAPIService.shared.authorization()
            .done { authorization in
                self.authorization = authorization
                self.loadNotifications()
            }
            .ensure {
            }
            .catch { error in
                if let apiError = error as? APIError {
                    _ = ErrorHandler.shared.handle(apiError, forceAction: true)
                } else {
                    ToastView.showIn(self, message: error.localizedDescription)
                }
            }
    }
    
    @objc
    private func showAnnouncement(_ sender: Any?) {
        show(AnnouncementListViewController(announcementListLoader: MyMindAnnouncementAPIService.shared), sender: nil)
    }
    private func addRightBarItem() {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "bell")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(showAnnouncement(_:)), for: .touchUpInside)
        button.touchEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 3)
        let barButton = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = barButton
    }
    
    private func generateHomeViewController() {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Home") as? HomeViewController {
            viewController.authorization = authorization
            viewController.section = section
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
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AccountSettingViewController") as? AccountSettingViewController {
            viewController.delegate = self
            viewController.tabBarItem.image = UIImage(named: "account_icon")
            viewController.tabBarItem.title = "帳號"
            contentViewControlelrs.append(viewController)
        }
    }
}
extension RootTabBarController: MixedDelegate {
    func didSignOut() {
        if #available(iOS 14.0, *) {
            WidgetCenter.shared.reloadTimelines(ofKind: "MyMind_Widget")
            WidgetCenter.shared.reloadTimelines(ofKind: "MyMind_ChartWidget")
        }
        self.navigationController?.popToRootViewController(animated: true)
    }
    func didCancel() {
        self.navigationController?.popViewController(animated: true)
    }
}
