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
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var versionView: UIView!
    @IBOutlet weak var currentVersionLabel: UILabel!
    @IBOutlet weak var versionStatusLabel: UILabel!
    @IBOutlet weak var signoutView: UIView!
    @IBOutlet weak var settingTableView: UITableView!
    @IBOutlet weak var latedVersionLabel: UILabel!
    
    weak var delegate: MixedDelegate?
    var statusBarFrame: CGRect!
    var statusBarView: UIView!
    var offset: CGFloat!
    
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
                self.accountLabel.text = self.account?.account
            }
        }
    }
    
    var accountUnit: String? {
        didSet {
            DispatchQueue.main.async {
                self.unitLabel.text = self.accountUnit
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.navigationBar.alpha = 0.0
        isNetworkProcessing = true
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
                if let apiError = error as? APIError {
                    _ = ErrorHandler.shared.handle(apiError)
                } else {
                    ToastView.showIn(self, message: error.localizedDescription)
                }
            }
        //header view begins under the navigation bar
        scrollView.contentInsetAdjustmentBehavior = .never
        configStatuView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.alpha = 1.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let session = KeychainUserSessionDataStore().readUserSession() {
            self.accountUnit = String(session.businessInfo.name)
        }
        //required statement to access the scrollViewDidScroll function
        scrollView.delegate = self
        
        titleLabel.roundCorners([.topRight, .bottomRight], radius: 100)

        configTableView()
        setShadow(versionView)
        setShadow(signoutView)

        signoutView.addTapGesture { [weak self] in
            self?.signout()
        }
        checkVersion()
    }
    
    private func configStatuView() {
         //get height of status bar
        
         if #available(iOS 13.0, *) {
             statusBarFrame = UIWindow.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
         } else {
             // Fallback on earlier versions
             statusBarFrame = UIApplication.shared.statusBarFrame
         }

         //initially add a view which overlaps the status bar. Will be altered later.
         statusBarView = UIView(frame: statusBarFrame)
         statusBarView.isOpaque = false
         statusBarView.backgroundColor = .prussianBlue
         view.addSubview(statusBarView)
    }
    
    private func configTableView() {
        settingTableView.layer.cornerRadius = 8
        settingTableView.layer.shadowColor = UIColor.init(hex: "#000000").withAlphaComponent(0.1).cgColor
        settingTableView.layer.shadowOpacity = 1
        settingTableView.layer.shadowOffset = CGSize(width: 0, height: 10)
        settingTableView.layer.shadowRadius = 15
    }
    
    private func setShadow(_ view: UIView) {
        view.layer.cornerRadius = 8
        view.applySketchShadow(
            color: UIColor.init(hex: "#000000").withAlphaComponent(0.1),
            alpha: 1,
            x: 0, y: 10,
            blur: 30,
            spread: 0
        )
    }
    
    // check if the app has a new version
    private func checkVersion() {
        _ = try? VersionManager.shared.isUpdateAvailable { (version, canUpdate, error) in
            if let currentVersion = version, let isUpdateAvailable = canUpdate {
                print("version: \(currentVersion), canUpdate: \(isUpdateAvailable)")
                
                DispatchQueue.main.async { [weak self] in
                    self?.currentVersionLabel.text = "版本 V\(currentVersion)"
                    if isUpdateAvailable {
                        self?.versionStatusLabel.text = "請更新版本"
                        self?.versionStatusLabel.textColor = UIColor.vividRed
                        self?.versionStatusLabel.backgroundColor = UIColor.vividRed.withAlphaComponent(0.2)
                    } else {
                        self?.versionStatusLabel.text = "已為最新版本"
                        self?.versionStatusLabel.textColor = UIColor(hex: "1fa1ff")
                        self?.versionStatusLabel.backgroundColor = UIColor(hex: "1fa1ff").withAlphaComponent(0.2)
                    }
                }
            }
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
        tableView.deselectRow(at: indexPath, animated: true)
        perform(serviceInfos[indexPath.section].action)
    }
}

extension AccountSettingViewController {
    @objc
    func accountSetting() {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Setting") as? SettingViewController {
            viewController.delegate = self.delegate
            viewController.account = self.account
            viewController.accountUnit = self.accountUnit
            show(viewController, sender: self)
        }
    }
    
    @objc
    func passwordSetting() {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "PasswordSetting") as? PasswordSettingViewController {
            viewController.delegate = self.delegate
            viewController.account = self.account
            viewController.accountUnit = self.accountUnit
            show(viewController, sender: self)
        }
    }
    
    @objc
    func rebindOtp() {
        let viewModel = ResendOTPViewModel(authService: MyMindAuthService(),
                                           signInValidationService: SignInValidatoinService()
        )
        let viewController = ResendOTPViewController(viewModel: viewModel)
        show(viewController, sender: self)
    }
    
    func signout() {
        if let contentViewController = navigationController {
            contentViewController.showAlert(title: "確定登出？", message: "確定登出 My mind 賣賣管理平台 ?") { _ in
                self.isNetworkProcessing = true
                MyMindUserSessionRepository.shared.signOut()
                    .ensure {
                        self.isNetworkProcessing = false
                    }
                    .done { [weak self] in
                        guard let self = self else { return }
                        self.dismiss(animated: true, completion: nil)
                        self.delegate?.didSignOut()
                    }
                    .catch { [weak self] error in
                        guard let self = self else { return }
                        if let apiError = error as? APIError {
                            _ = ErrorHandler.shared.handle(apiError)
                        } else {
                            ToastView.showIn(self, message: error.localizedDescription)
                        }
                    }
            }
        }
    }
}

extension AccountSettingViewController {
    //function that is called everytime the scrollView scrolls
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //Mark the end of the offset
        let targetHeight = 200 - (navigationController?.navigationBar.bounds.height)! - statusBarFrame.height
        
        //calculate how much has been scrolled relative to the targetHeight
        offset = scrollView.contentOffset.y / targetHeight
                
        //cap offset to 1 to conform to UIColor alpha parameter
        if offset > 1 {offset = 1}
        if offset > 0 {
            navigationController?.setNavigationBarHidden(false, animated: false)
        } else {
            navigationController?.setNavigationBarHidden(true, animated: false)
        }
        
        self.navigationController?.navigationBar.alpha = offset
        
        //once the scroll reaches halfway to the target, flip the style/color of the status bar
        //this only affect the information in status bar. DOES NOT affect the background color.
//        if offset > 0.5 {
//            self.navigationController?.navigationBar.barStyle = UIBarStyle.default
//        } else {
//            self.navigationController?.navigationBar.barStyle = UIBarStyle.black
//        }
        

//        //Define colors that change based off the offset
//        let clearToWhite = UIColor(red: 1, green: 1, blue: 1, alpha: offset)
//        let whiteToBlack = UIColor(hue: 1, saturation: 0, brightness: 1-offset, alpha: 1 )
//
//        //Dynamically change the color of the barbuttonitems and title
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : whiteToBlack]
//
//        //Dynamically change the background color of the navigation bar
//        self.navigationController?.navigationBar.backgroundColor = clearToWhite
    }
}
