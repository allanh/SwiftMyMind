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
        guard let token = try? KeychainHelper().readItem(key: .accessToken, valueType: String.self) else {
            completionHandler(Result.failure(APIError.noAccessTokenError))
            return
        }
        let endPoint = Endpoint.purchaseList(with: partnerID, purchaseListQueryInfo: purchaseListQueryInfo)
        let request = request(endPoint: endPoint, httpHeader: ["Authorization": "Bearer \(token)"])
        sendRequest(request, completionHandler: completionHandler)
    }
}

extension MyMindPurchaseAPIService: PurchaseAPIService { }
