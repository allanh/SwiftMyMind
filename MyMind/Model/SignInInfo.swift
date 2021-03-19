//
//  SignInInfo.swift
//  MyMind
//
//  Created by Barry Chen on 2021/3/19.
//

import Foundation

struct SignInInfo {
    private enum CodingKeys: String, CodingKey {
        case id, account, password, captcha
    }
    private enum CaptchaCodingKeys: String, CodingKey {
        case key, value
    }
    var storeID: String
    var account: String
    var password: String
    var captchaKey: String
    var captchaValue: String
}
extension SignInInfo: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(storeID, forKey: .id)
        try container.encode(account, forKey: .account)
        try container.encode(password, forKey: .password)

        var captchaContainer = container.nestedContainer(keyedBy: CaptchaCodingKeys.self, forKey: .captcha)
        try captchaContainer.encode(captchaKey, forKey: .key)
        try captchaContainer.encode(captchaValue, forKey: .value)
    }
}
