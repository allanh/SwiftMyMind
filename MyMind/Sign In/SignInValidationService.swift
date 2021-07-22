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
        if count == 0 {
            return .invalid("此欄位必填")
        }
        if count < 6 || count > 20 {
            return .invalid("請輸入 6~20 個半形英文/數字")
        }
        if storeID.contains(" ") {
            return .invalid("此欄位不支援空白")
        }
        do {
            let regex = try NSRegularExpression(pattern: "^[^A-Za-z0-9]$", options: [])
            if regex.firstMatch(in: storeID, options: [], range: NSMakeRange(0, storeID.count)) == nil {
                return .invalid("請輸入半形英文/數字")
            }
        }
        catch {
            return .invalid("請輸入半形英文/數字")
        }
        return .valid
    }

    func validateAccount(_ account: String) -> ValidationResult {
        
        let count = account.count
        if count == 0 {
            return .invalid("此欄位必填")
        }
        if count < 6 || count > 20 {
            return .invalid("請輸入 6~20 個半形英文/數字/符號'.'")
        }
        if account.contains(" ") {
            return .invalid("此欄位不支援空白")
        }
        do {
            let regex = try NSRegularExpression(pattern: "^[A-Za-z0-9.]$", options: [])
            if regex.firstMatch(in: account, options: [], range: NSMakeRange(0, account.count)) == nil {
                return .invalid("請輸入半形英文/數字/符號'.'")
            }
        }
        catch {
            return .invalid("請輸入半形英文/數字/符號'.'")
        }
        return .valid
    }

    func validatePassword(_ password: String) -> ValidationResult {
        let count = password.count
        if count == 0 {
            return .invalid("此欄位必填")
        }
        if count < 6 || count > 20 {
            return .invalid("請輸入 6~20 個半形英文/數字/特殊符號")
        }
        if password.contains(" ") {
            return .invalid("此欄位不支援空白")
        }
        do {
            let regex = try NSRegularExpression(pattern:"(?=.*\\d)(?=.*[a-zA-z])(?=.*[@$!%*#?&])" , options: [])
            if  regex.firstMatch(in: password, options: [], range: NSMakeRange(0, password.count)) == nil {
                return .invalid("請輸入至少各一個半形英文、數字、特殊符號")
            }
        }
        catch {
            return .invalid("請輸入至少各一個半形英文、數字、特殊符號")
        }
        return .valid
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
