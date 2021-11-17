//
//  PasswordSettingViewController.swift
//  MyMind
//
//  Created by Shih Allan on 2021/11/16.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class PasswordSettingViewController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    var viewModel: SignInViewModel?
    weak var delegate: MixedDelegate?
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var oldPasswordErrorLabel: UILabel!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordErrorLabel: UILabel!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordErrorLabel: UILabel!
    
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
    
    private func showErrorMessage(_ status: AccountValidateStatus) {
        if status.contains(.nameError) {
            oldPasswordErrorLabel.text = "密碼輸入錯誤"
            oldPasswordTextField.layer.borderColor = UIColor.vividRed.cgColor
        }
        if status.contains(.emailError) {
            newPasswordErrorLabel.text = "密碼太短提示：密碼至少6個字元"
            newPasswordTextField.layer.borderColor = UIColor.vividRed.cgColor
        }
        if status.contains(.nameError) {
            confirmPasswordErrorLabel.text = "密碼輸入錯誤"
            confirmPasswordTextField.layer.borderColor = UIColor.vividRed.cgColor
        }
    }
    
    private func clearErrorMessage() {
        oldPasswordErrorLabel.text = nil
        oldPasswordTextField.layer.borderColor = UIColor.lightGray.cgColor
        newPasswordErrorLabel.text = nil
        newPasswordTextField.layer.borderColor = UIColor.lightGray.cgColor
        confirmPasswordErrorLabel.text = nil
        confirmPasswordTextField.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private func createViewModel() {
        var otpEnabled: Bool = false
        do {
            otpEnabled = try KeychainHelper.default.readItem(key: .otpStatus, valueType: Bool.self)
        } catch {
            print(error)
        }
        viewModel = SignInViewModel(
            userSessionRepository: MyMindUserSessionRepository.shared,
            signInValidationService: SignInValidatoinService(),
            lastSignInInfoDataStore: MyMindLastSignInInfoDataStore(),
            otpEnabled: otpEnabled
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clearErrorMessage()
        title = "密碼修改"
        oldPasswordTextField.layer.borderWidth = 1
        newPasswordTextField.layer.borderWidth = 1
        confirmPasswordTextField.layer.borderWidth = 1
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTabBarBackgroundColor(UIColor.prussianBlue)
        addKeyboardObservers()
        addTapToResignKeyboardGesture()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }
    
    @IBAction func save(_ sender: Any) {
//        let newAccount = Account(id: 0, mobile: "", account: "", lastLoginIP: "", lastLoginTime: "", updateTime: "", name: nameTextField.text ?? "", email: emailTextField.text ?? "")
//        let status = newAccount.validate()
//        if status == .valid {
//            clearErrorMessage()
//            isNetworkProcessing = true
//            MyMindEmployeeAPIService.shared.updateAccount(account: newAccount)
//                .ensure {
//                    self.isNetworkProcessing = false
//                }
//                .done {_ in
//                    ToastView.showIn(self, message: "修改成功", iconName: "success", at: .center)
//                }
//                .catch { error in
//                    switch error {
//                    case APIError.serviceError(let message):
//                        ToastView.showIn(self, message: message)
//                    default:
//                        ToastView.showIn(self, message: error.localizedDescription)
//                    }
//                }
//        } else {
//            showErrorMessage(status)
//        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        showAlert(title: "確定返回嗎？", message: "您目前編輯的資料尚未儲存，請確定是否要返回。") { _ in
            self.delegate?.didCancel()
        }
    }
}

extension PasswordSettingViewController {
    func addKeyboardObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(handleContentUnderKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(handleContentUnderKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    func removeObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }

    @objc func handleContentUnderKeyboard(notification: Notification) {
        if let userInfo = notification.userInfo,
           let keyboardEndFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let convertedKeyboardEndFrame = view.convert(keyboardEndFrame.cgRectValue, from: view.window)
            if notification.name == UIResponder.keyboardWillHideNotification {
                scrollView.contentInset = .zero
            } else {
                var insets = scrollView.contentInset
                insets.bottom = convertedKeyboardEndFrame.height
                scrollView.contentInset = insets
            }
        }
    }
}
