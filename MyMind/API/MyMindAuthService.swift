//
//  SignInService.swift
//  MyMind
//
//  Created by Barry Chen on 2021/3/18.
//

import Foundation
import RxSwift
import PromiseKit
struct BindingInfo {
    private enum CodingKeys: String, CodingKey {
        case uuid = "device_id"
        case id
        case account
    }

    var uuid: String
    var id: String
    var account: String

    static func empty() -> BindingInfo {
        let info = BindingInfo(uuid: "", id: "", account: "")
        return info
    }
}

extension BindingInfo: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uuid, forKey: .uuid)
        try container.encode(id, forKey: .id)
        try container.encode(account, forKey: .account)
    }
}

class MyMindAuthService: PromiseKitAPIService, AuthService {
    func captcha() -> Promise<CaptchaSession> {
        let request = request(endPoint: Endpoint.captcha, httpHeader: ["Origin": Endpoint.baseURL])
        return sendRequest(request: request)
    }

    func signIn(info: SignInInfo) -> Promise<UserSession> {
        guard let body = try? JSONEncoder().encode(info) else {
            return .init(error: APIError.parseError)
        }
        let request = request(endPoint: Endpoint.signIn, httpMethod: "POST", httpHeader: ["Origin": Endpoint.baseURL], httpBody: body)
        return sendRequest(request: request)
    }

    func forgotPasswordMail(info: ForgotPasswordInfo) -> Promise<Void> {
        guard let body = try? JSONEncoder().encode(info) else {
            return .init(error: APIError.parseError)
        }
        let request = request(endPoint: Endpoint.forgotPassword, httpMethod: "POST", httpHeader: ["Origin": Endpoint.baseURL], httpBody: body)
        return sendRequest(request: request)
    }
    func resendOTPMail(info: ResendOTPInfo) -> Promise<Void> {
        guard let body = try? JSONEncoder().encode(info) else {
            return .init(error: APIError.parseError)
        }
        let request = request(endPoint: Endpoint.otpSecret, httpMethod: "PUT", httpHeader: ["Origin": Endpoint.baseURL], httpBody: body)
        return sendRequest(request: request)
    }
    func time() -> Promise<ServerTime> {
        let request = request(endPoint: Endpoint.time, httpHeader: ["Origin": Endpoint.baseURL])
        return sendRequest(request: request)
    }
    func binding(info: BindingInfo) -> Promise<Void> {
        guard let body = try? JSONEncoder().encode(info) else {
            return .init(error: APIError.parseError)
        }
        let request = request(endPoint: Endpoint.bind, httpMethod: "PATCH", httpHeader: ["Origin": Endpoint.baseURL], httpBody: body)
        return sendRequest(request: request)
    }
}
