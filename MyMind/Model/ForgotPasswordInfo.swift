//
//  ForgotPasswordInfo.swift
//  MyMind
//
//  Created by Barry Chen on 2021/3/25.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation

struct ForgotPasswordInfo {
    private enum CodingKeys: String, CodingKey {
        case id, account, email, otp, captcha
    }
    private enum CaptchaCodingKeys: String, CodingKey {
        case key, value
    }

    var storeID: String
    var account: String
    var email: String
    var otp: String?
    var captchaKey: String?
    var captchaValue: String?

    static func empty() -> ForgotPasswordInfo {
        let info = ForgotPasswordInfo(storeID: "", account: "", email: "", otp: nil, captchaKey: nil, captchaValue: nil)
        return info
    }
}

extension ForgotPasswordInfo: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(storeID, forKey: .id)
        try container.encode(account, forKey: .account)
        try container.encode(email, forKey: .email)
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
