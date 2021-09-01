//
//  MyMindAnnouncementAPIService.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/8/30.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import RxSwift
import PromiseKit
class MyMindAnnouncementAPIService: PromiseKitAPIService {
    let userSessionDataStore: UserSessionDataStore

    static let shared: MyMindAnnouncementAPIService = .init(userSessionDataStore: KeychainUserSessionDataStore())

    init(userSessionDataStore: UserSessionDataStore) {
        self.userSessionDataStore = userSessionDataStore
    }

    func notifications(number: Int = 3) -> Promise<MyMindNotificationList> {
        guard let userSession = userSessionDataStore.readUserSession() else {
            return .init(error: APIError.noAccessTokenError)
        }
        let endpoint = Endpoint.notifications(number: number)

        let request = request(
            endPoint: endpoint,
            httpHeader: ["Authorization": "Bearer \(userSession.token)"]
        )
        return sendRequest(request: request)
    }
    
    func announcements(info: AnnouncementInfo) -> Promise<AnnouncementList> {
        guard let userSession = userSessionDataStore.readUserSession() else {
            return .init(error: APIError.noAccessTokenError)
        }
        let endpoint = Endpoint.announcements(info: info)

        let request = request(
            endPoint: endpoint,
            httpHeader: ["Authorization": "Bearer \(userSession.token)"]
        )
        return sendRequest(request: request)
    }
    
    func announcement(for id: Int) -> Promise<Announcement> {
        guard let userSession = userSessionDataStore.readUserSession() else {
            return .init(error: APIError.noAccessTokenError)
        }
        let endpoint = Endpoint.announcement(for: id)

        let request = request(
            endPoint: endpoint,
            httpMethod: "PATCH",
            httpHeader: ["Authorization": "Bearer \(userSession.token)"]
        )
        return sendRequest(request: request)
    }
}
