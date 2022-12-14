//
//  MyMindAutoCompleteAPIService.swift
//  MyMind
//
//  Created by Barry Chen on 2021/5/5.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import PromiseKit

protocol AutoCompleteAPIService {
    func purchaseNumberAutoComplete(searchTerm: String) -> Promise<AutoCompleteList>
    func vendorNameAutoComplete(searchTerm: String) -> Promise<AutoCompleteList>
    func applicantAutoComplete(searchTerm: String) -> Promise<AutoCompleteList>
    func productNumberAutoComplete(searchTerm: String) -> Promise<AutoCompleteList>
    func productMaterialBrandNameAutoComplete(searchTerm: String, vendorID: String?) -> Promise<AutoCompleteList>
    func productMaterailOriginalNumberAutoComplete(searchTerm: String) -> Promise<AutoCompleteList>
    func productNumberSetAutoComplete(searchTerm: String) -> Promise<AutoCompleteList>
    func announcementTitleAutoComplete(searchTerm: String) -> Promise<AutoCompleteList>
    func announcementTypeAutoComplete(searchTerm: String) -> Promise<AutoCompleteList>
}

class MyMindAutoCompleteAPIService: PromiseKitAPIService {

    let userSessionDataStore: UserSessionDataStore

    init(userSessionDataStore: UserSessionDataStore) {
        self.userSessionDataStore = userSessionDataStore
    }

    func purchaseNumberAutoComplete(searchTerm: String = "") -> Promise<AutoCompleteList> {
        guard let userSession = userSessionDataStore.readUserSession() else {
            return .init(error: APIError.noAccessTokenError)
        }
        let endPoint = Endpoint.purchaseNumberAutoComplete(searchTerm: searchTerm, partnerID: String(userSession.partnerInfo.id))
        let request = request(endPoint: endPoint, httpHeader: ["Authorization": "Bearer \(userSession.token)"])

        return sendRequest(request: request)
    }

    func vendorNameAutoComplete(searchTerm: String = "") -> Promise<AutoCompleteList> {
        guard let userSession = userSessionDataStore.readUserSession() else {
            return .init(error: APIError.noAccessTokenError)
        }
        let endPoint = Endpoint.vendorNameAutoComplete(searchTerm: searchTerm, partnerID: String(userSession.partnerInfo.id))
        let request = request(endPoint: endPoint, httpHeader: ["Authorization": "Bearer \(userSession.token)"])

        return sendRequest(request: request)
    }

    func applicantAutoComplete(searchTerm: String = "") -> Promise<AutoCompleteList> {
        guard let userSession = userSessionDataStore.readUserSession() else {
            return .init(error: APIError.noAccessTokenError)
        }
        let endPoint = Endpoint.applicantAutoComplete(searchTerm: searchTerm)
        let request = request(endPoint: endPoint, httpHeader: ["Authorization": "Bearer \(userSession.token)"])

        return sendRequest(request: request)
    }

    func productNumberAutoComplete(searchTerm: String = "") -> Promise<AutoCompleteList> {
        guard let userSession = userSessionDataStore.readUserSession() else {
            return .init(error: APIError.noAccessTokenError)
        }
        let endPoint = Endpoint.productNumberAutoComplete(searchTerm: searchTerm)
        let request = request(endPoint: endPoint, httpHeader: ["Authorization": "Bearer \(userSession.token)"])

        return sendRequest(request: request)
    }

    func productNumberSetAutoComplete(searchTerm: String = "") -> Promise<AutoCompleteList> {
        guard let userSession = userSessionDataStore.readUserSession() else {
            return .init(error: APIError.noAccessTokenError)
        }
        let endPoint = Endpoint.productNumberSetAutoComplete(searchTerm: searchTerm)
        let request = request(endPoint: endPoint, httpHeader: ["Authorization": "Bearer \(userSession.token)"])

        return sendRequest(request: request)
    }

    func productMaterialBrandNameAutoComplete(searchTerm: String = "", vendorID: String? = nil) -> Promise<AutoCompleteList> {
        guard let userSession = userSessionDataStore.readUserSession() else {
            return .init(error: APIError.noAccessTokenError)
        }
        let endPoint = Endpoint.productMaterialBrandNameAutoComplete(searchTerm: searchTerm, vendorID: vendorID)
        let request = request(endPoint: endPoint, httpHeader: ["Authorization": "Bearer \(userSession.token)"])

        return sendRequest(request: request)
    }

    func productMaterailOriginalNumberAutoComplete(searchTerm: String = "") -> Promise<AutoCompleteList> {
        guard let userSession = userSessionDataStore.readUserSession() else {
            return .init(error: APIError.noAccessTokenError)
        }
        let endPoint = Endpoint.productMaterialOriginalNumberAutoComplete(searchTerm: searchTerm)
        let request = request(endPoint: endPoint, httpHeader: ["Authorization": "Bearer \(userSession.token)"])

        return sendRequest(request: request)
    }
    
    func announcementTitleAutoComplete(searchTerm: String) -> Promise<AutoCompleteList> {
        guard let userSession = userSessionDataStore.readUserSession() else {
            return .init(error: APIError.noAccessTokenError)
        }
        let endPoint = Endpoint.purchaseNumberAutoComplete(searchTerm: searchTerm, partnerID: String(userSession.partnerInfo.id))
        let request = request(endPoint: endPoint, httpHeader: ["Authorization": "Bearer \(userSession.token)"])

        return sendRequest(request: request)
    }
    
    func announcementTypeAutoComplete(searchTerm: String) -> Promise<AutoCompleteList> {
        guard let userSession = userSessionDataStore.readUserSession() else {
            return .init(error: APIError.noAccessTokenError)
        }
        let endPoint = Endpoint.purchaseNumberAutoComplete(searchTerm: searchTerm, partnerID: String(userSession.partnerInfo.id))
        let request = request(endPoint: endPoint, httpHeader: ["Authorization": "Bearer \(userSession.token)"])

        return sendRequest(request: request)
    }
    
}
extension MyMindAutoCompleteAPIService: AutoCompleteAPIService { }
