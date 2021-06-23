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
    func fetchProductMaterialDetail(with id: String) -> Promise<ProductMaterialDetail>
    func fetchPurchaseWarehouseList() -> Promise<[Warehouse]>
}

final class MyMindPurchaseAPIService: PromiseKitAPIService {
    let userSessionDataStore: UserSessionDataStore

    static let shared: MyMindPurchaseAPIService = .init(userSessionDataStore: KeychainUserSessionDataStore())

    init(userSessionDataStore: UserSessionDataStore) {
        self.userSessionDataStore = userSessionDataStore
    }

    func loadPurchaseList(with purchaseListQueryInfo: PurchaseListQueryInfo?) -> Promise<PurchaseList> {
        guard let userSession = userSessionDataStore.readUserSession() else {
            return .init(error: APIError.noAccessTokenError)
        }
        let endpoint = Endpoint.purchaseList(with: "\(userSession.partnerInfo.id)", purchaseListQueryInfo: purchaseListQueryInfo)
        let request = request(endPoint: endpoint, httpHeader: ["Authorization": "Bearer \(userSession.token)"])
        return sendRequest(request: request)
    }

    func loadProductMaterialList(with query: ProductMaterialQueryInfo) -> Promise<ProductMaterialList> {
        guard let userSession = userSessionDataStore.readUserSession() else {
            return .init(error: APIError.noAccessTokenError)
        }
        let endpoint = Endpoint.productMaterials(query: query)
        let request = request(endPoint: endpoint, httpHeader: ["Authorization": "Bearer \(userSession.token)"])
        return sendRequest(request: request)
    }

    func fetchProductMaterialDetail(with id: String) -> Promise<ProductMaterialDetail> {
        guard let userSession = userSessionDataStore.readUserSession() else {
            return .init(error: APIError.noAccessTokenError)
        }
        let endpoint = Endpoint.productMaterial(id: id)
        let request = request(endPoint: endpoint, httpHeader: ["Authorization": "Bearer \(userSession.token)"])
        return sendRequest(request: request)
    }

    func loadPurchaseSuggestionInfos(with productIDs: [String]) -> Promise<PurchaseSuggestionInfoList> {
        guard let userSession = userSessionDataStore.readUserSession() else {
            return .init(error: APIError.noAccessTokenError)
        }
        let endpoint = Endpoint.purchaseSuggestionInfos(productIDs: productIDs)
        let request = request(endPoint: endpoint, httpHeader: ["Authorization": "Bearer \(userSession.token)"])
        return sendRequest(request: request)
    }

    func fetchPurchaseWarehouseList() -> Promise<[Warehouse]> {
        struct Root: Codable {
            let detail: [Warehouse]
        }
        guard let userSession = userSessionDataStore.readUserSession() else {
            return .init(error: APIError.noAccessTokenError)
        }
        let endpoint = Endpoint.purchaseWarehouseList(partnerID: "\(userSession.partnerInfo.id)")
        let request = request(endPoint: endpoint, httpHeader: ["Authorization": "Bearer \(userSession.token)"])
        let rootResult: Promise<Root> = sendRequest(request: request)
        return rootResult.map({ $0.detail })
    }

    func fetchPurchaseReviewerList(level: Int) -> Promise<[Reviewer]> {
        struct Root: Codable {
            let detail: [Reviewer]
        }

        guard let userSession = userSessionDataStore.readUserSession() else {
            return .init(error: APIError.noAccessTokenError)
        }
        let endpoint = Endpoint.purchaseReviewerList(partnerID: "\(userSession.partnerInfo.id)", level: String(level))
        let request = request(endPoint: endpoint, httpHeader: ["Authorization": "Bearer \(userSession.token)"])
        let rootRsult: Promise<Root> = sendRequest(request: request)
        return rootRsult.map({ $0.detail })
    }

    func applyPuchase(purchaseInfo: ApplyPurchaseParameterInfo) -> Promise<String> {
        struct Root: Codable {
            let purchaseID: String

            enum CodingKeys: String, CodingKey {
                case purchaseID = "purchase_id"
            }
        }

        guard let userSession = userSessionDataStore.readUserSession() else {
            return .init(error: APIError.noAccessTokenError)
        }

        let endpoint = Endpoint.purchaseApply

        guard let body = try? JSONEncoder().encode(purchaseInfo) else {
            return .init(error: APIError.parseError)
        }

        let request = request(
            endPoint: endpoint,
            httpMethod: "POST",
            httpHeader: [
                "Authorization": "Bearer \(userSession.token)",
                "Content-Type": "application/json"
            ], httpBody: body)

        let rootRsult: Promise<Root> = sendRequest(request: request)
        return rootRsult.map({ $0.purchaseID })
    }

    func loadPurchaseOrder(with purchaseID: String) -> Promise<PurchaseOrder> {
        let endpoint = Endpoint.purchaseOrder(purchaseID: purchaseID)
        let request = request(endPoint: endpoint)
        return sendRequest(request: request)
    }
}

extension MyMindPurchaseAPIService: PurchaseListLoader { }

extension MyMindPurchaseAPIService: PurchaseAPIService { }

extension MyMindPurchaseAPIService: ProductMaterialListLoader { }

extension MyMindPurchaseAPIService: PurchaseSuggestionInfosLoader { }

extension MyMindPurchaseAPIService: PurchaseWarehouseListService { }

extension MyMindPurchaseAPIService: PurchaseReviewerListService { }

extension MyMindPurchaseAPIService: ApplyPuchaseService { }

extension MyMindPurchaseAPIService: PurchaseOrderLoader { }
