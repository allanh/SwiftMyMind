//
//  SignInService.swift
//  MyMind
//
//  Created by Barry Chen on 2021/3/18.
//

import Foundation
import RxSwift
import PromiseKit

class MyMindAuthService: PromiseKitAPIService, AuthService {
    func captcha() -> Promise<CaptchaSession> {
        let request = request(endPoint: Endpoint.captcha)
        return sendRequest(request: request)
    }

    func signIn(info: SignInInfo) -> Promise<UserSession> {
        guard let body = try? JSONEncoder().encode(info) else {
            return .init(error: APIError.parseError)
        }
        let request = request(endPoint: Endpoint.signIn, httpMethod: "POST", httpBody: body)
        return sendRequest(request: request)
    }

    func forgotPasswordMail(info: ForgotPasswordInfo) -> Promise<Void> {
        guard let body = try? JSONEncoder().encode(info) else {
            return .init(error: APIError.parseError)
        }
        let request = request(endPoint: Endpoint.forgotPassword, httpMethod: "POST", httpBody: body)
        return sendRequest(request: request)
    }
    
    func me(_ token: String) -> Promise<Account> {
        let request = request(endPoint: .me, httpHeader: ["Authorization": "Bearer \(token)"])
        return sendRequest(request: request)
    }
}
