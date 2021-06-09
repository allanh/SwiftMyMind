//
//  PurchaseInfoViewModel.swift
//  MyMind
//
//  Created by Barry Chen on 2021/6/8.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

protocol RxPurchaseWarehouseListService {
    func fetchPurchaseWarehouseList() -> Single<[Warehouse]>
}

struct PurchaseInfoViewModel {
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

    let expectedStorageDateValidationStatus: BehaviorRelay<ValidationResult> = .init(value: .invalid(""))
    let pickedWarehouseValidationStatus: BehaviorRelay<ValidationResult> = .init(value: .invalid(""))

    let service: RxPurchaseWarehouseListService
    let bag: DisposeBag = DisposeBag()

    init(suggestionProductMaterialViewModels: [SuggestionProductMaterialViewModel], service: RxPurchaseWarehouseListService) {
        self.suggestionProductMaterialViewModels = suggestionProductMaterialViewModels
        self.service = service
    }

    func fetchWarehouseList() {
        service.fetchPurchaseWarehouseList()
            .subscribe({ result in
                switch result {
                case .success(let list):
                    warehouseList.accept(list)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
            .disposed(by: bag)
    }
protocol PurchaseReviewerListService {
    func fetchPurchaseReviewer() -> Promise<[Reviewer]>
}

struct PickReviewerViewModel {
    // MARK: - Properties
    let reviewerList: BehaviorRelay<[Reviewer]> = .init(value: [])
    let pickedReviewer: BehaviorRelay<Reviewer?> = .init(value: nil)
    let pickedReviewerValidationStatus: BehaviorRelay<ValidationResult> = .init(value: .invalid("此欄位必填"))
    let note: BehaviorRelay<String> = .init(value: "")

    let service: PurchaseReviewerListService

    let bag: DisposeBag = DisposeBag()
    // MARK: - Methods
    init(service: PurchaseReviewerListService) {
        self.service = service
        bindStatus()
    }

    func bindStatus() {
        pickedReviewer
            .skip(1)
            .map { reviewer -> ValidationResult in
                reviewer != nil ? .valid : .invalid("此欄位必填")
            }
            .bind(to: pickedReviewerValidationStatus)
            .disposed(by: bag)
    }

    func fetchPurchaseReviewerList() {
        service.fetchPurchaseReviewer()
            .done { list in
                reviewerList.accept(list)
            }
            .catch { error in
                print(error.localizedDescription)
            }
    }
}
