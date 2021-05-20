//
//  PickProductMaterialsViewModel.swift
//  MyMind
//
//  Created by Chen Yi-Wei on 2021/5/18.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

enum PickMaterialView {
    case filter, suggestion
}
class PickProductMaterialsViewModel {
    // MARK: - Properties
    let title: String = "請選擇SKU"
    let currentProductMaterials: BehaviorRelay<[ProductMaterial]> = .init(value: [])
    var currentQueryInfo: ProductMaterialQueryInfo = .defaultQuery()
    let currentSortType: BehaviorRelay<ProductMaterialQueryInfo.SortType> = .init(value: .number)
    var pickedSortTypeIndex: Int = 0
    var pickedMaterialIDs: Set<String> = .init()
    var currentPageInfo: MultiplePageList?
    let view: PublishRelay<PickMaterialView> = .init()
    let isPickSortViewVisible: BehaviorRelay<Bool> = .init(value: false)
    let isNetworkProcessing: BehaviorRelay<Bool> = .init(value: false)
    let purchaseAPIService: PurchaseAPIService

    private let bag: DisposeBag = DisposeBag()
    // MARK: - Methods
    init(purchaseAPIService: PurchaseAPIService) {
        self.purchaseAPIService = purchaseAPIService
        subscribeSortType()
    }

    private func subscribeSortType() {
        currentSortType.asObservable()
            .skip(1)
            .subscribe(onNext: { [unowned self] sortType in
                self.currentQueryInfo.sortType = sortType
                self.refreshFetchProductMaterials(with: currentQueryInfo)
            })
            .disposed(by: bag)
    }

    func refreshFetchProductMaterials(with query: ProductMaterialQueryInfo) {
        guard isNetworkProcessing.value == false else { return }
        isNetworkProcessing.accept(true)
        purchaseAPIService.fetchProductMaterialList(with: query)
            .ensure {
                self.isNetworkProcessing.accept(false)
            }
            .done { [weak self] list in
                guard let self = self else { return }
                self.currentPageInfo = list
                self.currentProductMaterials.accept(list.materials)
            }
            .catch { error in
                print(error.localizedDescription)
                #warning("error handling")
            }
    }

    func fetchMoreProductMaterials( with currentQuery: inout ProductMaterialQueryInfo) {
        guard
            isNetworkProcessing.value == false,
            let currentPageInfo = currentPageInfo,
            currentPageInfo.currentPageNumber < currentPageInfo.totalAmountOfPages
        else { return }
        isNetworkProcessing.accept(true)
        currentQuery.pageNumber += 1

        purchaseAPIService.fetchProductMaterialList(with: currentQuery)
            .ensure {
                self.isNetworkProcessing.accept(false)
            }
            .done { [weak self] list in
                guard let self = self else { return }
                self.currentPageInfo = list
                let newMaterials = self.currentProductMaterials.value + list.materials
                self.currentProductMaterials.accept(newMaterials)
            }
            .catch { error in
                #warning("error handling")
            }
    }

    func selectMaterial(at index: Int) {
        let material = currentProductMaterials.value[index]
        if pickedMaterialIDs.insert(material.id).inserted == false {
            pickedMaterialIDs.remove(material.id)
        }
    }

    func showFilter() {
        view.accept(.filter)
    }

    func pushSuggestion() {
        view.accept(.suggestion)
    }
}
