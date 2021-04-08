//
//  SignInService.swift
//  MyMind
//
//  Created by Barry Chen on 2021/3/18.
//

import Foundation
import RxSwift

class MyMindAuthService: APIService, AuthService {
    func captcha() -> Single<CaptchaSession> {
        let task = dataTask(endPoint: Endpoint.captcha)
        return task.map {
            let response = try JSONDecoder().decode(Response<CaptchaSession>.self, from: $0.1)
            guard let session = response.data else {
                throw APIError.serviceError(response.message ?? "")
            }
            return session
        }
        .asSingle()
    }

    func signIn(info: SignInInfo) -> Single<UserSession> {
        guard let body = try? JSONEncoder().encode(info) else {
            return Single.error(APIError.parseError)
        }
        let task = dataTask(endPoint: Endpoint.signIn, httpMethod: "POST", httpBody: body)
        return task.map {
            let response = try JSONDecoder().decode(Response<UserSession>.self, from: $0.1)
            guard let session = response.data else {
                throw APIError.serviceError(response.message ?? "")
            }
            return session
        }
        .asSingle()
    }

    func forgotPasswordMail(info: ForgotPasswordInfo) -> Completable {
        guard let body = try? JSONEncoder().encode(info) else {
            return Completable.error(APIError.parseError)
        }
        let task = dataTask(endPoint: Endpoint.forgotPassword, httpMethod: "POST", httpBody: body)
        let response = task.map { (_, data) -> Response<Int> in
            let response = try JSONDecoder().decode(Response<Int>.self, from: data)
            guard response.status == .SUCCESS else {
                throw APIError.serviceError(response.message ?? "")
            }
            return response
        }
        return response.ignoreElements()
            .asCompletable()
    }
}
