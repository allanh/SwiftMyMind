//
//  ApplyPuchaseService.swift
//  MyMind
//
//  Created by Barry Chen on 2021/6/9.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation

protocol ApplyPuchaseService {
    func applyPuchase(purchaseInfo: ApplyPurchaseParameterInfo) -> Promise<String>
}
