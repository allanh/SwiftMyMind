//
//  SuggestionProductMaterialViewModelsLoader.swift
//  MyMind
//
//  Created by Barry Chen on 2021/6/28.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import PromiseKit

protocol SuggestionProductMaterialViewModelsLoader {
    func loadSuggestionProductMaterialViewModels() -> Promise<[SuggestionProductMaterialViewModel]>
}

struct CachedSuggestionProductMaterialViewModelsLoader: SuggestionProductMaterialViewModelsLoader {
    let viewModels: [SuggestionProductMaterialViewModel]

    func loadSuggestionProductMaterialViewModels() -> Promise<[SuggestionProductMaterialViewModel]> {
        return .init { seal in
            seal.fulfill(viewModels)
        }
    }
}
