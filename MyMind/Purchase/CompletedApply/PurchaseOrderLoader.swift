//
//  PurchaseOrderLoader.swift
//  MyMind
//
//  Created by Barry Chen on 2021/6/18.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import PromiseKit
struct ExportInfo: Encodable {
    enum ExportType: String, Encodable {
        case purchase = "PURCHASE"
    }
    enum CodingKeys: String, CodingKey {
        case ids = "purchase_id"
        case type = "action_type"
        case remark
    }
    let ids: [String]
    let type: ExportType
    let remark: String?
}


protocol PurchaseOrderLoader {
    func loadPurchaseOrder(with purchaseID: String) -> Promise<PurchaseOrder>
    func exportPurchaseOrder(for info: ExportInfo) -> Promise<Data>
}
