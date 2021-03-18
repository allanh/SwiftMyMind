//
//  SignInService.swift
//  MyMind
//
//  Created by Barry Chen on 2021/3/18.
//

import Foundation

class SignInService: APIService {
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
}
