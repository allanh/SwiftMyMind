//
//  MyMindEmployeeAPIService.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/4.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import RxSwift
import PromiseKit
class MyMindEmployeeAPIService: PromiseKitAPIService {
    let userSessionDataStore: UserSessionDataStore

    static let shared: MyMindEmployeeAPIService = .init(userSessionDataStore: KeychainUserSessionDataStore())
    
    init(userSessionDataStore: UserSessionDataStore) {
        self.userSessionDataStore = userSessionDataStore
    }
    func authorization() -> Promise<Authorization> {
        guard let userSession = userSessionDataStore.readUserSession() else {
            return .init(error: APIError.noAccessTokenError)
        }

        let request = request(endPoint: .authorization, httpHeader: ["Authorization": "Bearer \(userSession.token)"])
        return sendRequest(request: request)
    }

    func me() -> Promise<Account> {
        guard let userSession = userSessionDataStore.readUserSession() else {
            return .init(error: APIError.noAccessTokenError)
        }
        let request = request(endPoint: .me, httpHeader: ["Authorization": "Bearer \(userSession.token)", "Origin": Endpoint.baseURL])
        return sendRequest(request: request)
    }
    
    func updateAccount(account: Account) -> Promise<Account.Employee> {
        guard let userSession = userSessionDataStore.readUserSession() else {
            return .init(error: APIError.noAccessTokenError)
        }

        guard let body = try? JSONSerialization.data(withJSONObject: account.jsonRepresentation as Any, options: .fragmentsAllowed) else {
            return .init(error: APIError.parseError)
        }

        let request = request(
            endPoint: .me,
            httpMethod: "PUT",
            httpHeader: ["Authorization": "Bearer \(userSession.token)"],
            httpBody: body
        )
        return sendRequest(request: request)

    }
}
