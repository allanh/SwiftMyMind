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
    let totalStockQuantity: String
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
            totalStockQuantity: totalStockQuantity,
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
            originalProductNumber: originalProductNumber ?? "",
            name: name,
            channelStockQuantity: String(channelStockQuantity ?? 0),
            fineStockQuantity: String(fineStockQuantity ?? 0),
            totalStockQuantity: String(totalStockQuantity ?? 0),
            monthSaleQuantity: String(monthSaleQuantity ?? 0),
            daysSalesOfInventory: String(daysSalesOfInventory ?? 0),
            suggestedQuantity: String(suggestedQuantity),
            quantityPerBox: String(quantityPerBox),
            stockUnitName: stockUnitName,
            boxStockUnitName: boxStockUnitName,
            cost: String(cost ?? 0),
            movingAverageCost: String(movingAverageCost ?? 0)
        )
    }
}
