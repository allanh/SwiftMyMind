//
//  MyMindPurchaseAPIService.swift
//  MyMind
//
//  Created by Barry Chen on 2021/4/27.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation

protocol PurchaseAPIService {
    var userSession: UserSession { get }
    func fetchPurchaseList(purchaseListQueryInfo: PurchaseListQueryInfo?, completionHandler: @escaping (Result<PurchaseList, Error>) -> Void)
}

class MyMindPurchaseAPIService: APIService {
    let userSession: UserSession

    init(userSession: UserSession) {
        self.userSession = userSession
    }

    func fetchPurchaseList(
        purchaseListQueryInfo: PurchaseListQueryInfo? = nil,
        completionHandler: @escaping (Result<PurchaseList, Error>) -> Void
    ) {
        guard let token = try? KeychainHelper().readItem(key: .accessToken, valueType: String.self) else {
            completionHandler(Result.failure(APIError.noAccessTokenError))
            return
        }
        let partnerID = String(userSession.partnerInfo.id)
        let endPoint = Endpoint.purchaseList(with: partnerID, purchaseListQueryInfo: purchaseListQueryInfo)
        let request = request(endPoint: endPoint, httpHeader: ["Authorization": "Bearer \(token)"])
        sendRequest(request, completionHandler: completionHandler)
    }
}

extension MyMindPurchaseAPIService: PurchaseAPIService { }
