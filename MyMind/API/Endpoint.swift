//
//  Endpoint.swift
//  MyMind
//
//  Created by Barry Chen on 2021/3/18.
//

import Foundation

enum ServiceType {
    case auth
    case dos
}

struct Endpoint {
    let path: String
    let queryItems: [URLQueryItem]
    let serviceType: ServiceType

    init(path: String, queryItems: [URLQueryItem] = [], serviceType: ServiceType = .dos) {
        self.path = path
        self.queryItems = queryItems
        self.serviceType = serviceType
    }
}

extension Endpoint {
    static let baseAuthURL: String = {
        if let url = Bundle.main.infoDictionary?["AuthServerURL"] as? String {
            return url
        }
        return ""
    }()

    static let baseURL: String = {
        if let url = Bundle.main.infoDictionary?["ServerURL"] as? String {
            return url
        }
        return ""
    }()

    var url: URL {
        var components: URLComponents?
        switch serviceType {
        case .auth: components = URLComponents(string: Endpoint.baseAuthURL)
        case .dos: components = URLComponents(string: Endpoint.baseURL)
        }
        components?.path = path
        components?.queryItems = queryItems

        guard let url = components?.url else {
            preconditionFailure("Invalid URL components: \(String(describing: components))")
        }
        return url
    }
}
// MARK: - Endpoint list
extension Endpoint {
    static var captcha: Self {
        Endpoint(path: "/captcha", serviceType: .auth)
    }

    static var signIn: Self {
        Endpoint(path: "/login", serviceType: .auth)
    }

    static var forgotPassword: Self {
        Endpoint(path: "/forgot_password", serviceType: .auth)
    }

    static func purchaseList(with partnerID: String, purchaseListQueryInfo: PurchaseListQueryInfo? = nil) -> Self {
        var urlQueryItems: [URLQueryItem] = []
        if let query = purchaseListQueryInfo {
            urlQueryItems = query.queryItems
            return Endpoint(path: "/api/admin/v1/purchase", queryItems: urlQueryItems)
        }

        urlQueryItems.append(URLQueryItem(name: "partner_id", value: partnerID))
        return Endpoint(path: "/api/admin/v1/purchase", queryItems: urlQueryItems)
    }
}
