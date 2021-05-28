//
//  PurchaseFilterViewModel.swift
//  MyMind
//
//  Created by Barry Chen on 2021/5/28.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import RxSwift

class PurchaseFilterViewModel {
    let title: String = "篩選條件"
    var queryInfo: PurchaseListQueryInfo
    let didUpdateQueryInfo: (PurchaseListQueryInfo) -> Void
    let service: AutoCompleteAPIService

    lazy var purchaseNumberViewModel: AutoCompleteSearchViewModel = {
        makeViewModelForPurchaseNumber()
    }()

    lazy var vendorViewModel: AutoCompleteSearchViewModel = {
        makeViewModelForVendor()
    }()

    lazy var applicantViewModel: AutoCompleteSearchViewModel = {
        makeViewModelForApplicant()
    }()

    lazy var productNumberViewModel: AutoCompleteSearchViewModel = {
        makeViewModelForProductNumber()
    }()

    let purchaseStatusViewModel: PickPurchaseStatusViewModel = PickPurchaseStatusViewModel()

    let expectPutInStoragePeriodViewModel: PickDatesViewModel = PickDatesViewModel(title: "預計入庫日")

    let creatPeriodViewModel: PickDatesViewModel = PickDatesViewModel(title: "填單日期")

    let bag: DisposeBag = DisposeBag()

    init(service: AutoCompleteAPIService,
         queryInfo: PurchaseListQueryInfo,
         didUpdateQueryInfo: @escaping (PurchaseListQueryInfo) -> Void) {
        self.service = service
        self.queryInfo = queryInfo
        self.queryInfo.pageNumber = 1
        self.didUpdateQueryInfo = didUpdateQueryInfo

        updateWithCurrentQuery()
        subscribeChildViewModels()
    }

    private func subscribeChildViewModels() {
        purchaseNumberViewModel.pickedItemViewModels
            .subscribe(onNext: { [unowned self] items in
                self.queryInfo.purchaseNumbers = items.map({ item in
                    AutoCompleteInfo(id: nil, number: item.identifier, name: nil)
                })
            })
            .disposed(by: bag)

        vendorViewModel.pickedItemViewModels
            .subscribe(onNext: { [unowned self] items in
                self.queryInfo.vendorIDs = items.map({ item in
                    AutoCompleteInfo(id: item.identifier, number: nil, name: item.representTitle)
                })
            })
            .disposed(by: bag)

        applicantViewModel.pickedItemViewModels
            .subscribe(onNext: { [unowned self] items in
                self.queryInfo.applicants = items.map({ item in
                    AutoCompleteInfo(id: item.identifier, number: nil, name: item.representTitle)
                })
            })
            .disposed(by: bag)

        productNumberViewModel.pickedItemViewModels
            .subscribe(onNext: { [unowned self] items in
                self.queryInfo.productNumbers = items.map({ item in
                    AutoCompleteInfo(id: nil, number: item.identifier, name: item.identifier)
                })
            })
            .disposed(by: bag)

        purchaseStatusViewModel.pickedStatus
            .subscribe(onNext: { [unowned self] status in
                self.queryInfo.status = status
            })
            .disposed(by: bag)

        expectPutInStoragePeriodViewModel.startDate
            .subscribe(onNext: { [unowned self] date in
                self.queryInfo.expectStorageStartDate = date
            })
            .disposed(by: bag)

        expectPutInStoragePeriodViewModel.endDate
            .subscribe(onNext: { [unowned self] date in
                self.queryInfo.expectStorageEndDate = date
            })
            .disposed(by: bag)

        creatPeriodViewModel.startDate
            .subscribe(onNext: { [unowned self] date in
                self.queryInfo.createDateStart = date
            })
            .disposed(by: bag)

        creatPeriodViewModel.endDate
            .subscribe(onNext: { [unowned self] date in
                self.queryInfo.createDateEnd = date
            })
            .disposed(by: bag)
    }

    private func updateWithCurrentQuery() {
        purchaseStatusViewModel.pickedStatus.accept(queryInfo.status)
        updateCurrentQueryForPurchaseNumber()
        updateCurrentQueryForVendor()
        updateCurrentQueryForApplicant()
        updateCurrentQueryForProductNumber()
        updateCurrentQueryForStoragePeriod()
        updateCurrentQueryForCreatPeriod()
    }

    private func updateCurrentQueryForPurchaseNumber() {
        let items = queryInfo.purchaseNumbers.map { AutoCompleteItemViewModel(representTitle: $0.number ?? "", identifier: $0.number ?? "")}
        purchaseNumberViewModel.pickedItemViewModels.accept(items)
    }

    private func updateCurrentQueryForVendor() {
        let items = queryInfo.vendorIDs.map { AutoCompleteItemViewModel(representTitle: $0.name ?? "", identifier: $0.id ?? "")}
        vendorViewModel.pickedItemViewModels.accept(items)
    }

    private func updateCurrentQueryForApplicant() {
        let items = queryInfo.applicants.map { AutoCompleteItemViewModel(representTitle: $0.name ?? "", identifier: $0.id ?? "")}
        applicantViewModel.pickedItemViewModels.accept(items)
    }

    private func updateCurrentQueryForProductNumber() {
        let items = queryInfo.productNumbers.map { AutoCompleteItemViewModel(representTitle: $0.number ?? "", identifier: $0.number ?? "")}
        productNumberViewModel.pickedItemViewModels.accept(items)
    }

    private func updateCurrentQueryForStoragePeriod() {
        expectPutInStoragePeriodViewModel.startDate.accept(queryInfo.expectStorageStartDate)
        expectPutInStoragePeriodViewModel.endDate.accept(queryInfo.expectStorageEndDate)
    }

    private func updateCurrentQueryForCreatPeriod() {
        creatPeriodViewModel.startDate.accept(queryInfo.createDateStart)
        creatPeriodViewModel.endDate.accept(queryInfo.createDateEnd)
    }

    func cleanQueryInfo() {
        queryInfo = .defaultQuery()

        purchaseNumberViewModel.cleanPickedItemViewModel()
        vendorViewModel.cleanPickedItemViewModel()
        productNumberViewModel.cleanPickedItemViewModel()
        applicantViewModel.cleanPickedItemViewModel()
        purchaseStatusViewModel.cleanPickedStatus()
        expectPutInStoragePeriodViewModel.cleanPickedDates()
        creatPeriodViewModel.cleanPickedDates()
    }
}
// MARK: - Child view models factory mehods
extension PurchaseFilterViewModel {
    private func makeViewModelForPurchaseNumber() -> AutoCompleteSearchViewModel {
        let adapter = RxPurchaseNumberAutoCompleteItemViewModelAdapter(service: service)
        let viewModel = AutoCompleteSearchViewModel(title: "採購單編號", service: adapter)
        return viewModel
    }

    private func makeViewModelForVendor() -> AutoCompleteSearchViewModel {
        let adapter = RxVendorAutoCompleteItemViewModelAdapter(service: service)
        let viewModel = AutoCompleteSearchViewModel.init(title: "供應商", service: adapter)
        return viewModel
    }

    private func makeViewModelForApplicant() -> AutoCompleteSearchViewModel {
        let adapter = RxApplicantAutoCompleteItemViewModelAdapter(service: service)
        let viewModel = AutoCompleteSearchViewModel.init(title: "申請人", service: adapter)
        return viewModel
    }

    private func makeViewModelForProductNumber() -> AutoCompleteSearchViewModel {
        let adapter = RxProductNumberAutoCompleteItemViewModelAdapter(service: service)
        let viewModel = AutoCompleteSearchViewModel.init(title: "SKU編號", service: adapter)
        return viewModel
    }
}
