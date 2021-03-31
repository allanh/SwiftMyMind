//
//  KeychainHelper.swift
//  MyMind
//
//  Created by Barry Chen on 2021/3/24.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation

public enum KeychainError: Error {
    case noValueFound
    case unexpectedItemData
    case unhandledError(message: String)
}

extension KeychainError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noValueFound:
            return NSLocalizedString("Can not find value for key", comment: "")
        case .unexpectedItemData:
            return NSLocalizedString("Encode or decode failed", comment: "")
        case .unhandledError(let message):
            return NSLocalizedString(message, comment: "")
        }
    }

}

public enum KeychainKeys: String {
    case lastSignInAccountInfo
}
// MARK: - Keychain helper
public struct KeychainHelper {
    let service: String = Bundle.main.bundleIdentifier ?? "com.shopping.udi.Brand-Store-Shopping"

    public func saveItem<T: Codable>(_ value: T, for key: KeychainKeys) throws {
        guard let encodedData = try? JSONEncoder().encode([value]) else {
            throw KeychainError.unexpectedItemData
        }

        var querey = keychainQuery(key: key.rawValue)

        var status = SecItemCopyMatching(querey as CFDictionary, nil)

        switch status {
        case errSecSuccess:
            var attributesToUpdate = [String: AnyObject]()
            attributesToUpdate[kSecValueData as String] = encodedData as AnyObject?

            status = SecItemUpdate(querey as CFDictionary, attributesToUpdate as CFDictionary)

            if status != errSecSuccess {
                throw error(from: status)
            }
        case errSecItemNotFound:
            querey[kSecValueData as String] = encodedData as AnyObject?

            let status = SecItemAdd(querey as CFDictionary, nil)

            guard status == noErr else { throw error(from: status) }
        default:
            throw error(from: status)
        }
    }

    public func readItem<T: Codable>(key: KeychainKeys, valueType: T.Type) throws -> T {
        var query = keychainQuery(key: key.rawValue)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanTrue

        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }

        guard status != errSecItemNotFound else { throw KeychainError.noValueFound }
        guard status == noErr else { throw error(from: status) }

        // Parse the password string from the query result.
        guard let existingItem = queryResult as? [String: AnyObject],
            let encodedData = existingItem[kSecValueData as String] as? Data,
            let valueArray = try? JSONDecoder().decode([T].self, from: encodedData)
            else {
                throw KeychainError.unexpectedItemData
        }
        guard let value = valueArray.first else {
            throw KeychainError.unexpectedItemData
        }
        return value
    }

    /**
     Remove item from keychain.

     if key is nil, will remove all saved items in keychain.

     - Parameter key: the key for the item you want to remove.

     */
    public func removeItem(key: KeychainKeys?) throws {
        let query: [String: AnyObject]
        if let key = key {
            query = keychainQuery(key: key.rawValue, accessGroup: nil)
        } else {
            query = keychainQuery()
        }
        let status = SecItemDelete(query as CFDictionary)

        guard status == noErr || status == errSecItemNotFound else {
            throw error(from: status)
        }
    }

    private func keychainQuery(key: String? = nil, accessGroup: String? = nil) -> [String: AnyObject] {
        var query = [String: AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = service as AnyObject?

        if let key = key {
            query[kSecAttrAccount as String] = key as AnyObject?
        }

        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup as AnyObject?
        }
        return query
    }

    private func error(from status: OSStatus) -> KeychainError {
        if #available(iOS 11.3, *) {
            let message = SecCopyErrorMessageString(status, nil) as String? ?? NSLocalizedString("Unhandled Error", comment: "")
            return KeychainError.unhandledError(message: message)
        } else {
            return KeychainError.unhandledError(message: "Unhandled Error")
        }
    }

    func saveInfoForBiometryLogin(credentials: Credentials) throws {
        let encodedPassword = credentials.password.data(using: String.Encoding.utf8)!

        try? deleteBiometryInfo()

        let access = SecAccessControlCreateWithFlags(nil, // Use the default allocator.
            kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
            .userPresence,
            nil)
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrAccount as String: credentials.account,
                                    kSecAttrServer as String: service,
                                    kSecAttrAccessControl as String: access as Any,
                                    kSecValueData as String: encodedPassword]
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else { throw error(from: status) }
    }

    func readInfoForBiometryLogin() throws -> Credentials {
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrServer as String: service,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: true,
                                    kSecUseOperationPrompt as String: "使用帳號密碼登入",
                                    kSecReturnData as String: true]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else { throw KeychainError.noValueFound }
        guard status == errSecSuccess else { throw error(from: status) }
        guard let existingItem = item as? [String : Any],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: String.Encoding.utf8),
            let account = existingItem[kSecAttrAccount as String] as? String
        else {
            throw KeychainError.unexpectedItemData
        }
        return Credentials(account: account, password: password)
    }

    func deleteBiometryInfo() throws {
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrServer as String: service]

        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else { throw error(from: status) }
    }
}

struct Credentials {
    let account: String
    let password: String
}
