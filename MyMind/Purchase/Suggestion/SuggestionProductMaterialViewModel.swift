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
    let boxStockUnitName: String
    let quantityPerBox: Int
    let purchaseSuggestionInfo: PurchaseSuggestionInfo
    let vendorName: String
    let vendorID: String

    let purchaseCostPerItemInput: PublishRelay<String> = .init()
    let purchaseCostPerItem: BehaviorRelay<Double>
    let validationStatusForpurchaseCostPerItem: BehaviorRelay<ValidationResult> = .init(value: .valid)

    let purchaseQuantityInput: PublishRelay<String> = .init()
    let purchaseQuantity: BehaviorRelay<Int> = .init(value: 0)
    let validationStatusForPurchaseQuantity: BehaviorRelay<ValidationResult> = .init(value: .valid)

    let purchaseCostInput: PublishRelay<String> = .init()
    let purchaseCost: BehaviorRelay<Double> = .init(value: 0)
    let validationStatusForPurchaseCost: BehaviorRelay<ValidationResult> = .init(value: .valid)

    let totalBox: BehaviorRelay<Double> = .init(value: 0)
    let centralizedValidationStatus: BehaviorRelay<ValidationResult> = .init(value: .invalid(""))

    let bag: DisposeBag = DisposeBag()

    init(imageURL: URL?,
         number: String,
         originalProductNumber: String,
         name: String,
         purchaseSuggestionQuantity: String,
         stockUnitName: String,
         boxStockUnitName: String,
         quantityPerBox: Int,
         purchaseSuggestionInfo: PurchaseSuggestionInfo,
         purchaseCostPerItem: Double,
         vendorName: String,
         vendorID: String) {
        self.imageURL = imageURL
        self.number = number
        self.originalProductNumber = originalProductNumber
        self.name = name
        self.purchaseSuggestionQuantity = purchaseSuggestionQuantity
        self.stockUnitName = stockUnitName
        self.boxStockUnitName = boxStockUnitName
        self.quantityPerBox = quantityPerBox
        self.purchaseSuggestionInfo = purchaseSuggestionInfo
        self.purchaseCostPerItem = .init(value: purchaseCostPerItem)
        self.vendorID = vendorID
        self.vendorName = vendorName
        bindInput()
    }

    func bindInput() {
        purchaseCostPerItemInput
            .map({ Double($0) ?? 0 })
            .bind(to: purchaseCostPerItem)
            .disposed(by: bag)

        purchaseCostPerItem
            .map { cost in
                cost > 0 ? .valid : .invalid("此欄位必填")
            }
            .bind(to: validationStatusForpurchaseCostPerItem)
            .disposed(by: bag)

        purchaseCostPerItem
            .map({ _ in ValidationResult.valid })
            .bind(to: validationStatusForPurchaseCost)
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

        purchaseQuantity
            .map { quantity -> Double in
                let result = Double(quantity / quantityPerBox)
                let roundedResult = (result*100).rounded() / 100
                return roundedResult
            }
            .bind(to: totalBox)
            .disposed(by: bag)

        purchaseQuantity
            .map({ _ in ValidationResult.valid })
            .bind(to: validationStatusForPurchaseCost)
            .disposed(by: bag)

        Observable.combineLatest(purchaseCostPerItem, purchaseQuantity)
            .map { (cost, quantity) in
                cost * Double(quantity)
            }
            .bind(to: purchaseCost)
            .disposed(by: bag)

        purchaseCostInput
            .map({ Double($0) ?? 0 })
            .bind(to: purchaseCost)
            .disposed(by: bag)

        purchaseCostInput
            .map({ Double($0) ?? 0 })
            .map(validatePurchaseCostInput(input:))
            .bind(to: validationStatusForPurchaseCost)
            .disposed(by: bag)

        Observable.combineLatest(validationStatusForpurchaseCostPerItem, validationStatusForPurchaseQuantity, validationStatusForPurchaseCost)
            .map {
                [$0.0 == .valid, $0.1 == .valid, $0.2 == .valid]
            }
            .map { $0.contains(false) ? ValidationResult.invalid("") : ValidationResult.valid }
            .bind(to: centralizedValidationStatus)
            .disposed(by: bag)
    }

    func validatePurchaseCostInput(input: Double) -> ValidationResult {
        let standardPurchaseCost = purchaseCostPerItem.value * Double(purchaseQuantity.value)
        let adjustedValue = abs(input - standardPurchaseCost)
        switch standardPurchaseCost {
        case 0: return .valid
        case 1...30:
             return adjustedValue > 1 ? .invalid("進貨成本小計(未稅) 1-30 元修正不得大於 1 元") : .valid
        case 31...100:
            return adjustedValue > 2 ? .invalid("進貨成本小計(未稅) 31-100 元修正不得大於 2 元") : .valid
        case 101...300:
            return adjustedValue > 3 ? .invalid("進貨成本小計(未稅) 101-300 元修正不得大於 3 元") : .valid
        case 301...1000:
            return adjustedValue > 10 ? .invalid("進貨成本小計(未稅) 301-1000 元修正不得大於 10 元") : .valid
        case 1001...10000:
            return adjustedValue > 20 ? .invalid("進貨成本小計(未稅) 301-1000 元修正不得大於 20 元") : .valid
        default:
            return adjustedValue > 30 ? .invalid("進貨成本小計(未稅) 10,001 元以上修正不得大於 30 元") : .valid
        }
    }
}
