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

    let title: String = "請選擇SKU"
    var currentProductMaterials: BehaviorRelay<[ProductMaterial]> = .init(value: [])
    var currentQueryInfo: ProductMaterialQueryInfo = .defaultQuery()
    var sortTypes: [ProductMaterialQueryInfo.SortType] = ProductMaterialQueryInfo.SortType.allCases
    var pickedSortTypeIndex: Int = 0
    var pickedMaterialIDs: Set<String> = .init()
    var currentPageInfo: MultiplePageList?
    var view: PublishRelay<PickMaterialView> = .init()
    var isPickSortViewVisible: BehaviorRelay<Bool> = .init(value: false)
    let purchaseAPIService: PurchaseAPIService

    init(purchaseAPIService: PurchaseAPIService) {
        self.purchaseAPIService = purchaseAPIService
    }

    func refreshFetchProductMaterials(with query: ProductMaterialQueryInfo) {
        purchaseAPIService.fetchProductMaterialList(with: query)
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
            let currentPageInfo = currentPageInfo,
            currentPageInfo.currentPageNumber < currentPageInfo.totalAmountOfPages
        else { return }
        currentQuery.pageNumber += 1

        purchaseAPIService.fetchProductMaterialList(with: currentQuery)
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
