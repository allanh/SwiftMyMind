//
//  MyMindPurchaseAPIService.swift
//  MyMind
//
//  Created by Barry Chen on 2021/4/27.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import PromiseKit

protocol PurchaseAPIService {
    var userSession: UserSession { get }
    func fetchPurchaseList(purchaseListQueryInfo: PurchaseListQueryInfo?) -> Promise<PurchaseList>
    func fetchProductMaterialList(with query: ProductMaterialQueryInfo) -> Promise<ProductMaterialList>
}

class MyMindPurchaseAPIService: PromiseKitAPIService {
    let userSession: UserSession

    init(userSession: UserSession) {
        self.userSession = userSession
    }

    func fetchPurchaseList(
        purchaseListQueryInfo: PurchaseListQueryInfo? = nil
    ) -> Promise<PurchaseList> {

        let partnerID = String(userSession.partnerInfo.id)
        let endPoint = Endpoint.purchaseList(with: partnerID, purchaseListQueryInfo: purchaseListQueryInfo)
        let request = request(endPoint: endPoint, httpHeader: ["Authorization": "Bearer \(userSession.token)"])
        return sendRequest(request: request)
    }

    func fetchProductMaterialList(with query: ProductMaterialQueryInfo) -> Promise<ProductMaterialList> {
        let endPoint = Endpoint.productMaterials(query: query)
        let request = request(endPoint: endPoint, httpHeader: ["Authorization": "Bearer \(userSession.token)"])
        return sendRequest(request: request)
    }
}

extension MyMindPurchaseAPIService: PurchaseAPIService { }
