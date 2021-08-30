//
//  RegistrationInfo.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/8/30.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
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

    init(token: String) {
        self.token = token
        if let session = KeychainUserSessionDataStore().readUserSession() {
            self.company = String(session.customerInfo.id)
            self.business = String(session.businessInfo.id)
            self.partnerID = String(session.partnerInfo.id)
            self.id = String(session.employeeInfo.id)
        }
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
