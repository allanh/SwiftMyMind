//
//  MyMindPushAPIService.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/8/17.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import RxSwift
import PromiseKit
struct RegistrationInfo {
    enum DeviceType: String, Codable {
        case IOS, ANDROID
    }
    private enum CodingKeys: String, CodingKey {
        case token = "device_token"
        case deviceType = "device_type"
        case id = "member_id"
        case name = "device_name"
        case company = "customer_no"
        case business = "business_unit_no"
        case partnerID = "partner_no"
    }
    var token: String
    let deviceType: DeviceType = .IOS
    var id: String?
    var name: String?
    var company: String?
    var business: String?
    var partnerID: String?

    init(token: String, id: String? = nil, name: String? = nil, company: String? = nil, business: String? = nil, partnerID: String? = nil) {
        self.token = token
        self.id = id
        self.name = name
        self.company = company
        self.business = business
        self.partnerID = partnerID
    }
}
extension RegistrationInfo: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(token, forKey: .token)
        try container.encode(deviceType, forKey: .deviceType)
        if let id = id {
            try container.encode(id, forKey: .id)
        }
        if let name = name {
            try container.encode(name, forKey: .name)
        }
        if let company = company {
            try container.encode(company, forKey: .company)
        }
        if let business = business {
            try container.encode(business, forKey: .business)
        }
        if let partnerID = partnerID {
            try container.encode(partnerID, forKey: .partnerID)
        }
    }
}

struct Registration: Codable {
    private enum CodingKeys: String, CodingKey {
        case id = "device_id", isCreated = "is_created"
    }
    let id: String
    let isCreated: String
}
class MyMindPushAPIService: PromiseKitAPIService {
    static func pushAppKey()-> String {
        if let key = Bundle.main.infoDictionary?["PushAppKey"] as? String {
            return key
        }
        return ""
    }

    static let shared: MyMindPushAPIService = MyMindPushAPIService()

    func registration(with info: RegistrationInfo) -> Promise<Registration> {
        guard let body = try? JSONEncoder().encode(info) else {
            return .init(error: APIError.parseError)
        }

        let request = request(endPoint: .registration, httpMethod: "PUT", httpHeader: ["APPKEY": MyMindPushAPIService.pushAppKey()], httpBody: body)
        return sendRequest(request: request)
    }

}
