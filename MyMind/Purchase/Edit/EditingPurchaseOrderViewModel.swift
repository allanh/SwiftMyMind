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
    func returnPurchaseOrder(for id: String, with info: ReturnPurchaseOrderParameterInfo) -> Promise<Void>
}

class EditingPurchaseOrderViewModel {
    enum View {
        case purchasedProducts(viewModels: BehaviorRelay<[SuggestionProductMaterialViewModel]>)
        case purhcaseList
        case purchasedProductInfos(infos: [PurchaseOrder.ProductInfo])
        case error(error: Error)
    }
    let purchaseID: String
    let purchaseOrderLoader: PurchaseOrderLoader
    let service: EditingPurchaseOrderService
    let warehouseListLoader: PurchaseWarehouseListLoader
    let purchaseReviewerListLoader: PurchaseReviewerListLoader
    let reviewing: Bool
    var productInfos: [PurchaseOrder.ProductInfo] = []
    var editable: Bool = false

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
        service: EditingPurchaseOrderService,
        reviewing: Bool) {
        self.purchaseID = purchaseID
        self.purchaseOrderLoader = purchaseOrderLoader
        self.warehouseListLoader = warehouseListLoader
        self.purchaseReviewerListLoader = purchaseReviewerListLoader
        self.service = service
        self.reviewing = reviewing
    }

    func loadPurchaseOrderThenMakeChildViewModels() {
        self.isNetworkProcessing.accept(true)
        purchaseOrderLoader.loadPurchaseOrder(with: purchaseID)
            .ensure { [weak self] in
                self?.isNetworkProcessing.accept(false)
            }
            .done { [weak self] order in
                guard let self = self else { return }
                self.editable = order.status == .pending || order.status == .rejected
                self.makePurchaseApplyInfoViewModel(with: order)
                self.makePickPurchaseReviewerViewModel(with: order)
                self.subscribeChildViewModel(with: order)
                self.didFinishMakeChildViewModels?()
            }
            .catch { error in
                self.navigation(with: .error(error: APIError.serviceError(error.localizedDescription)))
//                print(error.localizedDescription)
            }
    }

    func sendEditedRequest() {
        guard centralizedValidationStatus.value else {
            // Emit current element to update UI in case user didn't do anything before apply
            if let status = pickPurchaseReviewerViewModel?.pickedReviewerValidationStatus {
                status.accept(status.value)
            }

            if let status = purchaseApplyInfoViewModel?.expectedStorageDateValidationStatus {
                status.accept(status.value)
            }
            self.navigation(with: .error(error: APIError.unexpectedError))
//            #warning("Error handling")
            return
        }

        guard let info = makeEditingPurchaseOrderParameterInfo() else {
            self.navigation(with: .error(error: APIError.unexpectedError))
//            #warning("Error handling")
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
                self.navigation(with: .error(error: APIError.serviceError(error.localizedDescription)))
//                #warning("Error handling")
            }
    }
    private func sendAuditRequest(action: ReturnPurchaseOrderParameterInfo.ActionType) {
        guard let info = makeReturnPurchaseOrderParameterInfo(action: action) else {
            self.navigation(with: .error(error: APIError.unexpectedError))
            return
        }

        isNetworkProcessing.accept(true)
        service.returnPurchaseOrder(for: purchaseID, with: info)
            .ensure { [weak self] in
                self?.isNetworkProcessing.accept(false)
            }
            .done { [unowned self] _ in
                self.navigation(with: .purhcaseList)
            }
            .catch { error in
                print(error.localizedDescription)
                self.navigation(with: .error(error: APIError.serviceError(error.localizedDescription)))
            }
    }
    func sendReturnRequest() {
        sendAuditRequest(action: .RETURN)
    }
    func sendRevokeRequest() {
        sendAuditRequest(action: .REVOKED)
    }
    func sendInvalidRequest() {
        sendAuditRequest(action: .VOID)
    }
    private func makePurchaseApplyInfoViewModel(with order: PurchaseOrder) {
        productInfos = order.productInfos

        let viewModels = productInfos.map { info -> SuggestionProductMaterialViewModel in
            let urlString = info.imageInfos.first?.url ?? ""
            let url = URL(string: urlString)
            
            let viewModel = SuggestionProductMaterialViewModel(
                imageURL: url,
                number: info.number,
                originalProductNumber: info.originalProductNumber ?? "",
                name: info.name,
                purchaseSuggestionQuantity: String(info.suggestedQuantity),
                stockUnitName: info.stockUnitName,
                boxStockUnitName: info.boxStockUnitName,
                quantityPerBox: Int(info.quantityPerBox),
                purchaseSuggestionInfo: PurchaseSuggestionInfo(
                    id: String(info.id),
                    number: info.number,
                    originalProductNumber: info.originalProductNumber ?? "",
                    name: info.name,
                    quantityPerBox: String(info.quantityPerBox),
                    channelStockQuantity: String(info.channelStockQuantity ?? 0),
                    fineStockQuantity: String(info.fineStockQuantity ?? 0),
                    totalStockQuantity: String(info.totalStockQuantity ?? 0),
                    monthSaleQuantity: String(info.monthSaleQuantity ?? 0),
                    suggestedQuantity: String(info.suggestedQuantity),
                    daysSalesOfInventory: String(info.daysSalesOfInventory ?? 0),
                    cost: String(info.cost ?? 0),
                    movingAverageCost: String(info.movingAverageCost ?? 0),
                    stockUnitName: info.stockUnitName,
                    boxStockUnitName: info.boxStockUnitName,
                    imageInfos: info.imageInfos),
                purchaseCostPerItem: Double(info.purchaseCost),
                vendorName: order.vendorName,
                vendorID: String(order.vendorID),
                purchasedQuantity: Int(info.purchaseQuantity))

            return viewModel
        }

        let wareHoudse = Warehouse(id: order.expectWarehouseID ?? 0,
                                   name: order.expectStorageName ?? "",
                                   number: "",
                                   type: order.expectWarehouseType ?? .own,
                                   channelWareroomID: order.expectChannelWareroomID ?? "",
                                   recipientInfo: [order.recipientInfo])

        purchaseApplyInfoViewModel = PurchaseApplyInfoViewModel(
            
            suggestionProductMaterialViewModels: viewModels,
            warehouseLoader: warehouseListLoader,
            purchaseID: String(order.id),
            expectedStorageDate: dateFormatter.date(from: order.expectStorageDate),
            pickedWarehouse: wareHoudse,
            purchaseStatus: order.status)
    }

    private func makePickPurchaseReviewerViewModel(with order: PurchaseOrder) {
        pickPurchaseReviewerViewModel = PickPurchaseReviewerViewModel(
            loader: purchaseReviewerListLoader,
            reviewerName: order.reviewerName,
            logInfos: order.logInfos,
            level: order.reviewLevel,
            isLastReview: (reviewing) ? order.lastReview : false,
            editable: (reviewing) ? true : editable)
    }

    func subscribeChildViewModel(with order: PurchaseOrder) {
        guard let purchaseApplyInfoViewModel = purchaseApplyInfoViewModel,
              let pickPurchaseReviewerViewModel = pickPurchaseReviewerViewModel
        else {
            return
        }
        purchaseApplyInfoViewModel.showSuggestionInfo
            .subscribe(onNext: { [unowned self] _ in
                if reviewing {
                    self.navigation(with: .purchasedProductInfos(infos: productInfos))
                } else {
                    self.navigation(with: .purchasedProducts(viewModels: purchaseApplyInfoViewModel.suggestionProductMaterialViewModels))
                }
            })
            .disposed(by: bag)

        if reviewing {
            if order.lastReview {
                Observable.combineLatest([
                    pickPurchaseReviewerViewModel.noteValidationStatus
                ])
                .map({ validationStatus in
                    validationStatus.filter({ $0 != .valid}).isEmpty
                })
                .bind(to: centralizedValidationStatus)
                .disposed(by: bag)
            } else {
                Observable.combineLatest([
                    pickPurchaseReviewerViewModel.pickedReviewerValidationStatus,
                    pickPurchaseReviewerViewModel.noteValidationStatus
                ])
                .map({ validationStatus in
                    validationStatus.filter({ $0 != .valid}).isEmpty
                })
                .bind(to: centralizedValidationStatus)
                .disposed(by: bag)
            }
        } else {
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

        if reviewing {
            if let isLastReview = pickPurchaseReviewerViewModel?.isLastReview, isLastReview {
                let note = pickPurchaseReviewerViewModel?.note.value ?? ""

                guard let pickedWarehouse = purchaseApplyInfoViewModel?.pickedWarehouse.value else { return nil }

                let info = EditingPurchaseOrderParameterInfo(
                    expectStorageDate: expectStorageDate,
                    reviewBy: "",
                    remark: note,
                    expectWarehouseID: String(pickedWarehouse.id),
                    expectWarehouseType: pickedWarehouse.type,
                    warehouseIndex: pickedWarehouse.recipientInfo?.first?.warehouseIndex,
                    productInfo: productInfos
                )
                return info
            } else {
                guard let reviewer = pickPurchaseReviewerViewModel?.pickedReviewer.value else { return nil }

                let note = pickPurchaseReviewerViewModel?.note.value ?? ""

                guard let pickedWarehouse = purchaseApplyInfoViewModel?.pickedWarehouse.value else { return nil }

                let info = EditingPurchaseOrderParameterInfo(
                    expectStorageDate: expectStorageDate,
                    reviewBy: reviewer.id,
                    remark: note,
                    expectWarehouseID: String(pickedWarehouse.id),
                    expectWarehouseType: pickedWarehouse.type,
                    warehouseIndex: pickedWarehouse.recipientInfo?.first?.warehouseIndex,
                    productInfo: productInfos
                )
                return info
            }
        } else {
            guard let reviewer = pickPurchaseReviewerViewModel?.pickedReviewer.value else { return nil }

            let note = pickPurchaseReviewerViewModel?.note.value ?? ""

            guard let pickedWarehouse = purchaseApplyInfoViewModel?.pickedWarehouse.value else { return nil }

            let info = EditingPurchaseOrderParameterInfo(
                expectStorageDate: expectStorageDate,
                reviewBy: reviewer.id,
                remark: note,
                expectWarehouseID: String(pickedWarehouse.id),
                expectWarehouseType: pickedWarehouse.type,
                warehouseIndex: pickedWarehouse.recipientInfo?.first?.warehouseIndex,
                productInfo: productInfos
            )
            return info
        }
    }
    private func makeReturnPurchaseOrderParameterInfo(action: ReturnPurchaseOrderParameterInfo.ActionType) -> ReturnPurchaseOrderParameterInfo? {
        let note = pickPurchaseReviewerViewModel?.note.value ?? ""
        let info = ReturnPurchaseOrderParameterInfo(action: action, remark: note)
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
