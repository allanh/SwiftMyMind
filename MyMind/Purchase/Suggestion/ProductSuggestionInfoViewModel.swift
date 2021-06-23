//
//  ProductSuggestionInfoViewModel.swift
//  MyMind
//
//  Created by Barry Chen on 2021/6/23.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation

struct ProductSuggestionInfoViewModel {
    let number: String
    let originalProductNumber: String
    let name: String
    let channelStockQuantity: String
    let fineStockQuantity: String
    let monthSaleQuantity: String
    let daysSalesOfInventory: String
    let suggestedQuantity: String
    let quantityPerBox: String
    let stockUnitName: String
    let boxStockUnitName: String
    let cost: String
    let movingAverageCost: String
}

extension PurchaseSuggestionInfo {
    var productSuggestionInfoViewModel: ProductSuggestionInfoViewModel {
        return ProductSuggestionInfoViewModel(
            number: number,
            originalProductNumber: originalProductNumber,
            name: name,
            channelStockQuantity: channelStockQuantity,
            fineStockQuantity: fineStockQuantity,
            monthSaleQuantity: monthSaleQuantity,
            daysSalesOfInventory: daysSalesOfInventory,
            suggestedQuantity: suggestedQuantity,
            quantityPerBox: quantityPerBox,
            stockUnitName: stockUnitName,
            boxStockUnitName: boxStockUnitName,
            cost: cost,
            movingAverageCost: movingAverageCost
        )
    }
}

extension PurchaseOrder.ProductInfo {
    var productSuggestionInfoViewModel: ProductSuggestionInfoViewModel {
        return ProductSuggestionInfoViewModel(
            number: number,
            originalProductNumber: originalProductNumber,
            name: name,
            channelStockQuantity: channelStockQuantity,
            fineStockQuantity: fineStockQuantity,
            monthSaleQuantity: monthSaleQuantity,
            daysSalesOfInventory: daysSalesOfInventory,
            suggestedQuantity: suggestedQuantity,
            quantityPerBox: quantityPerBox,
            stockUnitName: stockUnitName,
            boxStockUnitName: boxStockUnitName,
            cost: cost,
            movingAverageCost: movingAverageCost
        )
    }
}
