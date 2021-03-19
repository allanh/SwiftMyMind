//
//  UserSession.swift
//  MyMind
//
//  Created by Barry Chen on 2021/3/19.
//

import Foundation

struct UserSession: Codable {
    struct CustomerInfo: Codable {
        private enum CodingKeys: String, CodingKey {
            case id = "customer_id", name = "customer_name"
        }
        let id: String
        let name: String
    }

    struct BusinessInfo: Codable {
        private enum CodingKeys: String, CodingKey {
            case id = "business_unit_id", name
        }
        let id: String
        let name: String
    }

    struct PartnerInfo: Codable {
        private enum CodingKeys: String, CodingKey {
            case id = "partner_id", name
        }
        let id: String
        let name: String
    }

    struct EmployeeInfo: Codable {
        private enum CodingKeys: String, CodingKey {
            case id = "employee_id", name
        }
        let id: String
        let name: String
    }

    private enum CodingKeys: String, CodingKey {
        case token = "access_token"
        case customerInfo = "customer"
        case businessInfo = "business_unit"
        case partnerInfo = "partner"
        case employeeInfo = "employee"
    }

    let token: String
    let customerInfo: CustomerInfo
    let businessInfo: BusinessInfo
    let partnerInfo: PartnerInfo
    let employeeInfo: EmployeeInfo
}
