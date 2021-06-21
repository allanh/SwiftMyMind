//
//  VendorInfoLoader.swift
//  MyMind
//
//  Created by Barry Chen on 2021/5/31.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import PromiseKit

protocol VendorInfoLoader {
    func loadVendorInfos(with name: String) -> Promise<[VendorInfo]>
}

struct VendorInfoAdapter: VendorInfoLoader {
    let service: AutoCompleteAPIService

    func loadVendorInfos(with name: String) -> Promise<[VendorInfo]> {
        service.vendorNameAutoComplete(searchTerm: name)
            .map { list in
                let items = list.item
                return items.compactMap { autoCompleteInfo in
                    guard let id = autoCompleteInfo.id,
                          let name = autoCompleteInfo.name
                    else { return nil }
                    return VendorInfo(id: id, name: name)
                }
            }
    }
}
