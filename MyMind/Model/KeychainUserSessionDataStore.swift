//
//  KeychainUserSessionDataStore.swift
//  MyMind
//
//  Created by Barry Chen on 2021/5/24.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import PromiseKit

struct KeychainUserSessionDataStore: UserSessionDataStore {
    let keychainHelper: KeychainHelper

    init(keychainHelper: KeychainHelper = .default) {
        self.keychainHelper = keychainHelper
    }

    func readUserSession() -> UserSession? {
        do {
            let userSession = try keychainHelper.readItem(key: .userSession, valueType: UserSession.self)
            return userSession
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }

    func saveUserSession(userSession: UserSession) -> Promise<UserSession> {
        return Promise<UserSession> { seal in
            do {
                try keychainHelper.saveItem(userSession, for: .userSession)
                seal.fulfill(userSession)
            } catch let error {
                seal.reject(error)
            }
        }
    }

    func deleteUserSession() -> Promise<Void> {
        return Promise<Void> { seal in
            do {
                try keychainHelper.removeItem(key: .userSession)
                seal.fulfill(())
            } catch let error {
                seal.reject(error)
            }
        }
    }


}
