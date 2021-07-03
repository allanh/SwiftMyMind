//
//  Account.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/3.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
struct Account: Codable {
    let id: Int
    let mobile: String?
    let account, name, email, lastLoginIP, lastLoginTime, updateTime: String
    private enum CodingKeys: String, CodingKey {
        case id = "employee_id", account, name, email, mobile, lastLoginIP = "ip", lastLoginTime = "last_login_at", updateTime = "updated_at"
    }
/*
        employee_id    String
        管理員序號

          account    String
        管理員帳號

          name    String
        管理員姓名

          email    String
        Email

          mobile    String
        手機

          ip    String
        最近登入IP

          last_login_at    String
        最近登入時間

          updated_at
 */
}
