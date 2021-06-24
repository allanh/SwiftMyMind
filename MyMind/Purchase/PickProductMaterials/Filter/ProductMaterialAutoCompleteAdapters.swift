//
//  ProductMaterialAutoCompleteAdapters.swift
//  MyMind
//
//  Created by Barry Chen on 2021/5/25.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import RxSwift

struct RxBrandNameAutoCompleteItemViewModelAdapter: RxAutoCompleteItemViewModelLoader {
    let service: AutoCompleteAPIService
    let vendorID: String

    func loadAutoCompleteItemViewModel(with searchTerm: String) -> Single<[AutoCompleteItemViewModel]> {
        return Single<[AutoCompleteItemViewModel]>.create { single in
            service.productMaterialBrandNameAutoComplete(searchTerm: searchTerm, vendorID: vendorID)
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

struct RxProductNumberSetAutoCompleteItemViewModelAdapter: RxAutoCompleteItemViewModelLoader {
    let service: AutoCompleteAPIService

    func loadAutoCompleteItemViewModel(with searchTerm: String) -> Single<[AutoCompleteItemViewModel]> {
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

struct RxOriginalNumberAutoCompleteItemViewModelAdapter: RxAutoCompleteItemViewModelLoader {
    let service: AutoCompleteAPIService

    func loadAutoCompleteItemViewModel(with searchTerm: String) -> Single<[AutoCompleteItemViewModel]> {
        return Single<[AutoCompleteItemViewModel]>.create { single in
            service.productMaterailOriginalNumberAutoComplete(searchTerm: searchTerm)
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
