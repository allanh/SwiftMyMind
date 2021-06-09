//
//  PurchaseInfoViewModel.swift
//  MyMind
//
//  Created by Barry Chen on 2021/6/8.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import PromiseKit
import RxRelay
import RxSwift

protocol PurchaseWarehouseListService {
    func fetchPurchaseWarehouseList() -> Promise<[Warehouse]>
}

struct PurchaseInfoViewModel {
    // MARK: - Properties
    let title: String = "採購單資訊"
    let suggestionProductMaterialViewModels: [SuggestionProductMaterialViewModel]

    var vandorName: String {
        suggestionProductMaterialViewModels.first?.vendorName ?? ""
    }

    var vandorID: String {
        suggestionProductMaterialViewModels.first?.vendorID ?? ""
    }

    let expectedStorageDate: BehaviorRelay<Date?> = .init(value: nil)
    let warehouseList: BehaviorRelay<[Warehouse]> = .init(value: [])
    let pickedWarehouse: BehaviorRelay<Warehouse?> = .init(value: nil)

    let recipientName: PublishRelay<String> = .init()
    let recipientPhone: PublishRelay<String> = .init()
    let recipientAddress: PublishRelay<String> = .init()

    let expectedStorageDateValidationStatus: BehaviorRelay<ValidationResult> = .init(value: .invalid("此欄位必填"))
    let pickedWarehouseValidationStatus: BehaviorRelay<ValidationResult> = .init(value: .invalid("此欄位必填"))

    let showSuggestionInfo: PublishRelay<Void> = .init()

    let service: PurchaseWarehouseListService
    let bag: DisposeBag = DisposeBag()
    // MARK: - Methods
    init(suggestionProductMaterialViewModels: [SuggestionProductMaterialViewModel],
         service: PurchaseWarehouseListService) {
        self.suggestionProductMaterialViewModels = suggestionProductMaterialViewModels
        self.service = service
        bindStatus()
        bindRecipientInfo()
    }

    func bindStatus() {
        expectedStorageDate
            .skip(1)
            .map { date -> ValidationResult in
                guard let date = date else { return .invalid("此欄位必填") }
                if date < Date() {
                    return .invalid("入庫日最快只能選擇今天的日期")
                } else {
                    return .valid
                }
            }
            .bind(to: expectedStorageDateValidationStatus)
            .disposed(by: bag)

        pickedWarehouse
            .skip(1)
            .map { warehouse -> ValidationResult in
                warehouse != nil ? .valid : .invalid("此欄位必填")
            }
            .bind(to: pickedWarehouseValidationStatus)
            .disposed(by: bag)
    }

    func bindRecipientInfo() {
        pickedWarehouse
            .compactMap({ $0 })
            .subscribe(onNext: { warehouse in
                recipientName.accept(warehouse.recipientInfo.name)
                recipientPhone.accept(warehouse.recipientInfo.phone)
                recipientAddress.accept(warehouse.recipientInfo.address.fullAddressString)
            })
            .disposed(by: bag)
    }

    func fetchWarehouseList() {
        service.fetchPurchaseWarehouseList()
            .done { warehouses in
                warehouseList.accept(warehouses)
            }
            .catch { error in
                print(error.localizedDescription)
            }
    }
}
