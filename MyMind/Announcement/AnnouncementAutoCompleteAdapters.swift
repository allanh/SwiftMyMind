//
//  AnnouncementAutoCompleteAdapters.swift
//  MyMind
//
//  Created by Chijung Chan on 2021/8/20.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import RxSwift

struct RxTitleAutoCompletItemViewModelAdapter: RxAutoCompleteItemViewModelLoader {
    let service: AutoCompleteAPIService
    
    func loadAutoCompleteItemViewModel(with searchTerm: String) -> Single<[AutoCompleteItemViewModel]> {
        return Single<[AutoCompleteItemViewModel]>.create {
            single in
            service.announcementTitleAutoComplete(searchTerm: searchTerm)
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
struct RxTypeAutoCompletItemViewModelAdapter: RxAutoCompleteItemViewModelLoader {
    let service: AutoCompleteAPIService
    func loadAutoCompleteItemViewModel(with searchTerm: String) -> Single<[AutoCompleteItemViewModel]> {
        return Single<[AutoCompleteItemViewModel]>.create {
            single in
            service.announcementTypeAutoComplete(searchTerm: searchTerm)
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
