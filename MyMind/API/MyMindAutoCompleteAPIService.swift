//
//  MyMindAutoCompleteAPIService.swift
//  MyMind
//
//  Created by Barry Chen on 2021/5/5.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import PromiseKit

protocol PurchaseAutoCompleteAPIService {
    func purchaseNumberAutoComplete(searchTerm: String) -> Promise<AutoCompleteList>
    func vendorNameAutoComplete(searchTerm: String) -> Promise<AutoCompleteList>
    func applicantAutoComplete(searchTerm: String) -> Promise<AutoCompleteList>
    func productNumberAutoComplete(searchTerm: String) -> Promise<AutoCompleteList>
    func productMaterialBrandNameAutoComplete(searchTerm: String) -> Promise<AutoCompleteList>
    func productMaterailOriginalNumberAutoComplete(searchTerm: String) -> Promise<AutoCompleteList>
    func productNumberSetAutoComplete(searchTerm: String) -> Promise<AutoCompleteList>
}

class MyMindAutoCompleteAPIService: PromiseKitAPIService {

    let userSession: UserSession
    var partnerID: String {
        String(userSession.partnerInfo.id)
    }

    init(userSession: UserSession) {
        self.userSession = userSession
    }

    func purchaseNumberAutoComplete(searchTerm: String = "") -> Promise<AutoCompleteList> {
        let endPoint = Endpoint.purchaseNumberAutoComplete(searchTerm: searchTerm, partnerID: partnerID)
        let request = request(endPoint: endPoint, httpHeader: ["Authorization": "Bearer \(userSession.token)"])

        return sendRequest(request: request)
    }

    func vendorNameAutoComplete(searchTerm: String = "") -> Promise<AutoCompleteList> {
        let endPoint = Endpoint.vendorNameAutoComplete(searchTerm: searchTerm, partnerID: partnerID)
        let request = request(endPoint: endPoint, httpHeader: ["Authorization": "Bearer \(userSession.token)"])

        return sendRequest(request: request)
    }

    func applicantAutoComplete(searchTerm: String = "") -> Promise<AutoCompleteList> {
        let endPoint = Endpoint.applicantAutoComplete(searchTerm: searchTerm)
        let request = request(endPoint: endPoint, httpHeader: ["Authorization": "Bearer \(userSession.token)"])

        return sendRequest(request: request)
    }

    func productNumberAutoComplete(searchTerm: String = "") -> Promise<AutoCompleteList> {
        let endPoint = Endpoint.productNumberAutoComplete(searchTerm: searchTerm)
        let request = request(endPoint: endPoint, httpHeader: ["Authorization": "Bearer \(userSession.token)"])

        return sendRequest(request: request)
    }

    func productNumberSetAutoComplete(searchTerm: String = "") -> Promise<AutoCompleteList> {
        let endPoint = Endpoint.productNumberSetAutoComplete(searchTerm: searchTerm)
        let request = request(endPoint: endPoint, httpHeader: ["Authorization": "Bearer \(userSession.token)"])

        return sendRequest(request: request)
    }

    func productMaterialBrandNameAutoComplete(searchTerm: String = "") -> Promise<AutoCompleteList> {
        let endPoint = Endpoint.productMaterialBrandNameAutoComplete(searchTerm: searchTerm)
        let request = request(endPoint: endPoint, httpHeader: ["Authorization": "Bearer \(userSession.token)"])

        return sendRequest(request: request)
    }

    func productMaterailOriginalNumberAutoComplete(searchTerm: String = "") -> Promise<AutoCompleteList> {
        let endPoint = Endpoint.productMaterialOriginalNumberAutoComplete(searchTerm: searchTerm)
        let request = request(endPoint: endPoint, httpHeader: ["Authorization": "Bearer \(userSession.token)"])

        return sendRequest(request: request)
    }
}
extension MyMindAutoCompleteAPIService: PurchaseAutoCompleteAPIService { }
