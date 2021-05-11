//
//  PurchaseQueryRepository.swift
//  MyMind
//
//  Created by Barry Chen on 2021/5/10.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation

class PurchaseQueryRepository {
    var autoCompleteSource: [PurchaseQueryType: [AutoCompleteInfo]] = [:]

    let remoteAPIService: PurchaseAutoCompleteAPIService

    private(set) var currentQueryInfo: PurchaseListQueryInfo

    init(
        currentQueryInfo: PurchaseListQueryInfo,
        remoteAPIService: PurchaseAutoCompleteAPIService
    ) {
        self.currentQueryInfo = currentQueryInfo
        self.remoteAPIService = remoteAPIService
    }

    func updateAutoCompleteSourceFromRemote() {
        remoteAPIService.purchaseNumberAutoComplete(searchTerm: "")
            .done { [weak self] list in
                self?.autoCompleteSource[.purchaseNumber] = list.item
            }
            .cauterize()

        remoteAPIService.vendorNameAutoComplete(searchTerm: "")
            .done { [weak self] list in
                self?.autoCompleteSource[.vendorID] = list.item
            }
            .cauterize()

        remoteAPIService.applicantAutoComplete(searchTerm: "")
            .done { [weak self] list in
                self?.autoCompleteSource[.applicant] = list.item
            }
            .cauterize()

        remoteAPIService.productNumberAutoComplete(searchTerm: "")
            .done { [weak self] list in
                self?.autoCompleteSource[.productNumbers] = list.item
            }
            .cauterize()
    }

    func updateAutoCompleteQueryInfo(for queryType: PurchaseQueryType, with info: AutoCompleteInfo) {
        info.isSelect = true
        switch queryType {
        case .purchaseNumber:
            if currentQueryInfo.purchaseNumbers.contains(info) == false {
                currentQueryInfo.purchaseNumbers.append(info)
            }
        case .vendorID:
            if currentQueryInfo.vendorIDs.contains(info) == false {
                currentQueryInfo.vendorIDs.append(info)
            }
        case .applicant:
            if currentQueryInfo.employeeIDs.contains(info) == false {
                currentQueryInfo.employeeIDs.append(info)
            }
        case .productNumbers:
            if currentQueryInfo.productNumbers.contains(info) == false {
                currentQueryInfo.productNumbers.append(info)
            }
        default:
            return
        }
    }

    func removeAutoCompleteQueryInfo(for queryType: PurchaseQueryType, at index: Int) {
        switch queryType {
        case .purchaseNumber:
            let info = currentQueryInfo.purchaseNumbers.remove(at: index)
            info.isSelect = false
        case .vendorID:
            let info = currentQueryInfo.vendorIDs.remove(at: index)
            info.isSelect = false
        case .applicant:
            let info = currentQueryInfo.employeeIDs.remove(at: index)
            info.isSelect = false
        case .productNumbers:
            let info = currentQueryInfo.productNumbers.remove(at: index)
            info.isSelect = false
        default:
            return
        }
    }
}
