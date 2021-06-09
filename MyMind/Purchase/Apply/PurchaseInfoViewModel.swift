//
//  PurchaseInfoViewModel.swift
//  MyMind
//
//  Created by Barry Chen on 2021/6/8.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import PromiseKit
import RxRelay
import RxSwift

protocol PurchaseWarehouseListService {
    func fetchPurchaseWarehouseList() -> Promise<[Warehouse]>
}

struct PurchaseInfoViewModel {
    // MARK: - Properties
    let title: String = "採購單資訊"
    let suggestionProductMaterialViewModels: [SuggestionProductMaterialViewModel]

    var vandorName: String {
        suggestionProductMaterialViewModels.first?.vendorName ?? ""
    }

    var vandorID: String {
        suggestionProductMaterialViewModels.first?.vendorID ?? ""
    }

    let expectedStorageDate: BehaviorRelay<Date?> = .init(value: nil)
    let warehouseList: BehaviorRelay<[Warehouse]> = .init(value: [])
    let pickedWarehouse: BehaviorRelay<Warehouse?> = .init(value: nil)

    let recipientName: PublishRelay<String> = .init()
    let recipientPhone: PublishRelay<String> = .init()
    let recipientAddress: PublishRelay<String> = .init()

    let expectedStorageDateValidationStatus: BehaviorRelay<ValidationResult> = .init(value: .invalid("此欄位必填"))
    let pickedWarehouseValidationStatus: BehaviorRelay<ValidationResult> = .init(value: .invalid("此欄位必填"))

    let service: PurchaseWarehouseListService
    let bag: DisposeBag = DisposeBag()
    // MARK: - Methods
    init(suggestionProductMaterialViewModels: [SuggestionProductMaterialViewModel], service: PurchaseWarehouseListService) {
        self.suggestionProductMaterialViewModels = suggestionProductMaterialViewModels
        self.service = service
        bindStatus()
        bindRecipientInfo()
    }

    func bindStatus() {
        expectedStorageDate
            .skip(1)
            .map { date -> ValidationResult in
                guard let date = date else { return .invalid("此欄位必填") }
                if date < Date() {
                    return .invalid("入庫日最快只能選擇今天的日期")
                } else {
                    return .valid
                }
            }
            .bind(to: expectedStorageDateValidationStatus)
            .disposed(by: bag)

        pickedWarehouse
            .skip(1)
            .map { warehouse -> ValidationResult in
                warehouse != nil ? .valid : .invalid("此欄位必填")
            }
            .bind(to: pickedWarehouseValidationStatus)
            .disposed(by: bag)
    }

    func bindRecipientInfo() {
        pickedWarehouse
            .compactMap({ $0 })
            .subscribe(onNext: { warehouse in
                recipientName.accept(warehouse.recipientInfo.name)
                recipientPhone.accept(warehouse.recipientInfo.phone)
                recipientAddress.accept(warehouse.recipientInfo.address.fullAddressString)
            })
            .disposed(by: bag)
    }

    func fetchWarehouseList() {
        service.fetchPurchaseWarehouseList()
            .done { warehouses in
                warehouseList.accept(warehouses)
            }
            .catch { error in
                print(error.localizedDescription)
            }
    }
}

protocol PurchaseReviewerListService {
    func fetchPurchaseReviewerList(level: Int) -> Promise<[Reviewer]>
}

struct PickReviewerViewModel {
    // MARK: - Properties
    let reviewerList: BehaviorRelay<[Reviewer]> = .init(value: [])
    let pickedReviewer: BehaviorRelay<Reviewer?> = .init(value: nil)
    let pickedReviewerValidationStatus: BehaviorRelay<ValidationResult> = .init(value: .invalid("此欄位必填"))
    let note: BehaviorRelay<String> = .init(value: "")

    let service: PurchaseReviewerListService

    let bag: DisposeBag = DisposeBag()
    // MARK: - Methods
    init(service: PurchaseReviewerListService) {
        self.service = service
        bindStatus()
    }

    func bindStatus() {
        pickedReviewer
            .skip(1)
            .map { reviewer -> ValidationResult in
                reviewer != nil ? .valid : .invalid("此欄位必填")
            }
            .bind(to: pickedReviewerValidationStatus)
            .disposed(by: bag)
    }

    func fetchPurchaseReviewerList() {
        service.fetchPurchaseReviewerList(level: 1)
            .done { list in
                reviewerList.accept(list)
            }
            .catch { error in
                print(error.localizedDescription)
            }
    }
}

struct ApplyPurchaseParameterInfo: Codable {
    // MARK: - ProductInfo
    struct ProductInfo: Codable {
        let productID, purchaseQuantity, proposedQuantity, channelStockQuantity: String
        let fineStockQuantity, purchaseCost, totalPrice: String

        enum CodingKeys: String, CodingKey {
            case productID = "product_id"
            case purchaseQuantity = "purchase_quantity"
            case proposedQuantity = "proposed_quantity"
            case channelStockQuantity = "channel_stock_quantity"
            case fineStockQuantity = "fine_stock_quantity"
            case purchaseCost = "purchase_cost"
            case totalPrice = "total_price"
        }
    }

    let partnerID, vendorID, expectStorageDate, reviewBy: String
    let remark, expectWarehouseID: String
    let expectWarehouseType: Warehouse.WarehouseType
    let productInfo: [ProductInfo]

    enum CodingKeys: String, CodingKey {
        case partnerID = "partner_id"
        case vendorID = "vendor_id"
        case expectStorageDate = "expect_storage_date"
        case reviewBy = "review_by"
        case remark
        case expectWarehouseType = "expect_warehouse_type"
        case expectWarehouseID = "expect_warehouse_id"
        case productInfo = "product_info"
    }
}

struct PurchaseApplyViewModel {
    let userSession: UserSession
    let purchaseInfoViewModel: PurchaseInfoViewModel
    let pickReviewerViewModel: PickReviewerViewModel

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

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
