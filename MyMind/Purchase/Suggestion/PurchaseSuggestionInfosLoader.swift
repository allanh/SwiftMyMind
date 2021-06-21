//
//  PurchaseSuggestionInfosLoader.swift
//  MyMind
//
//  Created by Chen Yi-Wei on 2021/6/21.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import PromiseKit

protocol PurchaseSuggestionInfosLoader {
    func loadPurchaseSuggestionInfos(with productIDs: [String]) -> Promise<PurchaseSuggestionInfoList>
}
