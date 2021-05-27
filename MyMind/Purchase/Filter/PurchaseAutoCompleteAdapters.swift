//
//  PurchaseAutoCompleteAdapters.swift
//  MyMind
//
//  Created by Barry Chen on 2021/5/27.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import RxSwift

protocol RxAutoCompleteItemViewModelService {
    func getAutoCompleteItemViewModel(searchTerm: String) -> Single<[AutoCompleteItemViewModel]>
}

struct RxPurchaseNumberAutoCompleteItemViewModelAdapter: RxAutoCompleteItemViewModelService {
    let service: AutoCompleteAPIService

    func getAutoCompleteItemViewModel(searchTerm: String) -> Single<[AutoCompleteItemViewModel]> {
        return Single<[AutoCompleteItemViewModel]>.create { single in
            service.purchaseNumberAutoComplete(searchTerm: searchTerm)
                .done { list in
                    let items = list.item.map { AutoCompleteItemViewModel(representTitle: $0.number ?? "", identifier: $0.number ?? "") }
                    single(.success(items))
                }
                .catch { error in
                    single(.failure(error))
                }
            return Disposables.create()
        }
    }
}

struct RxVendorAutoCompleteItemViewModelAdapter: RxAutoCompleteItemViewModelService {
    let service: AutoCompleteAPIService

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

struct RxApplicantAutoCompleteItemViewModelAdapter: RxAutoCompleteItemViewModelService {
    let service: AutoCompleteAPIService

    func getAutoCompleteItemViewModel(searchTerm: String) -> Single<[AutoCompleteItemViewModel]> {
        return Single<[AutoCompleteItemViewModel]>.create { single in
            service.applicantAutoComplete(searchTerm: searchTerm)
                .done { list in
                    let items = list.item.map { AutoCompleteItemViewModel(representTitle: $0.name ?? "", identifier: $0.id ?? "") }
                    single(.success(items))
                }
                .catch { error in
                    single(.failure(error))
                }
            return Disposables.create()
        }
    }
}

struct RxProductNumberAutoCompleteItemViewModelAdapter: RxAutoCompleteItemViewModelService {
    let service: AutoCompleteAPIService

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
