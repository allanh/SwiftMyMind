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

}
