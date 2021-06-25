//
//  PurchaseReviewerListLoader.swift
//  MyMind
//
//  Created by Barry Chen on 2021/6/9.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import PromiseKit

protocol PurchaseReviewerListLoader {
    func loadPurchaseReviewerList(level: Int) -> Promise<[Reviewer]>
}
