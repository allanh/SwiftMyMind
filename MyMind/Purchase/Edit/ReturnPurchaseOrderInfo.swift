//
//  ReturnPurchaseOrderInfo.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/5.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation

struct ReturnPurchaseOrderParameterInfo: Codable {
    enum ActionType: String, Codable, CustomStringConvertible {
        case VOID, REVOKED, RETURN
        var description: String {
            get {
                switch self {
                case .VOID: return "作廢"
                case .REVOKED: return "撤回"
                case .RETURN: return "退回"
                }
            }
        }
    }
    let action: ActionType
    let remark: String
    enum CodingKeys: String, CodingKey {
        case action = "action_type"
        case remark
    }
}
