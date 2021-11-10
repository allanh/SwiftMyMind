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
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var signoutView: UIView!
    @IBOutlet weak var settingTableView: UITableView!
    weak var delegate: MixedDelegate?

    private var isNetworkProcessing: Bool = false {
        didSet {
            switch isNetworkProcessing {
            case true: startAnimatingActivityIndicator()
            case false: stopAnimatinActivityIndicator()
            }
        }
    }
    
    var account: Account? {
        didSet {
            DispatchQueue.main.async {
                self.accountLabel.text = self.account?.name
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingTableView?.deselectSelectedRow(animated: true)
        
        MyMindEmployeeAPIService.shared.me()
            .ensure {
                self.isNetworkProcessing = false
            }
            .done { [weak self] account in
                guard let self = self else { return }
                self.account = account
            }
            .catch { [weak self] error in
                guard let self = self else { return }
                switch error {
                case APIError.serviceError(let message):
                    ToastView.showIn(self, message: message)
                default:
                    ToastView.showIn(self, message: error.localizedDescription)
                }
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isNetworkProcessing = true
        if let session = KeychainUserSessionDataStore().readUserSession() {
            self.unitLabel.text = String(session.businessInfo.name)
        }
        
        signoutView.addTapGesture { [weak self] in
            self?.signout()
        }
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
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Setting") as? SettingViewController {
            viewController.delegate = self.delegate
            viewController.account = self.account
            viewController.tabBarItem.image = UIImage(named: "account_icon")
            viewController.tabBarItem.title = "帳號"
            show(viewController, sender: self)
        }
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
    
    func signout() {
        if let contentView = navigationController?.view {
            let alertView = CustomAlertView(frame: contentView.bounds, title: "確定登出嗎？", descriptions: "請確定是否要登出。")
            alertView.confirmButton.addAction {
                self.isNetworkProcessing = true
                MyMindUserSessionRepository.shared.signOut()
                    .ensure {
                        self.isNetworkProcessing = false
                    }
                    .done { [weak self] in
                        guard let self = self else { return }
                        alertView.removeFromSuperview()
                        self.dismiss(animated: true, completion: nil)
                        self.delegate?.didSignOut()
                    }
                    .catch { [weak self] error in
                        guard let self = self else { return }
                        alertView.removeFromSuperview()
                        ToastView.showIn(self, message: error.localizedDescription)
                    }
            }
            alertView.cancelButton.addAction {
                alertView.removeFromSuperview()
            }
            contentView.addSubview(alertView)
        }
    }
}