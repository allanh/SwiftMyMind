//
//  SuggestionProductMaterialViewModelService.swift
//  MyMind
//
//  Created by Barry Chen on 2021/6/8.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import PromiseKit

protocol SuggestionProductMaterialViewModelService {
    func fetchSuggestionProductMaterialViewModels(with productIDs: [String]) -> Promise<[SuggestionProductMaterialViewModel]>
}

struct PurchaseServiceToSuggestionProductMaterialViewModelAdapter: SuggestionProductMaterialViewModelService {
    let service: PurchaseAPIService
    let imageDictionary: [String: URL?]

    func fetchSuggestionProductMaterialViewModels(with productIDs: [String]) -> Promise<[SuggestionProductMaterialViewModel]> {
        return Promise<[SuggestionProductMaterialViewModel]> { seal in
            service.fetchPurchaseSuggestionInfos(with: productIDs)
                .done { list in
                    let suggestionInfos = list.items
                    let viewModels = suggestionInfos.map { info -> SuggestionProductMaterialViewModel in
                        let imageURL = imageDictionary[info.number, default: nil]
                        return SuggestionProductMaterialViewModel.init(
                            imageURL: imageURL,
                            number: info.number,
                            originalProductNumber: info.originalProductNumber,
                            name: info.name,
                            purchaseSuggestionQuantity: info.suggestedQuantity,
                            stockUnitName: info.stockUnitName,
                            boxStockUnitName: info.stockUnitName,
                            quantityPerBox: Int(info.quantityPerBox) ?? 0,
                            purchaseSuggestionInfo: info,
                            purchaseCostPerItem: Double(info.cost) ?? 0,
                            vendorName: list.vendorName,
                            vendorID: list.vendorID
                        )
                    }
                    seal.fulfill(viewModels)
                }
                .catch { error in
                    seal.reject(error)
                }
        }
    }
}
