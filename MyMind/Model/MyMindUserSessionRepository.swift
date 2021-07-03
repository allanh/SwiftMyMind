//
//  MyMindUserSessionRepository.swift
//  MyMind
//
//  Created by Barry Chen on 2021/5/24.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import PromiseKit

protocol UserSessionDataStore {
    func readUserSession() -> UserSession?
    func saveUserSession(userSession: UserSession) -> Promise<UserSession>
    func deleteUserSession() -> Promise<Void>
}

protocol UserSessionRepository {
    func readUserssion() -> UserSession?
    func signIn(info: SignInInfo) -> Promise<UserSession>
    func signOut() -> Promise<Void>
    func captcha() -> Promise<CaptchaSession>
}

class MyMindUserSessionRepository: UserSessionRepository {

    let dataStore: UserSessionDataStore
    let authService: AuthService
    static let shared: MyMindUserSessionRepository = .init(dataStore: KeychainUserSessionDataStore(), authService: MyMindAuthService())

    init(dataStore: UserSessionDataStore, authService: AuthService) {
        self.dataStore = dataStore
        self.authService = authService
    }

    func readUserssion() -> UserSession? {
        dataStore.readUserSession()
    }

    func signIn(info: SignInInfo) -> Promise<UserSession> {
        authService.signIn(info: info)
            .then(dataStore.saveUserSession(userSession:))
    }

    func signOut() -> Promise<Void> {
        dataStore.deleteUserSession()
    }

    func captcha() -> Promise<CaptchaSession> {
        authService.captcha()
    }
    
    func me() -> Promise<Account> {
        guard let userSession = readUserssion() else {
            return .init(error: APIError.noAccessTokenError)
        }
        return authService.me(userSession.token)
    }
}
