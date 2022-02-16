//
//  MyMindDashboardAPIService.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/9.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import RxSwift
import PromiseKit

final class MyMindDashboardAPIService: PromiseKitAPIService {
    let userSessionDataStore: UserSessionDataStore

    static let shared: MyMindDashboardAPIService = .init(userSessionDataStore: KeychainUserSessionDataStore())

    init(userSessionDataStore: UserSessionDataStore) {
        self.userSessionDataStore = userSessionDataStore
    }
    
    func todo(with navigationNo: String) -> Promise<ToDoList> {
        guard let userSession = userSessionDataStore.readUserSession() else {
            return .init(error: APIError.noAccessTokenError)
        }

        let endpoint = Endpoint.todo(partnerID: "\(userSession.partnerInfo.id)", navigationNo: navigationNo)


        let request = request(
            endPoint: endpoint,
            httpHeader: ["Authorization": "Bearer \(userSession.token)"]
        )
        return sendRequest(request: request)
    }
    
    func orderSaleReport(start: Date, end: Date, type: SaleReport.SaleReportType) -> Promise<SaleReportList> {
        guard let userSession = userSessionDataStore.readUserSession() else {
            return .init(error: APIError.noAccessTokenError)
        }
        let endpoint = Endpoint.saleReport(partnerID: "\(userSession.partnerInfo.id)", start: start, end: end, type: type)
        let request = request(
            endPoint: endpoint,
            httpHeader: ["Authorization": "Bearer \(userSession.token)"]
        )
        return sendRequest(request: request)
    }
    
    func skuRankingReport(start: Date, end: Date, isSet: Bool, order: String, count: Int) -> Promise<SKURankingReportList> {
        guard let userSession = userSessionDataStore.readUserSession() else {
            return .init(error: APIError.noAccessTokenError)
        }

        let endpoint = Endpoint.skuRankingReport(partnerID: "\(userSession.partnerInfo.id)", start: start, end: end, isSet: isSet, order: order, count: count)

        let request = request(
            endPoint: endpoint,
            httpHeader: ["Authorization": "Bearer \(userSession.token)"]
        )
        return sendRequest(request: request)
    }
    
    func storeRankingReport(start: Date, end: Date, order: String) -> Promise<SaleRankingReportList> {
        guard let userSession = userSessionDataStore.readUserSession() else {
            return .init(error: APIError.noAccessTokenError)
        }

        let endpoint = Endpoint.storeRankingReport(partnerID: "\(userSession.partnerInfo.id)", start: start, end: end, order: order)

        let request = request(
            endPoint: endpoint,
            httpHeader: ["Authorization": "Bearer \(userSession.token)"]
        )
        return sendRequest(request: request)
    }
    
    func vendorRankingReport(start: Date, end: Date, order: String) -> Promise<SaleRankingReportList> {
        guard let userSession = userSessionDataStore.readUserSession() else {
            return .init(error: APIError.noAccessTokenError)
        }

        let endpoint = Endpoint.channelRankingReport(partnerID: "\(userSession.partnerInfo.id)", start: start, end: end, order: order)

        let request = request(
            endPoint: endpoint,
            httpHeader: ["Authorization": "Bearer \(userSession.token)"]
        )
        return sendRequest(request: request)
    }
    func bulletins(number: Int = 3) -> Promise<BulletinList> {
        guard let userSession = userSessionDataStore.readUserSession() else {
            return .init(error: APIError.noAccessTokenError)
        }
        let endpoint = Endpoint.bulletins(number: number)

        let request = request(
            endPoint: endpoint,
            httpHeader: ["Authorization": "Bearer \(userSession.token)"]
        )
        return sendRequest(request: request)
    }
}
