//
//  SignInAccountInfo.swift
//  MyMind
//
//  Created by Barry Chen on 2021/3/24.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation

struct SignInAccountInfo: Codable {
    let storeID: String
    let account: String

    static func empty() -> SignInAccountInfo {
        return SignInAccountInfo(storeID: "", account: "")
    }
}
