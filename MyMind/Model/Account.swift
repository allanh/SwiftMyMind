//
//  Account.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/3.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
struct AccountValidateStatus: OptionSet {
    let rawValue: Int
    static let valid = AccountValidateStatus(rawValue: 1 << 0)
    static let nameError = AccountValidateStatus(rawValue: 1 << 1)
    static let emailError = AccountValidateStatus(rawValue: 1 << 2)
}

struct Account: Codable {
    struct Employee: Codable {
        let id: Int
        private enum CodingKeys: String, CodingKey {
            case id = "employee_id"
        }
    }
    let id: Int
    let mobile: String?
    let account, lastLoginIP, lastLoginTime, updateTime: String
    var name, email: String
    var jsonRepresentation: [String: Any] {
        get {
            return ["name": name, "email": email]
        }
    }
    private enum CodingKeys: String, CodingKey {
        case id = "employee_id", account, name, email, mobile, lastLoginIP = "ip", lastLoginTime = "last_login_at", updateTime = "updated_at"
    }
    func validate() -> AccountValidateStatus {
        var status: AccountValidateStatus = .valid
        if name.count < 1 || name.count > 20 {
            status.update(with: .nameError)
        }
        if SignInValidatoinService().validateEmail(email) != .valid {
            status.update(with: .emailError)
        }
        return status
    }
}
