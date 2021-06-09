//
//  PurchaseApplyViewMoedl.swift
//  MyMind
//
//  Created by Barry Chen on 2021/6/9.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

struct PurchaseApplyViewModel {
    enum View {
        case suggestion(viewModels: [SuggestionProductMaterialViewModel])
        case finish(purchaseID: String)
    }
    let userSession: UserSession
    let purchaseInfoViewModel: PurchaseInfoViewModel
    let pickReviewerViewModel: PickReviewerViewModel
    let view: PublishRelay<View> = .init()
    let isNetworkProcessing: BehaviorRelay<Bool> = .init(value: false)

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    let service: ApplyPuchaseService
    let bag: DisposeBag = DisposeBag()

    func applyPurchase() {
        guard let purchaseInfo = mapCurrentInfoToApplyPurchaseParameterInfo() else {
            return
        }
        isNetworkProcessing.accept(true)
        service.applyPuchase(purchaseInfo: purchaseInfo)
            .ensure {
                isNetworkProcessing.accept(true)
            }
            .done { purchaseID in
                let view: View = .finish(purchaseID: purchaseID)
                navigation(with: view)
            }
            .catch { error in
                print(error.localizedDescription)
            }
    }

    func subscribeChildViewModel() {
        purchaseInfoViewModel.showSuggestionInfo
            .subscribe(onNext: { _ in
                navigation(with: .suggestion(viewModels: purchaseInfoViewModel.suggestionProductMaterialViewModels))
            })
            .disposed(by: bag)
    }

    func navigation(with view: View) {
        self.view.accept(view)
    }

    func mapCurrentInfoToApplyPurchaseParameterInfo() -> ApplyPurchaseParameterInfo? {
        let partnerID = String(userSession.partnerInfo.id)
        let vendorID = purchaseInfoViewModel.vandorID

        guard let date = purchaseInfoViewModel.expectedStorageDate.value else { return nil }
        let expectStorageDate = dateFormatter.string(from: date)

        guard let reviewer = pickReviewerViewModel.pickedReviewer.value else { return nil }

        let note = pickReviewerViewModel.note.value

        guard let pickedWarehouse = purchaseInfoViewModel.pickedWarehouse.value else { return nil }
        let warehouseID = pickedWarehouse.id
        let warehouseType = pickedWarehouse.type

        let infos: [ApplyPurchaseParameterInfo.ProductInfo] = mapSuggestionProductMaterialViewModelsToProductInfos()

        let applyPurchaseParameterInfo: ApplyPurchaseParameterInfo = .init(
            partnerID: partnerID,
            vendorID: vendorID,
            expectStorageDate: expectStorageDate,
            reviewBy: reviewer.id,
            remark: note,
            expectWarehouseID: warehouseID,
            expectWarehouseType: warehouseType,
            productInfo: infos)
        return applyPurchaseParameterInfo
    }

    func mapSuggestionProductMaterialViewModelsToProductInfos() -> [ApplyPurchaseParameterInfo.ProductInfo] {
        let viewModels = purchaseInfoViewModel.suggestionProductMaterialViewModels
        let infos: [ApplyPurchaseParameterInfo.ProductInfo] = viewModels.map { viewModel in
            let id = viewModel.purchaseSuggestionInfo.id
            let quantity = String(viewModel.purchaseQuantity.value)
            let suggestedPurchaseQuantity = viewModel.purchaseSuggestionInfo.suggestedQuantity
            let channelStockQuantity = viewModel.purchaseSuggestionInfo.channelStockQuantity
            let fineStockQuantity = viewModel.purchaseSuggestionInfo.fineStockQuantity
            let purchaseCost = String(viewModel.purchaseCostPerItem.value)
            let totalCost = String(viewModel.purchaseCost.value)

            let info: ApplyPurchaseParameterInfo.ProductInfo = .init(
                productID: id,
                purchaseQuantity: quantity,
                proposedQuantity: suggestedPurchaseQuantity,
                channelStockQuantity: channelStockQuantity,
                fineStockQuantity: fineStockQuantity,
                purchaseCost: purchaseCost,
                totalPrice: totalCost)
            return info
        }
        return infos
    }
}
