//
//  PurchaseSuggestionViewModel.swift
//  MyMind
//
//  Created by Barry Chen on 2021/6/4.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class PurchaseSuggestionViewModel {
    enum View {
        case suggestionInfo(PurchaseSuggestionInfo)
        case purchaseApply
    }
    let pickedProductIDList: [String]
    let service: SuggestionProductMaterialViewModeService

    var suggestionProductMaterialViewModels: [SuggestionProductMaterialViewModel] = []

    let didReceiveContent: PublishRelay<[SuggestionProductMaterialViewModel]> = .init()

    let view: PublishRelay<View> = .init()
    let errorMessage: PublishRelay<String> = .init()

    init(pickedProductIDList: [String],
         service: SuggestionProductMaterialViewModeService) {
        self.pickedProductIDList = pickedProductIDList
        self.service = service
    }

    func fetchSuggstionProductMaterialViewModels() {
        service.fetchSuggestionProductMaterialViewModels(with: pickedProductIDList)
            .done { [weak self] viewModels in
                guard let self = self else { return }
                self.suggestionProductMaterialViewModels = viewModels
                self.didReceiveContent.accept(viewModels)
            }
            .catch { [weak self] error in
                guard let self = self else { return }
                self.sendErrorMessage(string: error.localizedDescription)
            }
    }

    func removeSuggestionProductMaterialViewModel(at index: Int) {
        suggestionProductMaterialViewModels.remove(at: index)
    }

    @objc
    func performNextStep() {
        guard validateAllProductMaterailsInfo() else {
            sendErrorMessage(string: "採購資訊有誤！")
            return
        }

        view.accept(.purchaseApply)
    }

    func performSuggestionInfo(for index: Int) {
        let viewModel = suggestionProductMaterialViewModels[index]
        view.accept(.suggestionInfo(viewModel.purchaseSuggestionInfo))
    }

    func validateAllProductMaterailsInfo() -> Bool {
        var result: Bool = true
        suggestionProductMaterialViewModels.forEach { viewModel in
            // Emit quantity element in case user did not input anything
            viewModel.purchaseQuantity.accept(viewModel.purchaseQuantity.value)
            if viewModel.centralizedValidationStatus.value != .valid {
                result = false
            }
        }

        return result
    }

    func sendErrorMessage(string: String) {
        errorMessage.accept(string)
    }
}
