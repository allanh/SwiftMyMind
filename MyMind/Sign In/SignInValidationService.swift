//
//  SignInValidationService.swift
//  MyMind
//
//  Created by Barry Chen on 2021/3/24.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation

enum ValidationResult: Equatable {
    case valid
    case invalid(String)
}

struct SignInValidatoinService {

    func validateStoreID(_ storeID: String) -> ValidationResult {
        let count = storeID.count
        if count >= 5, count <= 8 {
            return .valid
        } else {
            return .invalid("企業帳號長度為5~8碼")
        }
    }

    func validateAccount(_ account: String) -> ValidationResult {
        let count = account.count
        if count >= 3, count <= 20 {
            return .valid
        } else {
            return .invalid("使用者帳號長度為3~20碼")
        }
    }

    func validatePassword(_ password: String) -> ValidationResult {
        let count = password.count
        if count >= 6, count <= 20 {
            return .valid
        } else {
            return .invalid("密碼長度為6~20碼，英文字母需區分大小寫")
        }
    }

    func validateCaptchaValue(_ captchaValue: String) -> ValidationResult {
        let count = captchaValue.count
        if count == 5 {
            return .valid
        } else {
            return .invalid("驗證碼長度為5碼")
        }
    }

    func validateEmail(_ email: String) -> ValidationResult {
        let isValid = email.range(
            of: #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#,
            options: [.regularExpression, .caseInsensitive]) != nil
        return isValid ? .valid : .invalid("Email 輸入格式錯誤")
    }
}
