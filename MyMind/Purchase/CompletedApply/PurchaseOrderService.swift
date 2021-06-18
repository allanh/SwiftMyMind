//
//  PurchaseOrderService.swift
//  MyMind
//
//  Created by Barry Chen on 2021/6/18.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import PromiseKit

protocol PurchaseOrderService {
    func fetchPurchaseOrder(with purchaseID: String) -> Promise<PurchaseOrder>
}
