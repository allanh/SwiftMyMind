//
//  AccountSettingViewController.swift
//  MyMind
//
//  Created by Shih Allan on 2021/11/4.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

protocol SettingViewControllerDelegate: AnyObject {
    func didSignOut()
}

typealias MixedDelegate = SettingViewControllerDelegate & NavigationActionDelegate
typealias SettingInfo = (title: String, icon: String, action: Selector)

class AccountSettingViewController: UIViewController {

    private let serviceInfos: [SettingInfo] = [("帳號資料維護", "account_info_setting", #selector(accountSetting)),
                                               ("密碼修改", "change_password", #selector(passwordSetting)),
                                               ("重新綁定 OTP", "rebind_otp", #selector(rebindOtp))]
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    weak var delegate: MixedDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension AccountSettingViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return serviceInfos.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as? SettingTableViewCell {
            cell.config(with: serviceInfos[indexPath.section])
            return cell
        }
        return UITableViewCell()
    }
    
    
}
extension AccountSettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        perform(serviceInfos[indexPath.section].action)
    }
}

extension AccountSettingViewController {
    @objc
    func accountSetting() {
//        let storyboard: UIStoryboard = UIStoryboard(name: "TOTP", bundle: nil)
//        let viewController = storyboard.instantiateViewController(withIdentifier: "SecretListViewController")
//        show(viewController, sender: self)
    }
    
    @objc
    func passwordSetting() {
//        MyMindEmployeeAPIService.shared.authorization()
//            .done { authorization in
//                let rootTabBarViewController = RootTabBarController(authorization: authorization)
//                self.show(rootTabBarViewController, sender: self)
//            }
//            .ensure {
//            }
//            .catch { error in
//                if let apiError = error as? APIError {
//                    _ = ErrorHandler.shared.handle(apiError, forceAction: true)
//                } else {
//                    ToastView.showIn(self, message: error.localizedDescription)
//                }
//            }
    }
    
    @objc
    func rebindOtp() {
    }
}
