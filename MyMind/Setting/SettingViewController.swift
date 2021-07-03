//
//  SettingViewController.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/3.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
protocol SettingViewControllerDelegate: AnyObject {
    func didSignOut()
    func didCancel()
}
class SettingViewController: UIViewController {

    weak var delegate: SettingViewControllerDelegate?

    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var nameTitleLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTitleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var lastLoginIPLabel: UILabel!
    @IBOutlet weak var lastLoginTimeLabel: UILabel!
    @IBOutlet weak var updateTimeLabel: UILabel!
    var account: Account? {
        didSet {
            DispatchQueue.main.async {
                self.accountLabel.text = self.account?.account
                self.nameTextField.text = self.account?.name
                self.emailTextField.text = self.account?.email
                self.mobileLabel.text = self.account?.mobile
                self.lastLoginIPLabel.text = self.account?.lastLoginIP
                self.lastLoginTimeLabel.text = self.account?.lastLoginTime
                self.updateTimeLabel.text = self.account?.updateTime
            }
        }
    }
    private var isNetworkProcessing: Bool = false {
        didSet {
            switch isNetworkProcessing {
            case true: startAnimatingActivityIndicator()
            case false: stopAnimatinActivityIndicator()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "帳號設定"
        var attributedString = NSMutableAttributedString(string: "*姓名", attributes: [.foregroundColor: UIColor.label])
        attributedString.addAttributes([.foregroundColor : UIColor.red], range: NSRange(location:0,length:1))
        nameTitleLabel.attributedText = attributedString
        attributedString = NSMutableAttributedString(string: "*Email", attributes: [.foregroundColor: UIColor.label])
        attributedString.addAttributes([.foregroundColor : UIColor.red], range: NSRange(location:0,length:1))
        emailTitleLabel.attributedText =  attributedString
        isNetworkProcessing = true
        MyMindUserSessionRepository.shared.me()
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

        // Do any additional setup after loading the view.
    }
    @IBAction func signout(_ sender: Any) {
        if let contentView = navigationController?.view {
            let alertView = CustomAlertView(frame: contentView.bounds, title: "確定登出嗎？", descriptions: "請確定是否要登出。")
            alertView.confirmButton.addAction {
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
    @IBAction func back(_ sender: Any) {
        if let contentView = navigationController?.view {
            let alertView = CustomAlertView(frame: contentView.bounds, title: "確定返回嗎？", descriptions: "返回後本頁面資料將無法儲存，\n請確定是否要返回首頁。")
            alertView.confirmButton.addAction { [weak self] in
                guard let self = self else { return }
                alertView.removeFromSuperview()
                self.delegate?.didCancel()
            }
            alertView.cancelButton.addAction {
                alertView.removeFromSuperview()
            }
            contentView.addSubview(alertView)
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
