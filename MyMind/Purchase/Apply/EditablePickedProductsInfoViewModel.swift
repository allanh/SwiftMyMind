//
//  EditablePickedProductsInfoViewModel.swift
//  MyMind
//
//  Created by Barry Chen on 2021/6/16.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

struct EditablePickedProductsInfoViewModel {
    enum View {
        case suggestionInfo(PurchaseSuggestionInfo)
        case purchaseApply
    }

    let pickedProductMaterialViewModels: BehaviorRelay<[SuggestionProductMaterialViewModel]>
    let view: PublishRelay<View> = .init()


    func removeSuggestionProductMaterialViewModel(at index: Int) {
        var tempViewModels = pickedProductMaterialViewModels.value
        guard index < tempViewModels.count else { return }
        tempViewModels.remove(at: index)
        pickedProductMaterialViewModels.accept(tempViewModels)
    }

    func validateAllProductMaterailsInfo() -> Bool {
        var result: Bool = true
        pickedProductMaterialViewModels.value.forEach { viewModel in
            if viewModel.centralizedValidationStatus.value != .valid {
                result = false
            }
        }

        return result
    }

    func backToApply() {
        guard validateAllProductMaterailsInfo() else { return }
        view.accept(.purchaseApply)
    }

    func showSuggestionInfo(index: Int) {
        let info = pickedProductMaterialViewModels.value[index].purchaseSuggestionInfo
        view.accept(.suggestionInfo(info))
    }
}
