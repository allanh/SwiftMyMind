//
//  SignInService.swift
//  MyMind
//
//  Created by Barry Chen on 2021/3/18.
//

import Foundation
import RxSwift

class MyMindSignInService: APIService, SignInService {
    private let baseURL: String = {
        if let url = Bundle.main.infoDictionary?["SignInServerURL"] as? String {
            return url
        }
        return ""
    }()

    private lazy var urlComponents: URLComponents = {
        var components: URLComponents = URLComponents(string: baseURL) ?? URLComponents()
        return components
    }()

    func captcha() -> Single<CaptchaSession> {
        var urlComponents = self.urlComponents
        urlComponents.path = Endpoint().captcha
        let request = dataRequest(urlComponents: urlComponents)
        return request.map {
            let response = try JSONDecoder().decode(Response<CaptchaSession>.self, from: $0.1)
            guard let session = response.data else {
                throw APIError.serviceError(response.message ?? "")
            }
            return session
        }
        .asSingle()
    }

    func signIn(info: SignInInfo) -> Single<UserSession> {
        var urlComponents = self.urlComponents
        urlComponents.path = Endpoint().signIn
        guard let body = try? JSONEncoder().encode(info) else {
            return Single.error(APIError.parseError)
        }
        let request = dataRequest(urlComponents: urlComponents, httpMethod: "POST", httpBody: body)
        return request.map {
            let response = try JSONDecoder().decode(Response<UserSession>.self, from: $0.1)
            guard let session = response.data else {
                throw APIError.serviceError(response.message ?? "")
            }
            return session
        }
        .asSingle()
    }

    func forgotPasswordMail(info: ForgotPasswordInfo) -> Completable {
        var urlComponents = self.urlComponents
        urlComponents.path = Endpoint().forgotPassword
        guard let body = try? JSONEncoder().encode(info) else {
            return Completable.error(APIError.parseError)
        }
        let request = dataRequest(urlComponents: urlComponents, httpMethod: "POST", httpBody: body)
        let response = request.map { (_, data) -> Response<Int> in
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
