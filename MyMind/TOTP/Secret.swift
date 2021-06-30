//
//  Secret.swift
//  MyMind
//
//  Created by Barry Chen on 2021/6/28.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import SwiftOTP

struct Secret: Equatable {
    enum SecretCodingKeys: String, CodingKey {
        case secret, acc, time, isValid
    }
    let user: String
    let identifier: String
    let registerDate: Date?
    var isValid: Bool

    init(user: String, identifier: String, registerDate: Date? = nil, isValid: Bool = false) {
        self.user = user
        self.identifier = identifier
        self.registerDate = registerDate
        self.isValid = isValid
    }

    init?(url: URL) {
        guard
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
            components.scheme == "otpauth"
        else {
            return nil
        }
        var path: String = components.path

        let pathPrefixString: String = "/UDN:"
        if path.hasPrefix(pathPrefixString) {
            path.removeFirst(pathPrefixString.count)
        }
        user = path

        let queryItem = components.queryItems ?? []

        guard
            let secretQuery = queryItem.first(where: { $0.name == "secret"}),
            let secret = secretQuery.value
        else { return nil }

        identifier = secret
        registerDate = nil
        isValid = false
    }

    func generatePin() -> String {
        guard let data = self.identifier.data(using: .utf8) else { return "" }
        let totp = TOTP(secret: data, digits: 6, timeInterval: 60, algorithm: .sha1)
        let currentDate: Date = Date()

        let pin: String = totp?.generate(time: currentDate) ?? ""
        return pin
    }

    static func generateSecret(with encryptedString: String) -> Secret? {
        var trimmedString: String = encryptedString
        trimmedString.removeFirst(2)

        guard
            let decrytedString = UDI3DESCryptor().decrypt(value: trimmedString),
            let data = decrytedString.data(using: .utf8)
        else {
            return nil
        }

        do {
            let secret = try JSONDecoder.init().decode(Secret.self, from: data)
            return secret
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }

    func calculateProgress() {

    }
}

extension Secret: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SecretCodingKeys.self)
        user = try container.decode(String.self, forKey: .acc)
        identifier = try container.decode(String.self, forKey: .secret)
        if let dateString = try container.decodeIfPresent(String.self, forKey: .time) {
            registerDate = DateFormatter.secretDateFormatter.date(from: dateString)
        } else {
            registerDate = nil
        }

        if let isValid = try container.decodeIfPresent(Bool.self, forKey: .isValid) {
            self.isValid = isValid
        } else {
            self.isValid = false
        }
    }
}
extension Secret: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: SecretCodingKeys.self)
        try container.encode(user, forKey: .acc)
        try container.encode(identifier, forKey: .secret)
        if let date = registerDate {
            let dateString = DateFormatter.secretDateFormatter.string(from: date)
            try container.encode(dateString, forKey: .time)
        }
        try container.encode(isValid, forKey: .isValid)
    }
}