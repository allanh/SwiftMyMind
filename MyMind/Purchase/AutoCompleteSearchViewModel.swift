//
//  AutoCompleteSearchViewModel.swift
//  MyMind
//
//  Created by Barry Chen on 2021/5/25.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

struct AutoCompleteSearchViewModel {
    let title: String
    let placeholder: String
    let searchTerm: BehaviorRelay<String> = .init(value: "")
    let loader: RxAutoCompleteItemViewModelLoader
    let autoCompleteItemViewModels: BehaviorRelay<[AutoCompleteItemViewModel]> = .init(value: [])
    let pickedItemViewModels: BehaviorRelay<[AutoCompleteItemViewModel]> = .init(value: [])
    let isDropDownViewPresenting: BehaviorRelay<Bool> = .init(value: false)
    let bag: DisposeBag = DisposeBag()

    init(title: String,
         placeholder: String,
         loader: RxAutoCompleteItemViewModelLoader) {
        self.title = title
        self.placeholder = placeholder
        self.loader = loader
        bindSearchTerm()
    }

    func bindSearchTerm() {
        searchTerm
            .flatMap(loader.loadAutoCompleteItemViewModel(with:))
            .subscribe(onNext: { items in
                autoCompleteItemViewModels.accept(items)
            })
            .disposed(by: bag)
    }

    func pickItemViewModel(itemViewModel: AutoCompleteItemViewModel) {
        var tempPickedItemViewModels = pickedItemViewModels.value
        if let index = tempPickedItemViewModels.firstIndex(of: itemViewModel) {
            tempPickedItemViewModels.remove(at: index)
        } else {
            tempPickedItemViewModels.append(itemViewModel)
        }
        pickedItemViewModels.accept(tempPickedItemViewModels)
    }

    func cleanPickedItemViewModel() {
        pickedItemViewModels.accept([])
    }
}

struct AutoCompleteItemViewModel: Equatable {
    let representTitle: String
    let identifier: String
}
