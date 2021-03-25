//
//  ResetPasswordInfo.swift
//  MyMind
//
//  Created by Barry Chen on 2021/3/25.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation

struct ResetPasswordInfo {
    private enum CodingKeys: String, CodingKey {
        case id, account, email, captcha
    }
    private enum CaptchaCodingKeys: String, CodingKey {
        case key, value
    }

    var storeID: String
    var account: String
    var email: String
    var captchaKey: String
    var captchaValue: String
}

extension ResetPasswordInfo: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(storeID, forKey: .id)
        try container.encode(account, forKey: .account)
        try container.encode(email, forKey: .email)

        var captchaContainer = container.nestedContainer(keyedBy: CaptchaCodingKeys.self, forKey: .captcha)
        try captchaContainer.encode(captchaKey, forKey: .key)
        try captchaContainer.encode(captchaValue, forKey: .value)
    }
}
