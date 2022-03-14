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
    case push
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

    static let pushURL: String = {
        if let url = Bundle.main.infoDictionary?["PushServerURL"] as? String {
            return url
        }
        return ""
    }()
    
    static let employeePath: String = "/employee"
    
    var url: URL {
        var components: URLComponents?
        switch serviceType {
        case .auth: components = URLComponents(string: Endpoint.baseAuthURL)
        case .dos: components = URLComponents(string: Endpoint.baseURL)
        case .push: components = URLComponents(string: Endpoint.pushURL)
        }

        components?.path = path

        if queryItems.isEmpty == false {
            components?.queryItems = queryItems
        }

        guard let url = components?.url else {
            preconditionFailure("Invalid URL components: \(String(describing: components))")
        }
        return url
    }
}
// MARK: - Endpoint list
extension Endpoint {
    static var time: Self {
        Endpoint(path: "/time", queryItems: [], serviceType: .auth)
    }
    static var captcha: Self {
        Endpoint(path: "/captcha", serviceType: .auth)
    }

    static var signIn: Self {
        Endpoint(path: "/login", serviceType: .auth)
    }

    static var forgotPassword: Self {
        Endpoint(path: "/forgot_password", serviceType: .auth)
    }
    
    static var otpSecret: Self {
        Endpoint(path: "/otp_secret", serviceType: .auth)
    }
    
    static var bind: Self {
        Endpoint(path: "/employee/device_id", serviceType: .auth)
    }
    static var authorization: Self {
        Endpoint(path: "/api/admin/\(version)/authorization", serviceType: .dos)
    }

    static var me: Self {
        Endpoint(path: "/employee/me", serviceType: .auth)
    }
    
    static var password: Self {
        Endpoint(path: "/employee/password", serviceType: .auth)
    }
    
    
    static var purchaseApply: Self {
        Endpoint(path: "/api/admin/\(version)/purchase")
    }

    static func purchaseOrder(purchaseID: String) -> Self {
        return Endpoint(path: "/api/admin/\(version)/purchase/\(purchaseID)")
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
//    static func announcementList(with partnerID: String, announcementListQueryInfo: AnnouncementListQueryInfo? = nil) -> Self {
//        var urlQueryItems: [URLQueryItem] = []
//        urlQueryItems.append(URLQueryItem(name: "partner_id", value: partnerID))
//        if let query = announcementListQueryInfo {
//            urlQueryItems.append(contentsOf: query.quertItems)
//            return Endpoint(path: "/api/admin/\(version)/announcement",queryItems: urlQueryItems)
//        }
//        return Endpoint(path: "/api/admin/\(version)/announcement",queryItems: urlQueryItems)
//    }
    static func purchaseWarehouseList(partnerID: String) -> Self {
        let item = URLQueryItem(name: "partner_id", value: partnerID)
        return Endpoint(path: "/api/admin/\(version)/purchase/warehouse", queryItems: [item])
    }

    static func purchaseReviewerList(partnerID: String, level: String) -> Self {
        let items = [
            URLQueryItem(name: "partner_id", value: partnerID),
            URLQueryItem(name: "type", value: "PURCHASE"),
            URLQueryItem(name: "level", value: level)
        ]
        return Endpoint(path: "/api/admin/\(version)/common/review_id", queryItems: items)
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

    static func productMaterialBrandNameAutoComplete(searchTerm: String, vendorID: String? = nil) -> Self {
        var query: [URLQueryItem] = []
        query.append(URLQueryItem(name: "key", value: "BRAND_NAME"))
        if let vendorID = vendorID {
            query.append(URLQueryItem(name: "vendor_id", value: vendorID))
        }
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

    static func editingAndReviewPurchaseOrder(purchaseID: String) -> Self {
        return Endpoint(path: "/api/admin/\(version)/purchase/\(purchaseID)")
    }
    
    static func returnPurchaseOrder(purchaseID: String) -> Self {
        return Endpoint(path: "/api/admin/\(version)/purchase/\(purchaseID)/return")
    }

    static var exportPurchaseOrder: Self {
        return Endpoint(path: "/api/admin/\(version)/purchase/export")
    }
    
    static func reviewPurchaseList(with partnerID: String, purchaseListQueryInfo: PurchaseListQueryInfo? = nil) -> Self {
        var urlQueryItems: [URLQueryItem] = []
        urlQueryItems.append(URLQueryItem(name: "partner_id", value: partnerID))
        if let query = purchaseListQueryInfo {
            urlQueryItems.append(contentsOf: query.queryItems)
            return Endpoint(path: "/api/admin/\(version)/purchase/review", queryItems: urlQueryItems)
        }
        return Endpoint(path: "/api/admin/\(version)/purchase/review", queryItems: urlQueryItems)
    }
    
    /// Dashboard
    static func todo(partnerID: String, navigationNo: String) -> Self {
        let items = [
            URLQueryItem(name: "partner_id", value: partnerID),
            URLQueryItem(name: "navigation_no", value: navigationNo),
        ]
        return Endpoint(path: "/api/admin/\(version)/dashboard/todo", queryItems: items)
    }
    static func saleReport(partnerID: String, start: Date, end: Date, type: SaleReport.SaleReportType) -> Self {
        let formatter = DateFormatter {
            $0.dateFormat = "yyyy-MM-dd"
        }
        let items = [
            URLQueryItem(name: "partner_id", value: partnerID),
            URLQueryItem(name: "channel_receipt_date_from", value: formatter.string(from: start)+" 00:00:00"),
            URLQueryItem(name: "channel_receipt_date_to", value: formatter.string(from: end)+" 23:59:59")
        ]
        switch type {
        case .byType: return Endpoint(path: "/api/admin/\(version)/dashboard/order_sale_by_type", queryItems: items)
        case .byDate: return Endpoint(path: "/api/admin/\(version)/dashboard/order_sale_by_date", queryItems: items)
        }
    }
    static func skuRankingReport(partnerID: String, start: Date, end: Date, isSet: Bool, order: String, count: Int) -> Self {
        let formatter = DateFormatter {
            $0.dateFormat = "yyyy-MM-dd"
        }
        let items = [
            URLQueryItem(name: "partner_id", value: partnerID),
            URLQueryItem(name: "channel_receipt_date_from", value: formatter.string(from: start)+" 00:00:00"),
            URLQueryItem(name: "channel_receipt_date_to", value: formatter.string(from: end)+" 23:59:59"),
            URLQueryItem(name: "is_set", value: "\(isSet)"),
            URLQueryItem(name: "order_by", value: order),
            URLQueryItem(name: "take", value: "\(count)")
        ]
        return Endpoint(path: "/api/admin/\(version)/dashboard/order_sale_by_sku", queryItems: items)
    }
    static func storeRankingReport(partnerID: String, start: Date, end: Date, order: String) -> Self {
        let formatter = DateFormatter {
            $0.dateFormat = "yyyy-MM-dd"
        }
        let items = [
            URLQueryItem(name: "partner_id", value: partnerID),
            URLQueryItem(name: "channel_receipt_date_from", value: formatter.string(from: start)+" 00:00:00"),
            URLQueryItem(name: "channel_receipt_date_to", value: formatter.string(from: end)+" 23:59:59"),
            URLQueryItem(name: "order_by", value: order)
        ]
        return Endpoint(path: "/api/admin/\(version)/dashboard/order_sale_by_store", queryItems: items)
    }
    static func channelRankingReport(partnerID: String, start: Date, end: Date, order: String) -> Self {
        let formatter = DateFormatter {
            $0.dateFormat = "yyyy-MM-dd"
        }
        let items = [
            URLQueryItem(name: "partner_id", value: partnerID),
            URLQueryItem(name: "channel_receipt_date_from", value: formatter.string(from: start)+" 00:00:00"),
            URLQueryItem(name: "channel_receipt_date_to", value: formatter.string(from: end)+" 23:59:59"),
            URLQueryItem(name: "order_by", value: order)
        ]
        return Endpoint(path: "/api/admin/\(version)/dashboard/order_sale_by_vendor", queryItems: items)
    }
    static func bulletins(number: Int) -> Self {
        return Endpoint(path: "/api/admin/\(version)/dashboard/announcement", queryItems: [URLQueryItem(name: "take", value: String(number))])
    }
    // push
    static var registration: Self {
        Endpoint(path: "/api/\(version)/external/push/device", serviceType: .push)
    }
    static func openMessage(messageID: String) -> Self {
        return Endpoint(path: "/api/\(version)/external/push/message/\(messageID)/is_open", serviceType: .push)
    }
    // notification
    static func notifications(number: Int) -> Self {
        return Endpoint(path: "/api/admin/\(version)/notification", queryItems: [URLQueryItem(name: "take", value: String(number))])
    }
    // announcement
    static func announcements(info: AnnouncementListQueryInfo?) -> Self {
        return Endpoint(path: "/api/admin/\(version)/announcement", queryItems: info?.queryItems ?? [])
    }
    static func announcement(for id: Int) -> Self {
        return Endpoint(path: "/api/admin/\(version)/announcement/\(id)")
    }
}
