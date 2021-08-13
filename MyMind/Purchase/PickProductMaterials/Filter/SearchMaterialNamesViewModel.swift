//
//  SearchMaterialNamesViewModel.swift
//  MyMind
//
//  Created by Barry Chen on 2021/5/25.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import RxRelay

struct SearchMaterialNameViewModel {
    let title: String = "SKU名稱"
    let placeholder: String = "請輸入SKU名稱"
    let searchTerm: BehaviorRelay<String> = .init(value: "")
    let addedSearchTerms: BehaviorRelay<[String]> = .init(value: [])

    func addSearchTerm() {
        let searchTerm = searchTerm.value
        var tempAdded = addedSearchTerms.value
        tempAdded.append(searchTerm)
        addedSearchTerms.accept(tempAdded)
    }
    
    func removeSearchTerm(at index: Int) {
        var tempAddedSearchTerms = addedSearchTerms.value
        tempAddedSearchTerms.remove(at: index)
        addedSearchTerms.accept(tempAddedSearchTerms)

    }
}
