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

struct AutoCompleteItemViewModel: Equatable {
    let representTitle: String
    let identifier: String
}

struct AutoCompleteSearchViewModel {
    let title: String
    let searchTerm: BehaviorRelay<String> = .init(value: "")
    let service: RxAutoCompleteItemViewModelService
    let autoCompleteItemViewModels: BehaviorRelay<[AutoCompleteItemViewModel]> = .init(value: [])
    let pickedItemViewModels: BehaviorRelay<[AutoCompleteItemViewModel]> = .init(value: [])
    let bag: DisposeBag = DisposeBag()

    init(title: String,
         service: RxAutoCompleteItemViewModelService) {
        self.title = title
        self.service = service
        bindSearchTerm()
    }

    func bindSearchTerm() {
        searchTerm
            .flatMap(service.getAutoCompleteItemViewModel(searchTerm:))
            .bind(to: autoCompleteItemViewModels)
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
