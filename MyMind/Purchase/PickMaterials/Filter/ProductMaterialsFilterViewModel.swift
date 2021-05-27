//
//  ProductMaterialsFilterViewModel.swift
//  MyMind
//
//  Created by Barry Chen on 2021/5/25.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class ProductMaterialsFilterViewModel {
    let title: String = "篩選條件"
    var queryInfo: ProductMaterialQueryInfo = .defaultQuery()
    let didUpdateQueryInfo: (ProductMaterialQueryInfo) -> Void
    let service: AutoCompleteAPIService

    lazy var vendorViewModel: AutoCompleteSearchViewModel = {
        makeViewModelForVendor()
    }()

    lazy var brandNameViewModel: AutoCompleteSearchViewModel = {
        makeViewModelForBrandName()
    }()

    lazy var productNumberViewModel: AutoCompleteSearchViewModel = {
        makeViewModelForProductNumber()
    }()

    lazy var productNumberSetViewModel: AutoCompleteSearchViewModel = {
        makeViewModelForProductNumberSet()
    }()

    lazy var originalNumberViewModel: AutoCompleteSearchViewModel = {
        makeViewModelForOriginalNumber()
    }()

    let searchMaterialNameViewModel: SearchMaterialNameViewModel = SearchMaterialNameViewModel()

    let bag: DisposeBag = DisposeBag()

    init(service: AutoCompleteAPIService,
         queryInfo: ProductMaterialQueryInfo,
         didUpdateQueryInfo: @escaping (ProductMaterialQueryInfo) -> Void) {
        self.service = service
        self.queryInfo = queryInfo
        self.didUpdateQueryInfo = didUpdateQueryInfo
        observerChildViewModels()
    }

    func observerChildViewModels() {
        vendorViewModel.pickedItemViewModels
            .subscribe(onNext: { [unowned self] viewModels in
                self.queryInfo.vendorIDs = viewModels.map {
                    AutoCompleteInfo(id: $0.identifier, number: nil, name: $0.representTitle)
                }
            })
            .disposed(by: bag)

        brandNameViewModel.pickedItemViewModels
            .subscribe(onNext: { [unowned self] viewModels in
                self.queryInfo.brandNames = viewModels.map {
                    AutoCompleteInfo(id: nil, number: nil, name: $0.identifier)
                }
            })
            .disposed(by: bag)

        productNumberViewModel.pickedItemViewModels
            .subscribe(onNext: { [unowned self] viewModels in
                self.queryInfo.materialNumbers = viewModels.map {
                    AutoCompleteInfo(id: nil, number: $0.identifier, name: nil)
                }
            })
            .disposed(by: bag)

        productNumberSetViewModel.pickedItemViewModels
            .subscribe(onNext: { [unowned self] viewModels in
                self.queryInfo.materialNumbers = viewModels.map {
                    AutoCompleteInfo(id: nil, number: $0.identifier, name: $0.identifier)
                }
            })
            .disposed(by: bag)

        originalNumberViewModel.pickedItemViewModels
            .subscribe(onNext: { [unowned self] viewModels in
                self.queryInfo.originalMaterialNumbers = viewModels.map {
                    AutoCompleteInfo(id: nil, number: nil, name: $0.identifier)
                }
            }) 
            .disposed(by: bag)

        searchMaterialNameViewModel.addedSearchTerms
            .subscribe(onNext: { [unowned self] names in
                self.queryInfo.materailNames = names
            })
            .disposed(by: bag)
    }

    func confirmSearch() {
        didUpdateQueryInfo(queryInfo)
    }

    func cleanToDefaultStatus() {
        vendorViewModel.pickedItemViewModels.accept([])
        brandNameViewModel.pickedItemViewModels.accept([])
        productNumberViewModel.pickedItemViewModels.accept([])
        productNumberSetViewModel.pickedItemViewModels.accept([])
        originalNumberViewModel.pickedItemViewModels.accept([])
        searchMaterialNameViewModel.addedSearchTerms.accept([])
    }

    func makeViewModelForVendor() -> AutoCompleteSearchViewModel {
        let adapter = RxVendorAutoCompleteItemViewModelAdapter(service: service)
        let viewModel = AutoCompleteSearchViewModel.init(title: "供應商", service: adapter)
        let items = queryInfo.vendorIDs.map { AutoCompleteItemViewModel(representTitle: $0.name ?? "", identifier: $0.id ?? "")}
        viewModel.pickedItemViewModels.accept(items)
        return viewModel
    }

    func makeViewModelForBrandName() -> AutoCompleteSearchViewModel {
        let adapter = RxBrandNameAutoCompleteItemViewModelAdapter(service: service)
        let viewModel = AutoCompleteSearchViewModel.init(title: "品牌名稱", service: adapter)
        let items = queryInfo.brandNames.map { AutoCompleteItemViewModel(representTitle: $0.name ?? "", identifier: $0.name ?? "")}
        viewModel.pickedItemViewModels.accept(items)
        return viewModel
    }

    func makeViewModelForProductNumber() -> AutoCompleteSearchViewModel {
        let adapter = RxProductNumberAutoCompleteItemViewModelAdapter(service: service)
        let viewModel = AutoCompleteSearchViewModel.init(title: "SKU編號", service: adapter)
        let items = queryInfo.materialNumbers.map { AutoCompleteItemViewModel(representTitle: $0.number ?? "", identifier: $0.number ?? "")}
        viewModel.pickedItemViewModels.accept(items)
        return viewModel
    }

    func makeViewModelForProductNumberSet() -> AutoCompleteSearchViewModel {
        let adapter = RxProductNumberSetAutoCompleteItemViewModelAdapter(service: service)
        let viewModel = AutoCompleteSearchViewModel.init(title: "組合編號", service: adapter)
        let items = queryInfo.materailSetNumbers.map { AutoCompleteItemViewModel(representTitle: $0.number ?? "", identifier: $0.number ?? "")}
        viewModel.pickedItemViewModels.accept(items)
        return viewModel
    }

    func makeViewModelForOriginalNumber() -> AutoCompleteSearchViewModel {
        let adapter = RxOriginalNumberAutoCompleteItemViewModelAdapter(service: service)
        let viewModel = AutoCompleteSearchViewModel.init(title: "原廠料號", service: adapter)
        let items = queryInfo.originalMaterialNumbers.map { AutoCompleteItemViewModel(representTitle: $0.name ?? "", identifier: $0.name ?? "")}
        viewModel.pickedItemViewModels.accept(items)
        return viewModel
    }
}
