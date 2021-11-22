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
        oldPasswordTextField.delegate = self
        newPasswordTextField.delegate = self
        confirmPasswordTextField.delegate = self
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
        let oldPasswordResult = validatePassword(oldPasswordTextField)
        let newPasswordResult = validatePassword(newPasswordTextField)
        let confirmPasswordResult = validatePassword(confirmPasswordTextField)

        if oldPasswordResult && newPasswordResult && confirmPasswordResult {
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
                .catch { error in
                    if let apiError = error as? APIError {
                        _ = ErrorHandler.shared.handle(apiError)
                    } else {
                        ToastView.showIn(self, message: error.localizedDescription)
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
