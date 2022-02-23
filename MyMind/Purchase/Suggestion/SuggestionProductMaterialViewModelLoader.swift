//
//  SuggestionProductMaterialViewModelLoader.swift
//  MyMind
//
//  Created by Barry Chen on 2021/6/8.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import PromiseKit

protocol SuggestionProductMaterialViewModelLoader {
    func loadSuggestionProductMaterialViewModels(with productIDs: [String]) -> Promise<[SuggestionProductMaterialViewModel]>
}

struct PurchaseSuggestionInfosLoaderToSuggestionProductMaterialViewModelAdapter: SuggestionProductMaterialViewModelLoader {
    let loader: PurchaseSuggestionInfosLoader

    func loadSuggestionProductMaterialViewModels(with productIDs: [String]) -> Promise<[SuggestionProductMaterialViewModel]> {
        return Promise<[SuggestionProductMaterialViewModel]> { seal in
            loader.loadPurchaseSuggestionInfos(with: productIDs)
                .done { list in
                    let suggestionInfos = list.items
                    let viewModels = suggestionInfos.map { info -> SuggestionProductMaterialViewModel in
                        let imageURLString = info.imageInfos.first?.url ?? ""
                        return SuggestionProductMaterialViewModel.init(
                            imageURL: URL(string: imageURLString),
                            number: info.number,
                            originalProductNumber: info.originalProductNumber,
                            name: info.name,
                            purchaseSuggestionQuantity: info.suggestedQuantity,
                            stockUnitName: info.stockUnitName,
                            boxStockUnitName: info.stockUnitName,
                            quantityPerBox: Int(info.quantityPerBox) ?? 0,
                            purchaseSuggestionInfo: info,
                            purchaseCostPerItem: Double(info.untaxCoast) ?? 0,
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
