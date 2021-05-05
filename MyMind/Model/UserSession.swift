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
            case id = "customer_id", name
        }
        let id: Int
        let name: String
    }

    struct BusinessInfo: Codable {
        private enum CodingKeys: String, CodingKey {
            case id = "business_unit_id", name
        }
        let id: Int
        let name: String
    }

    struct PartnerInfo: Codable {
        private enum CodingKeys: String, CodingKey {
            case id = "partner_id", name
        }
        let id: Int
        let name: String
    }

    struct EmployeeInfo: Codable {
        private enum CodingKeys: String, CodingKey {
            case id = "employee_id", name
        }
        let id: Int
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

    init(token: String, customerInfo: UserSession.CustomerInfo, businessInfo: UserSession.BusinessInfo, partnerInfo: UserSession.PartnerInfo, employeeInfo: UserSession.EmployeeInfo) {
        self.token = token
        self.customerInfo = customerInfo
        self.businessInfo = businessInfo
        self.partnerInfo = partnerInfo
        self.employeeInfo = employeeInfo
    }
    // MARK: - For test purpose only
    static let testUserSession: UserSession = UserSession(token: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC9hcGktYWxwaGEtYXV0aC51ZG5zaG9wcGluZy5jb21cL2xvZ2luIiwiaWF0IjoxNjIwMDA3NzA3LCJleHAiOjE2MjAwNTgxMDcsIm5iZiI6MTYyMDAwNzcwNywianRpIjoiQ3FvUGQxcW9DQXp1VTg2ZyIsInN1YiI6MTU1LCJwcnYiOiIyMTY5YjU2YmNiOTZlYzY0ZjBjMWI1MDNjMDJlYWViMjhiYjk0NzI3IiwicGFydG5lcl9pZCI6MywicHJvamVjdF90eXBlIjoiRE9TIiwiYnVzaW5lc3NfdW5pdF9pZCI6M30.mYwDBpy67xUUhHfxc3_WSbUdL47VdqlPSbIr8LwT8tA", customerInfo: .init(id: 5, name: "聯合智網股份有限公司"), businessInfo: .init(id: 3, name: "品牌營銷處"), partnerInfo: .init(id: 3, name: "Anson"), employeeInfo: .init(id: 155, name: "tommy"))
}
