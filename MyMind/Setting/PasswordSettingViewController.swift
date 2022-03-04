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
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var oldPasswordErrorLabel: UILabel!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordErrorLabel: UILabel!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordErrorLabel: UILabel!
    
    private let passwordSecureButton: UIButton = UIButton {
        $0.setImage(UIImage(named: "eye_open"), for: .normal)
        $0.setImage(UIImage(named: "eye_close"), for: .selected)
        $0.touchEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
    }
    
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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "密碼修改"
        bannerView.setBackgroundImage("setting_banner")
        oldPasswordTextField.delegate = self
        newPasswordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        oldPasswordTextField.enablePasswordToggle()
        newPasswordTextField.enablePasswordToggle()
        confirmPasswordTextField.enablePasswordToggle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.alpha = 1.0
        addKeyboardObservers()
        addTapToResignKeyboardGesture()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }
    
    @IBAction func save(_ sender: Any) {
        let oldPasswordResult = validatePassword(oldPasswordTextField)
        let newPasswordResult = validatePassword(newPasswordTextField)
        let confirmPasswordResult = validatePassword(confirmPasswordTextField)
        
        if oldPasswordResult && newPasswordResult && confirmPasswordResult {
            // 比對新密碼和確認新密碼字串是否一致
            if newPasswordTextField.text?.elementsEqual(confirmPasswordTextField.text ?? "") != true {
                showErrorMessage(for: newPasswordTextField, message: "密碼輸入錯誤")
                showErrorMessage(for: confirmPasswordTextField, message: "密碼輸入錯誤")
                return
            }
            
            let newPasswordInfo = ChangePasswordInfo(oldPassword: oldPasswordTextField.text ?? "",
                                                     password: newPasswordTextField.text ?? "",
                                                     confirmPassword: confirmPasswordTextField.text ?? "")
            isNetworkProcessing = true
            MyMindEmployeeAPIService.shared.changePassword(info: newPasswordInfo)
                .ensure {
                    self.isNetworkProcessing = false
                }
                .done {_ in
                    ToastView.showIn(self, message: "更新成功", iconName: "success", at: .center)
                }
                .catch { [weak self] error in
                    guard let viewController = self else { return }
                    switch error {
                    case APIError.serviceError(let message):
                        ToastView.showIn(viewController, message: message)
                    default:
                        ToastView.showIn(viewController, message: error.localizedDescription)
                    }
                }
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.delegate?.didCancel()
    }
    
    private func validatePassword(_ textField: UITextField) -> Bool {
        let result = SignInValidatoinService().validatePassword(textField.text ?? "")
        switch result {
        case .valid:
            self.cleanErrorMessage(for: textField)
            return true
        case .invalid(let message):
            self.showErrorMessage(for: textField, message: message)
            return false
        }
    }

    private func showErrorMessage(for textField: UITextField, message: String) {
        textField.layer.borderColor = UIColor.vividRed.cgColor
        switch textField {
        case oldPasswordTextField:
            oldPasswordErrorLabel.text = message
            oldPasswordErrorLabel.isHidden = false
        case newPasswordTextField:
            newPasswordErrorLabel.text = message
            newPasswordErrorLabel.isHidden = false
        case confirmPasswordTextField:
            confirmPasswordErrorLabel.text = message
            confirmPasswordErrorLabel.isHidden = false
        default: break
        }
    }

    private func cleanErrorMessage(for textField: UITextField) {
        textField.layer.borderColor = UIColor.border.cgColor
        switch textField {
        case oldPasswordTextField:
            oldPasswordErrorLabel.isHidden = true
        case newPasswordTextField:
            newPasswordErrorLabel.isHidden = true
        case confirmPasswordTextField:
            confirmPasswordErrorLabel.isHidden = true
        default: break
        }
    }
}

extension PasswordSettingViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Set the maximum character length of a UITextField
        let maxLength = 20
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        if newString.length > maxLength {
            return false
        }
        
        // Allowing only a specified set of characters to be entered into a given text field
        let components = string.components(separatedBy: SignInValidatoinService.passwordChars)
        let filtered = components.joined(separator: "")
        
        if string == filtered {
            return true
        } else {
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        _ = validatePassword(textField)
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
