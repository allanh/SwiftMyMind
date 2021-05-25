//
//  Adapters.swift
//  MyMind
//
//  Created by Barry Chen on 2021/5/25.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import RxSwift

protocol RxAutoCompleteItemViewModelService {
    func getAutoCompleteItemViewModel(searchTerm: String) -> Single<[AutoCompleteItemViewModel]>
}

struct RxVendorAutoCompleteItemViewModelAdapter: RxAutoCompleteItemViewModelService {
    let service: PurchaseAutoCompleteAPIService

    func getAutoCompleteItemViewModel(searchTerm: String) -> Single<[AutoCompleteItemViewModel]> {
        return Single<[AutoCompleteItemViewModel]>.create { single in
            service.vendorNameAutoComplete(searchTerm: searchTerm)
                .done { list in
                    let viewModels = list.item.map { AutoCompleteItemViewModel(representTitle: $0.name ?? "", identifier: $0.number ?? "")}
                    single(.success(viewModels))
                }.catch { error in
                    single(.failure(error))
                }
            return Disposables.create()
        }
    }
}

struct RxBrandNameAutoCompleteItemViewModelAdapter: RxAutoCompleteItemViewModelService {
    let service: PurchaseAutoCompleteAPIService

    func getAutoCompleteItemViewModel(searchTerm: String) -> Single<[AutoCompleteItemViewModel]> {
        return Single<[AutoCompleteItemViewModel]>.create { single in
            service.productMaterialBrandNameAutoComplete(searchTerm: searchTerm)
                .done { list in
                    let viewModels = list.item.map { AutoCompleteItemViewModel(representTitle: $0.name ?? "", identifier: $0.name ?? "")}
                    single(.success(viewModels))
                }.catch { error in
                    single(.failure(error))
                }
            return Disposables.create()
        }
    }
}

struct RxProductNumberAutoCompleteItemViewModelAdapter: RxAutoCompleteItemViewModelService {
    let service: PurchaseAutoCompleteAPIService

    func getAutoCompleteItemViewModel(searchTerm: String) -> Single<[AutoCompleteItemViewModel]> {
        return Single<[AutoCompleteItemViewModel]>.create { single in
            service.productNumberAutoComplete(searchTerm: searchTerm)
                .done { list in
                    let viewModels = list.item.map { AutoCompleteItemViewModel(representTitle: $0.number ?? "", identifier: $0.number ?? "")}
                    single(.success(viewModels))
                }.catch { error in
                    single(.failure(error))
                }
            return Disposables.create()
        }
    }
}

struct RxProductNumberSetAutoCompleteItemViewModelAdapter: RxAutoCompleteItemViewModelService {
    let service: PurchaseAutoCompleteAPIService

    func getAutoCompleteItemViewModel(searchTerm: String) -> Single<[AutoCompleteItemViewModel]> {
        return Single<[AutoCompleteItemViewModel]>.create { single in
            service.productNumberSetAutoComplete(searchTerm: searchTerm)
                .done { list in
                    let viewModels = list.item.map { AutoCompleteItemViewModel(representTitle: $0.number ?? "", identifier: $0.number ?? "")}
                    single(.success(viewModels))
                }.catch { error in
                    single(.failure(error))
                }
            return Disposables.create()
        }
    }
}

struct RxOriginalNumberAutoCompleteItemViewModelAdapter: RxAutoCompleteItemViewModelService {
    let service: PurchaseAutoCompleteAPIService

    func getAutoCompleteItemViewModel(searchTerm: String) -> Single<[AutoCompleteItemViewModel]> {
        return Single<[AutoCompleteItemViewModel]>.create { single in
            service.productMaterailOriginalNumberAutoComplete(searchTerm: searchTerm)
                .done { list in
                    let viewModels = list.item.map { AutoCompleteItemViewModel(representTitle: $0.number ?? "", identifier: $0.number ?? "")}
                    single(.success(viewModels))
                }.catch { error in
                    single(.failure(error))
                }
            return Disposables.create()
        }
    }
}
