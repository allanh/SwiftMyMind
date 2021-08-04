//
//  MainPageViewController.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/15.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
import Firebase

typealias ServiceInfo = (title: String, version: String, icon: String, descriptions: String, action: Selector)
class MainPageViewController: UIViewController {

    private let serviceInfos: [ServiceInfo] = [("My Mind 買賣", "1.0.0", "my_mind_icon", "雲端進銷存．一鍵上架．多通路訂單整合，輕鬆搞定電商營運。", #selector(myMind)), ("OTP 服務", "1.0.0", "otp", "取得My Mind 買賣「一次性動態安全密碼」，保護資訊安全有保障。",#selector(otp))]
    var remoteConfig: RemoteConfig!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let navigationTitleView: UIImageView = UIImageView {
            $0.image = UIImage(named: "udi_logo")
        }
        navigationItem.titleView = navigationTitleView
        navigationItem.backButtonTitle = ""

        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        remoteConfig.fetch { status, error in
            self.remoteConfig.activate()
            do {
                try KeychainHelper.default.saveItem(self.remoteConfig["otp_enable"].boolValue, for: .otpStatus)
            } catch {
                ToastView.showIn(self, message: "save keychain failed")
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension MainPageViewController {
    @objc
    func otp() {
        let storyboard: UIStoryboard = UIStoryboard(name: "TOTP", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SecretListViewController")
        show(viewController, sender: self)
    }
    @objc
    func myMind() {
        MyMindEmployeeAPIService.shared.authorization()
            .done { authorization in
                let rootTabBarViewController = RootTabBarController(authorization: authorization)
                self.show(rootTabBarViewController, sender: self)
            }
            .ensure {
            }
            .catch { error in
                if let apiError = error as? APIError {
                    if apiError == .invalidAccessToken || apiError == .noAccessTokenError {
                        let titleLabel = UILabel()
                        titleLabel.text = "My Mind 買賣後台"
                        titleLabel.textColor = .white
                        self.navigationItem.titleView = titleLabel
                    }
                    _ = ErrorHandler.shared.handle(apiError, controller: self)
                } else {
                    ToastView.showIn(self, message: error.localizedDescription)
                }
            }
    }
}
extension MainPageViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return serviceInfos.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceCell", for: indexPath) as? ServiceCell {
            cell.config(with: serviceInfos[indexPath.section])
            return cell
        }
        return UITableViewCell()
    }
    
    
}
extension MainPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        perform(serviceInfos[indexPath.section].action)
    }
}

class ServiceCell: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var descriptionsLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10
    }
    func config(with service: ServiceInfo) {
        iconImageView.image = UIImage(named: service.icon)
        titleLabel.text = service.title
        versionLabel.text = service.version
        descriptionsLabel.text = service.descriptions
    }
}
