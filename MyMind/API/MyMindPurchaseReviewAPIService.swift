//
//  MyMindPurchaseReviewAPIService.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/1.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import PromiseKit

final class MyMindPurchaseReviewAPIService: PromiseKitAPIService {
    let userSessionDataStore: UserSessionDataStore

    static let shared: MyMindPurchaseReviewAPIService = .init(userSessionDataStore: KeychainUserSessionDataStore())

    init(userSessionDataStore: UserSessionDataStore) {
        self.userSessionDataStore = userSessionDataStore
    }
    
    func loadPurchaseList(with purchaseListQueryInfo: PurchaseListQueryInfo?) -> Promise<PurchaseList> {
        guard let userSession = userSessionDataStore.readUserSession() else {
            return .init(error: APIError.noAccessTokenError)
        }
        let endpoint = Endpoint.reviewPurchaseList(with: "\(userSession.partnerInfo.id)", purchaseListQueryInfo: purchaseListQueryInfo)
        let request = request(endPoint: endpoint, httpHeader: ["Authorization": "Bearer \(userSession.token)"])
        return sendRequest(request: request)
    }
}
extension MyMindPurchaseReviewAPIService: PurchaseListLoader { }
