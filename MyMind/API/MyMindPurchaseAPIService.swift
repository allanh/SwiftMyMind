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
//    var userSession: UserSession { get }
    func fetchPurchaseList(purchaseListQueryInfo: PurchaseListQueryInfo?) -> Promise<PurchaseList>
    func fetchProductMaterialList(with query: ProductMaterialQueryInfo) -> Promise<ProductMaterialList>
    func fetchProductMaterialDetail(with id: String) -> Promise<ProductMaterialDetail>
    func fetchPurchaseSuggestionInfos(with productIDs: [String]) -> Promise<PurchaseSuggestionInfoList>
    func fetchPurchaseWarehouseList() -> Promise<[Warehouse]>
}

class MyMindPurchaseAPIService: PromiseKitAPIService {
    private let userSession: UserSession

    private var partnerID: String {
        String(userSession.partnerInfo.id)
    }
    init(userSession: UserSession) {
        self.userSession = userSession
    }

    func fetchPurchaseList(
        purchaseListQueryInfo: PurchaseListQueryInfo? = nil
    ) -> Promise<PurchaseList> {
        let endpoint = Endpoint.purchaseList(with: partnerID, purchaseListQueryInfo: purchaseListQueryInfo)
        let request = request(endPoint: endpoint, httpHeader: ["Authorization": "Bearer \(userSession.token)"])
        return sendRequest(request: request)
    }

    func fetchProductMaterialList(with query: ProductMaterialQueryInfo) -> Promise<ProductMaterialList> {
        let endpoint = Endpoint.productMaterials(query: query)
        let request = request(endPoint: endpoint, httpHeader: ["Authorization": "Bearer \(userSession.token)"])
        return sendRequest(request: request)
    }

    func fetchProductMaterialDetail(with id: String) -> Promise<ProductMaterialDetail> {
        let endpoint = Endpoint.productMaterial(id: id)
        let request = request(endPoint: endpoint, httpHeader: ["Authorization": "Bearer \(userSession.token)"])
        return sendRequest(request: request)
    }

    func fetchPurchaseSuggestionInfos(with productIDs: [String]) -> Promise<PurchaseSuggestionInfoList> {
        let endpoint = Endpoint.purchaseSuggestionInfos(productIDs: productIDs)
        let request = request(endPoint: endpoint, httpHeader: ["Authorization": "Bearer \(userSession.token)"])
        return sendRequest(request: request)
    }

    func fetchPurchaseWarehouseList() -> Promise<[Warehouse]> {
        struct Root: Codable {
            let detail: [Warehouse]
        }
        let endpoint = Endpoint.purchaseWarehouseList(partnerID: partnerID)
        let request = request(endPoint: endpoint, httpHeader: ["Authorization": "Bearer \(userSession.token)"])
        let rootResult: Promise<Root> = sendRequest(request: request)
        return rootResult.map({ $0.detail })
    }

    func fetchPurchaseReviewerList(level: Int) -> Promise<[Reviewer]> {
        struct Root: Codable {
            let detail: [Reviewer]
        }
        let endpoint = Endpoint.purchaseReviewerList(partnerID: partnerID, level: String(level))
        let request = request(endPoint: endpoint, httpHeader: ["Authorization": "Bearer \(userSession.token)"])
        let rootRsult: Promise<Root> = sendRequest(request: request)
        return rootRsult.map({ $0.detail })
    }
}

extension MyMindPurchaseAPIService: PurchaseAPIService { }

extension MyMindPurchaseAPIService: PurchaseWarehouseListService { }

extension MyMindPurchaseAPIService: PurchaseReviewerListService { }
