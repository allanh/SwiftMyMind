//
//  MyMindAnnouncementAPIService.swift
//  MyMind
//
//  Created by Chijung Chan on 2021/8/31.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import PromiseKit

final class MyMindAnnouncementAPIService: PromiseKitAPIService {
    let userSessionDataStore: UserSessionDataStore
    
    static let shared: MyMindAnnouncementAPIService =
        .init(userSessionDataStore: KeychainUserSessionDataStore())
    
    init(userSessionDataStore: UserSessionDataStore) {
        self.userSessionDataStore = userSessionDataStore
    }
    
    
}
extension MyMindAnnouncementAPIService: AnnouncementListLoader {
    func loadAnnouncementList(with announcementListQueryInfo: AnnouncementListQueryInfo?) -> Promise<AnnouncementList> {
        guard let userSession = userSessionDataStore.readUserSession() else {
            return .init(error: APIError.noAccessTokenError)
        }
        let endpoint = Endpoint.announcementList(with: "", announcementListQueryInfo: announcementListQueryInfo)
        let request = request(endPoint: endpoint, httpHeader: ["Authorization":"Bearer \(userSession.token)"])
        return sendRequest(request: request)
    }
    
}
