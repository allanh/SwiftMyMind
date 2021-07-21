//
//  SignInInfo.swift
//  MyMind
//
//  Created by Barry Chen on 2021/3/19.
//

import Foundation

struct SignInInfo {
    private enum CodingKeys: String, CodingKey {
        case id, account, password, captcha, otp
    }
    private enum CaptchaCodingKeys: String, CodingKey {
        case key, value
    }
    var storeID: String
    var account: String
    var password: String
    var otp: String?
    var captchaKey: String?
    var captchaValue: String?

    init(storeID: String = "", account: String = "", password: String = "", otp: String? = nil, captchaKey: String? = nil, captchaValue: String? = nil) {
        self.storeID = storeID
        self.account = account
        self.password = password
        self.otp = otp
        self.captchaKey = captchaKey
        self.captchaValue = captchaValue
    }
}
extension SignInInfo: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(storeID, forKey: .id)
        try container.encode(account, forKey: .account)
        try container.encode(password, forKey: .password)
        if let otp = otp {
            try container.encode(otp, forKey: .otp)
        }
        if let key = captchaKey, let value = captchaValue {
            var captchaContainer = container.nestedContainer(keyedBy: CaptchaCodingKeys.self, forKey: .captcha)
            try captchaContainer.encode(key, forKey: .key)
            try captchaContainer.encode(value, forKey: .value)
        }
    }
}
