//
//  MyMindPurchaseAPIService.swift
//  MyMind
//
//  Created by Barry Chen on 2021/4/27.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation

protocol PurchaseAPIService {
    func fetchPurchaseList(with partnerID: String, purchaseListQueryInfo: PurchaseListQueryInfo?, completionHandler: @escaping (Result<PurchaseList, Error>) -> Void)
}

class MyMindPurchaseAPIService: APIService {
    func fetchPurchaseList(with partnerID: String, purchaseListQueryInfo: PurchaseListQueryInfo? = nil, completionHandler: @escaping (Result<PurchaseList, Error>) -> Void) {
        let endPoint = Endpoint.purchaseList(with: partnerID, purchaseListQueryInfo: purchaseListQueryInfo)
        sendRequest(request(endPoint: endPoint), completionHandler: completionHandler)
    }
}

extension MyMindPurchaseAPIService: PurchaseAPIService { }
