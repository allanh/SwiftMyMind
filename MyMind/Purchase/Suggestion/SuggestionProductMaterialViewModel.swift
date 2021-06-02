//
//  SuggestionProductMaterialViewModel.swift
//  MyMind
//
//  Created by Chen Yi-Wei on 2021/6/1.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

struct SuggestionProductMaterialViewModel {
    let imageURL: URL?
    let number: String
    let originalProductNumber: String
    let name: String
    let purchaseSuggestionQuantity: String
    let stockUnitName: String
    let quantityPerBox: Int
    let purchaseSuggestionInfo: PurchaseSuggestionInfo

    let purchaseCostPerItemInput: PublishRelay<String> = .init()
    let purchaseCostPerItem: BehaviorRelay<Float>
    let validationStatusForpurchaseCostPerItem: BehaviorRelay<ValidationResult> = .init(value: .invalid(""))

    let purchaseQuantityInput: PublishRelay<String> = .init()
    let purchaseQuantity: BehaviorRelay<Int> = .init(value: 0)
    let validationStatusForPurchaseQuantity: BehaviorRelay<ValidationResult> = .init(value: .invalid(""))

    let purchaseCostInput: PublishRelay<String> = .init()
    let purchaseCost: BehaviorRelay<Float> = .init(value: 0)
    let validationStatusForPurchaseCost: BehaviorRelay<ValidationResult> = .init(value: .invalid(""))

    let bag: DisposeBag = DisposeBag()

    init(imageURL: URL?, number: String, originalProductNumber: String, name: String, purchaseSuggestionQuantity: String, stockUnitName: String, quantityPerBox: Int, purchaseSuggestionInfo: PurchaseSuggestionInfo, purchaseCostPerItem: BehaviorRelay<Float>) {
        self.imageURL = imageURL
        self.number = number
        self.originalProductNumber = originalProductNumber
        self.name = name
        self.purchaseSuggestionQuantity = purchaseSuggestionQuantity
        self.stockUnitName = stockUnitName
        self.quantityPerBox = quantityPerBox
        self.purchaseSuggestionInfo = purchaseSuggestionInfo
        self.purchaseCostPerItem = purchaseCostPerItem

        bindInput()
    }

    func bindInput() {
        purchaseCostPerItemInput
            .map({ Float($0) ?? 0 })
            .bind(to: purchaseCostPerItem)
            .disposed(by: bag)

        purchaseCostPerItem
            .map { cost in
                cost > 0 ? .valid : .invalid("此欄位必填")
            }
            .bind(to: validationStatusForpurchaseCostPerItem)
            .disposed(by: bag)


        purchaseQuantityInput
            .map({ Int($0) ?? 0})
            .bind(to: purchaseQuantity)
            .disposed(by: bag)

        purchaseQuantity
            .map { quantity in
                quantity > 0 ? .valid : .invalid("請輸入大於0的數量")
            }
            .skip(1)
            .bind(to: validationStatusForPurchaseQuantity)
            .disposed(by: bag)

        Observable.combineLatest(purchaseCostPerItem, purchaseQuantity)
            .map { (cost, quantity) in
                cost * Float(quantity)
            }
            .bind(to: purchaseCost)
            .disposed(by: bag)
    }
}

struct PurchaseSuggestionInfo: Codable {
    let id, number, originalProductNumber, name: String
    let quantityPerBox, channelStockQuantity, fineStockQuantity, totalStockQuantity: String
    let monthSaleQuantity, suggestedQuantity, daysSalesOfInventory, cost: String
    let movingAverageCost, stockUnitName, boxStockUnitName: String

    enum CodingKeys: String, CodingKey {
        case id = "product_id"
        case number = "product_no"
        case originalProductNumber = "original_product_no"
        case name = "product_name"
        case quantityPerBox = "box_quantity"
        case channelStockQuantity = "channel_stock_quantity"
        case fineStockQuantity = "fine_stock_quantity"
        case totalStockQuantity = "total_stock_quantity"
        case monthSaleQuantity = "month_sale_quantity"
        case suggestedQuantity = "proposed_quantity"
        case daysSalesOfInventory = "days_sales_of_inventory"
        case cost
        case movingAverageCost = "moving_average_cost"
        case stockUnitName = "stock_unit_name"
        case boxStockUnitName = "box_stock_unit_name"
    }
}

struct PurchaseSuggestionInfoList: Codable {
    let items: [PurchaseSuggestionInfo]

    enum CodingKeys: String, CodingKey {
        case items = "detail"
    }
}
