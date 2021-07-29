//
//  PurchaseApplyViewModel.swift
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
        case suggestion(viewModels: BehaviorRelay<[SuggestionProductMaterialViewModel]>)
        case finish(purchaseID: String)
        case error(descriptions: String)
    }
    let userSessionDataStore: UserSessionDataStore
    let purchaseInfoViewModel: PurchaseApplyInfoViewModel
    let pickReviewerViewModel: PickPurchaseReviewerViewModel
    let view: PublishRelay<View> = .init()
    let centralizedValidationStatus: BehaviorRelay<Bool> = .init(value: false)
    let isNetworkProcessing: BehaviorRelay<Bool> = .init(value: false)

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    let service: ApplyPuchaseService
    let bag: DisposeBag = DisposeBag()

    init(userSessionDataStore: UserSessionDataStore, purchaseInfoViewModel: PurchaseApplyInfoViewModel, pickReviewerViewModel: PickPurchaseReviewerViewModel, service: ApplyPuchaseService) {
        self.userSessionDataStore = userSessionDataStore
        self.purchaseInfoViewModel = purchaseInfoViewModel
        self.pickReviewerViewModel = pickReviewerViewModel
        self.service = service

        subscribeChildViewModel()
    }

    func applyPurchase() {
        guard centralizedValidationStatus.value else {
            // Emit current element to update UI in case user didn't do anything before apply
            purchaseInfoViewModel.expectedStorageDateValidationStatus
                .accept(purchaseInfoViewModel.expectedStorageDateValidationStatus.value)
            purchaseInfoViewModel.pickedWarehouseValidationStatus
                .accept(purchaseInfoViewModel.pickedWarehouseValidationStatus.value)
            pickReviewerViewModel.pickedReviewerValidationStatus
                .accept(pickReviewerViewModel.pickedReviewerValidationStatus.value)
            return
        }

        guard let purchaseInfo = mapCurrentInfoToApplyPurchaseParameterInfo() else {
            return
        }

        isNetworkProcessing.accept(true)
        service.applyPuchase(purchaseInfo: purchaseInfo)
            .ensure {
                isNetworkProcessing.accept(false)
            }
            .done { purchaseID in
                let view: View = .finish(purchaseID: purchaseID)
                navigation(with: view)
            }
            .catch { error in
                navigation(with: .error(descriptions: error.localizedDescription))
            }
    }

    func subscribeChildViewModel() {
        purchaseInfoViewModel.showSuggestionInfo
            .subscribe(onNext: { _ in
                navigation(with: .suggestion(viewModels: purchaseInfoViewModel.suggestionProductMaterialViewModels))
            })
            .disposed(by: bag)

        Observable.combineLatest([
            purchaseInfoViewModel.expectedStorageDateValidationStatus,
            purchaseInfoViewModel.pickedWarehouseValidationStatus,
            pickReviewerViewModel.pickedReviewerValidationStatus,
            pickReviewerViewModel.noteValidationStatus
        ])
        .map({ validationStatus in
            validationStatus.filter({ $0 != .valid}).isEmpty
        })
        .bind(to: centralizedValidationStatus)
        .disposed(by: bag)

    }

    func navigation(with view: View) {
        self.view.accept(view)
    }

    func mapCurrentInfoToApplyPurchaseParameterInfo() -> ApplyPurchaseParameterInfo? {
        guard let userSession = userSessionDataStore.readUserSession() else {
            return nil
        }

        let partnerID = String(userSession.partnerInfo.id)

        let vendorID = purchaseInfoViewModel.vendorID

        guard let date = purchaseInfoViewModel.expectedStorageDate.value else { return nil }
        let expectStorageDate = dateFormatter.string(from: date)

        guard let reviewer = pickReviewerViewModel.pickedReviewer.value else { return nil }

        let note = pickReviewerViewModel.note.value

        guard let pickedWarehouse = purchaseInfoViewModel.pickedWarehouse.value else { return nil }
        let warehouseID = pickedWarehouse.id
        let warehouseType = pickedWarehouse.type
        let warehouseIndex: Int = pickedWarehouse.recipientInfo?.first?.warehouseIndex ?? 0

        let infos: [ApplyPurchaseParameterInfo.ProductInfo] = mapSuggestionProductMaterialViewModelsToProductInfos()

        let applyPurchaseParameterInfo: ApplyPurchaseParameterInfo = .init(
            partnerID: partnerID,
            vendorID: vendorID,
            expectStorageDate: expectStorageDate,
            reviewBy: reviewer.id,
            remark: note,
            expectWarehouseID: String(warehouseID),
            expectWarehouseType: warehouseType,
            warehouseIndex: warehouseIndex,
            productInfo: infos)
        return applyPurchaseParameterInfo
    }

    func mapSuggestionProductMaterialViewModelsToProductInfos() -> [ApplyPurchaseParameterInfo.ProductInfo] {
        let viewModels = purchaseInfoViewModel.suggestionProductMaterialViewModels.value
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
