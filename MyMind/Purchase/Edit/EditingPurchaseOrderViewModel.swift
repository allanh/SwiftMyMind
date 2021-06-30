//
//  EditingPurchaseOrderViewModel.swift
//  MyMind
//
//  Created by Barry Chen on 2021/6/28.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import PromiseKit
import RxSwift
import RxRelay

protocol EditingPurchaseOrderService {
    func editPurchaseOrder(for id: String, with info: EditingPurchaseOrderParameterInfo) -> Promise<Void>
}

class EditingPurchaseOrderViewModel {
    enum View {
        case purchasedProducts(viewModels: BehaviorRelay<[SuggestionProductMaterialViewModel]>)
        case purhcaseList
    }
    let purchaseID: String
    let purchaseOrderLoader: PurchaseOrderLoader
    let service: EditingPurchaseOrderService
    let warehouseListLoader: PurchaseWarehouseListLoader
    let purchaseReviewerListLoader: PurchaseReviewerListLoader

    var purchaseApplyInfoViewModel: PurchaseApplyInfoViewModel?
    var pickPurchaseReviewerViewModel: PickPurchaseReviewerViewModel?
    let view: PublishRelay<View> = .init()
    let centralizedValidationStatus: BehaviorRelay<Bool> = .init(value: false)
    let isNetworkProcessing: BehaviorRelay<Bool> = .init(value: false)
    var didFinishMakeChildViewModels: (() -> Void)?

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    let bag: DisposeBag = DisposeBag()

    init(purchaseID: String,
        purchaseOrderLoader: PurchaseOrderLoader,
        warehouseListLoader: PurchaseWarehouseListLoader,
        purchaseReviewerListLoader: PurchaseReviewerListLoader,
        service: EditingPurchaseOrderService) {
        self.purchaseID = purchaseID
        self.purchaseOrderLoader = purchaseOrderLoader
        self.warehouseListLoader = warehouseListLoader
        self.purchaseReviewerListLoader = purchaseReviewerListLoader
        self.service = service
    }

    func loadPurchaseOrderThenMakeChildViewModels() {
        self.isNetworkProcessing.accept(true)
        purchaseOrderLoader.loadPurchaseOrder(with: purchaseID)
            .ensure { [weak self] in
                self?.isNetworkProcessing.accept(false)
            }
            .done { [weak self] order in
                guard let self = self else { return }
                self.makePurchaseApplyInfoViewModel(with: order)
                self.makePickPurchaseReviewerViewModel(with: order)
                self.subscribeChildViewModel()
                self.didFinishMakeChildViewModels?()
            }
            .catch { error in
                print(error.localizedDescription)
            }
    }

    func sendEditedRequest() {
        guard centralizedValidationStatus.value else {
            // Emit current element to update UI in case user didn't do anything before apply
            if let status = pickPurchaseReviewerViewModel?.pickedReviewerValidationStatus {
                status.accept(status.value)
            }
            #warning("Error handling")
            return
        }

        guard let info = makeEditingPurchaseOrderParameterInfo() else {
            #warning("Error handling")
            return
        }

        isNetworkProcessing.accept(true)
        service.editPurchaseOrder(for: purchaseID, with: info)
            .ensure { [weak self] in
                self?.isNetworkProcessing.accept(false)
            }
            .done { [unowned self] _ in
                self.navigation(with: .purhcaseList)
            }
            .catch { error in
                print(error.localizedDescription)
                #warning("Error handling")
            }
    }

    private func makePurchaseApplyInfoViewModel(with order: PurchaseOrder) {
        let productInfos = order.productInfos

        let viewModels = productInfos.map { info -> SuggestionProductMaterialViewModel in
            let urlString = info.imageInfos.first?.url ?? ""
            let url = URL(string: urlString)
            
            let viewModel = SuggestionProductMaterialViewModel(
                imageURL: url,
                number: info.number,
                originalProductNumber: info.originalProductNumber,
                name: info.name,
                purchaseSuggestionQuantity: info.suggestedQuantity,
                stockUnitName: info.stockUnitName,
                boxStockUnitName: info.boxStockUnitName,
                quantityPerBox: Int(info.quantityPerBox) ?? 0,
                purchaseSuggestionInfo: PurchaseSuggestionInfo(
                    id: info.id,
                    number: info.number,
                    originalProductNumber: info.originalProductNumber,
                    name: info.name,
                    quantityPerBox: info.quantityPerBox,
                    channelStockQuantity: info.channelStockQuantity,
                    fineStockQuantity: info.fineStockQuantity,
                    totalStockQuantity: info.totalStockQuantity,
                    monthSaleQuantity: info.monthSaleQuantity,
                    suggestedQuantity: info.suggestedQuantity,
                    daysSalesOfInventory: info.daysSalesOfInventory,
                    cost: info.cost,
                    movingAverageCost: info.movingAverageCost,
                    stockUnitName: info.stockUnitName,
                    boxStockUnitName: info.boxStockUnitName,
                    imageInfos: info.imageInfos),
                purchaseCostPerItem: Double(info.purchaseCost) ?? 0,
                vendorName: order.vendorName,
                vendorID: order.vendorID,
                purchasedQuantity: Int(info.purchaseQuantity) ?? 0)

            return viewModel
        }

        let wareHoudse = Warehouse(name:
                                    order.expectStorageName,
                                   id: order.expectWarehouseID,
                                   number: "",
                                   type: order.expectWarehouseType,
                                   channelWareroomID: order.expectChannelWareroomID,
                                   recipientInfo: order.recipientInfo)

        purchaseApplyInfoViewModel = PurchaseApplyInfoViewModel(
            suggestionProductMaterialViewModels: viewModels,
            warehouseLoader: warehouseListLoader,
            purchaseID: order.id,
            expectedStorageDate: dateFormatter.date(from: order.expectStorageDate),
            pickedWarehouse: wareHoudse)
    }

    private func makePickPurchaseReviewerViewModel(with order: PurchaseOrder) {
        pickPurchaseReviewerViewModel = PickPurchaseReviewerViewModel(
            loader: purchaseReviewerListLoader,
            logInfos: order.logInfos)
    }

    func subscribeChildViewModel() {
        guard let purchaseApplyInfoViewModel = purchaseApplyInfoViewModel,
              let pickPurchaseReviewerViewModel = pickPurchaseReviewerViewModel
        else {
            return
        }
        purchaseApplyInfoViewModel.showSuggestionInfo
            .subscribe(onNext: { [unowned self] _ in
                self.navigation(with: .purchasedProducts(viewModels: purchaseApplyInfoViewModel.suggestionProductMaterialViewModels))
            })
            .disposed(by: bag)

        Observable.combineLatest([
            purchaseApplyInfoViewModel.expectedStorageDateValidationStatus,
            purchaseApplyInfoViewModel.pickedWarehouseValidationStatus,
            pickPurchaseReviewerViewModel.pickedReviewerValidationStatus,
            pickPurchaseReviewerViewModel.noteValidationStatus
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

    private func makeEditingPurchaseOrderParameterInfo() -> EditingPurchaseOrderParameterInfo? {
        guard let productInfos = mapSuggestionProductMaterialViewModelsToProductInfos() else {
            return nil
        }

        guard let date = purchaseApplyInfoViewModel?.expectedStorageDate.value else { return nil }
        let expectStorageDate = dateFormatter.string(from: date)

        guard let reviewer = pickPurchaseReviewerViewModel?.pickedReviewer.value else { return nil }

        let note = pickPurchaseReviewerViewModel?.note.value ?? ""

        guard let pickedWarehouse = purchaseApplyInfoViewModel?.pickedWarehouse.value else { return nil }

        let info = EditingPurchaseOrderParameterInfo(
            expectStorageDate: expectStorageDate,
            reviewBy: reviewer.id,
            remark: note,
            expectWarehouseID: pickedWarehouse.id,
            expectWarehouseType: pickedWarehouse.type,
            productInfo: productInfos
        )
        return info
    }

    func mapSuggestionProductMaterialViewModelsToProductInfos() -> [EditingPurchaseOrderParameterInfo.ProductInfo]? {
        guard let viewModel = purchaseApplyInfoViewModel else {
            return nil
        }

        let suggestionProductMaterialViewModels = viewModel.suggestionProductMaterialViewModels.value

        let infos: [EditingPurchaseOrderParameterInfo.ProductInfo] = suggestionProductMaterialViewModels.map { viewModel in
            let id = viewModel.purchaseSuggestionInfo.id
            let quantity = String(viewModel.purchaseQuantity.value)
            let purchaseCost = String(viewModel.purchaseCostPerItem.value)
            let totalCost = String(viewModel.purchaseCost.value)

            let info = EditingPurchaseOrderParameterInfo.ProductInfo.init(
                productID: id,
                purchaseQuantity: quantity,
                purchaseCost: purchaseCost,
                totalPrice: totalCost)

            return info
        }
        return infos
    }
}
