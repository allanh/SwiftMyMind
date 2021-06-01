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

fileprivate enum Version: String {
    case v1
}

fileprivate let version: Version = .v1

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
        urlQueryItems.append(URLQueryItem(name: "partner_id", value: partnerID))
        if let query = purchaseListQueryInfo {
            urlQueryItems.append(contentsOf: query.queryItems)
            return Endpoint(path: "/api/admin/\(version)/purchase", queryItems: urlQueryItems)
        }
        return Endpoint(path: "/api/admin/\(version)/purchase", queryItems: urlQueryItems)
    }

    static func purchaseNumberAutoComplete(searchTerm: String, partnerID: String, vendorID: String? = nil) -> Self {
        var query: [URLQueryItem] = []
        query.append(URLQueryItem(name: "partner_id", value: partnerID))
        query.append(URLQueryItem(name: "key", value: "PURCHASE_NO"))
        if searchTerm.isEmpty == false {
            query.append(URLQueryItem(name: "value", value: searchTerm))
        }
        if let vendorID = vendorID {
            query.append(URLQueryItem(name: "vendor_id", value: vendorID))
        }
        return Endpoint(path: "/api/admin/\(version)/purchase/autocomplete", queryItems: query)
    }

    static func vendorNameAutoComplete(searchTerm: String, partnerID: String) -> Self {
        var query: [URLQueryItem] = []
        query.append(URLQueryItem(name: "partner_id", value: partnerID))
        query.append(URLQueryItem(name: "key", value: "ALIAS_NAME"))
        if searchTerm.isEmpty == false {
            query.append(URLQueryItem(name: "word", value: searchTerm))
        }
        return Endpoint(path: "/api/admin/\(version)/vendor/autocomplete", queryItems: query)
    }

    static func applicantAutoComplete(searchTerm: String) -> Self {
        var query: [URLQueryItem] = []
        query.append(URLQueryItem(name: "key", value: "APPLICANT"))
        if searchTerm.isEmpty == false {
            query.append(URLQueryItem(name: "word", value: searchTerm))
        }
        return Endpoint(path: "/employee/autocomplete", queryItems: query, serviceType: .auth)
    }

    static func productNumberAutoComplete(searchTerm: String) -> Self {
        var query: [URLQueryItem] = []
        query.append(URLQueryItem(name: "key", value: "PRODUCT_NO"))
        if searchTerm.isEmpty == false {
            query.append(URLQueryItem(name: "word", value: searchTerm))
        }

        return Endpoint(path: "/api/admin/\(version)/product/autocomplete", queryItems: query)
    }

    static func productNumberSetAutoComplete(searchTerm: String) -> Self {
        var query: [URLQueryItem] = []
        query.append(URLQueryItem(name: "key", value: "PRODUCT_NO"))
        query.append(URLQueryItem(name: "is_set", value: "true"))
        if searchTerm.isEmpty == false {
            query.append(URLQueryItem(name: "word", value: searchTerm))
        }

        return Endpoint(path: "/api/admin/\(version)/product/autocomplete", queryItems: query)
    }

    static func productMaterials(query: ProductMaterialQueryInfo) -> Self {
        return Endpoint(path: "/api/admin/\(version)/product", queryItems: query.queryItems)
    }

    static func productMaterial(id: String) -> Self {
        return Endpoint(path: "/api/admin/\(version)/product/\(id)")
    }

    static func purchaseSuggestionInfos(productIDs: [String]) -> Self {
        let queryValue = productIDs.joined(separator: ",")
        let query = URLQueryItem(name: "product_id", value: queryValue)
        return Endpoint(path: "/api/admin/\(version)/purchase/product", queryItems: [query])
    }

    static func productMaterialBrandNameAutoComplete(searchTerm: String) -> Self {
        var query: [URLQueryItem] = []
        query.append(URLQueryItem(name: "key", value: "BRAND_NAME"))
        if searchTerm.isEmpty == false {
            query.append(URLQueryItem(name: "word", value: searchTerm))
        }

        return Endpoint(path: "/api/admin/\(version)/product/autocomplete", queryItems: query)
    }

    static func productMaterialOriginalNumberAutoComplete(searchTerm: String) -> Self {
        var query: [URLQueryItem] = []
        query.append(URLQueryItem(name: "key", value: "ORIGINAL_PRODUCT_NO"))
        if searchTerm.isEmpty == false {
            query.append(URLQueryItem(name: "word", value: searchTerm))
        }

        return Endpoint(path: "/api/admin/\(version)/product/autocomplete", queryItems: query)
    }
}
