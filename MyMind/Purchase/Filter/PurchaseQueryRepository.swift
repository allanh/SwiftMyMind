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
        switch queryType {
        case .purchaseNumber:
            let index = currentQueryInfo.purchaseNumbers.firstIndex(where: { $0 === info })
            if let index = index {
                currentQueryInfo.purchaseNumbers.remove(at: index)
            } else {
                currentQueryInfo.purchaseNumbers.append(info)
            }
            info.isSelect = index == nil
        case .vendorID:
            let index = currentQueryInfo.vendorIDs.firstIndex(where: { $0 === info })
            if let index = index {
                currentQueryInfo.vendorIDs.remove(at: index)
            } else {
                currentQueryInfo.vendorIDs.append(info)
            }
            info.isSelect = index == nil
        case .applicant:
            let index = currentQueryInfo.employeeIDs.firstIndex(where: { $0 === info })
            if let index = index {
                currentQueryInfo.employeeIDs.remove(at: index)
            } else {
                currentQueryInfo.employeeIDs.append(info)
            }
            info.isSelect = index == nil

        case .productNumbers:
            let index = currentQueryInfo.productNumbers.firstIndex(where: { $0 === info })
            if let index = index {
                currentQueryInfo.productNumbers.remove(at: index)
            } else {
                currentQueryInfo.productNumbers.append(info)
            }
            info.isSelect = index == nil
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
