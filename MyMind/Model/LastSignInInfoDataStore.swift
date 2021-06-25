//
//  LastSignInInfoDataStore.swift
//  MyMind
//
//  Created by Barry Chen on 2021/5/24.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import PromiseKit

protocol LastSignInInfoDataStore {
    func readShouldRememberLastSignAccountFlag() -> Promise<Bool>
    func saveShouldRememberLastSignAccountFlag(_ flag: Bool) -> Promise<Bool>
    func readLastSignInAccountInfo() -> Promise<SignInAccountInfo>
    func saveLastSignInAccountInfo(info: SignInAccountInfo) -> Promise<SignInAccountInfo>
    func removeLastSignInAccountInfo() -> Promise<Void>
}

struct MyMindLastSignInInfoDataStore: LastSignInInfoDataStore {
    let userDefaults: UserDefaults
    let keychainHelper: KeychainHelper

    init(userDefaults: UserDefaults = .standard,
         keychainHelper: KeychainHelper = .default) {
        self.userDefaults = userDefaults
        self.keychainHelper = keychainHelper
    }

    func readShouldRememberLastSignAccountFlag() -> Promise<Bool> {
        return Promise<Bool> { seal in
            let result = userDefaults.bool(forKey: "shouldRememberAccountKey")
            seal.fulfill(result)
        }
    }

    func saveShouldRememberLastSignAccountFlag(_ flag: Bool) -> Promise<Bool> {
        return Promise<Bool> { seal in
            userDefaults.setValue(flag, forKey: "shouldRememberAccountKey")
            seal.fulfill(flag)
        }
    }

    func readLastSignInAccountInfo() -> Promise<SignInAccountInfo> {
        return Promise<SignInAccountInfo> { seal in
            do {
                let info = try keychainHelper.readItem(key: .lastSignInAccountInfo, valueType: SignInAccountInfo.self)
                seal.fulfill(info)
            }
            catch let error {
                seal.reject(error)
            }
        }
    }

    func saveLastSignInAccountInfo(info: SignInAccountInfo) -> Promise<SignInAccountInfo> {
        return Promise<SignInAccountInfo> { seal in
            do {
                try keychainHelper.saveItem(info, for: .lastSignInAccountInfo)
                seal.fulfill(info)
            }
            catch let error {
                seal.reject(error)
            }
        }
    }

    func removeLastSignInAccountInfo() -> Promise<Void> {
        return Promise<Void> { seal in
            do {
                try keychainHelper.removeItem(key: .lastSignInAccountInfo)
                seal.fulfill(())
            }
            catch let error {
                seal.reject(error)
            }
        }
    }
}
