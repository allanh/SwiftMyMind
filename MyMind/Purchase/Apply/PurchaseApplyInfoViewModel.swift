//
//  PurchaseApplyInfoViewModel.swift
//  MyMind
//
//  Created by Barry Chen on 2021/6/8.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import PromiseKit
import RxRelay
import RxSwift

protocol PurchaseWarehouseListLoader {
    func loadPurchaseWarehouseList() -> Promise<[Warehouse]>
}

struct PurchaseApplyInfoViewModel {
    // MARK: - Properties
    let suggestionProductMaterialViewModels: BehaviorRelay<[SuggestionProductMaterialViewModel]> = .init(value: [])

    var venderName: String {
        suggestionProductMaterialViewModels.value.first?.vendorName ?? ""
    }

    var vendorID: String {
        suggestionProductMaterialViewModels.value.first?.vendorID ?? ""
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

    let suggestionProductMaterialViewModelsLoader: SuggestionProductMaterialViewModelsLoader
    let warehouseLoader: PurchaseWarehouseListLoader
    let bag: DisposeBag = DisposeBag()
    // MARK: - Methods
    init(suggestionProductMaterialViewModelsLoader: SuggestionProductMaterialViewModelsLoader,
         warehouseLoader: PurchaseWarehouseListLoader) {
        self.suggestionProductMaterialViewModelsLoader = suggestionProductMaterialViewModelsLoader
        self.warehouseLoader = warehouseLoader
        bindStatus()
        bindRecipientInfo()
    }

    func bindStatus() {
        expectedStorageDate
            .skip(1)
            .map { date -> ValidationResult in
                guard let date = date else { return .invalid("此欄位必填") }
                var yesterday = Calendar.current.dateComponents([.year, .month, .day], from: Date()).date ?? Date()
                yesterday.addTimeInterval(-(24*60*60))
                if date < yesterday {
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
            .compactMap({ $0?.recipientInfo })
            .subscribe(onNext: { recipientInfo in
                recipientName.accept(recipientInfo.name)
                recipientPhone.accept(recipientInfo.phone)
                recipientAddress.accept(recipientInfo.address.fullAddressString)
            })
            .disposed(by: bag)
    }

    func loadSuggestionProductMaterialViewModels() {
        suggestionProductMaterialViewModelsLoader.loadSuggestionProductMaterialViewModels()
            .done { viewModels in
                suggestionProductMaterialViewModels.accept(viewModels)
            }
            .catch { error in
                print(error.localizedDescription)
                #warning("Error handling")
            }
    }

    func loadWarehouseList() {
        warehouseLoader.loadPurchaseWarehouseList()
            .done { warehouses in
                warehouseList.accept(warehouses)
            }
            .catch { error in
                print(error.localizedDescription)
                #warning("Error handling")
            }
    }
}
