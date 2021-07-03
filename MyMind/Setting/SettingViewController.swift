//
//  SettingViewController.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/3.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
