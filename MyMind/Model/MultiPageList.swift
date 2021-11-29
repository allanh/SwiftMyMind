//
//  MultiPageList.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/9/27.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
protocol MultiplePageList {
    var totalAmountOfItems: Int { get }
    var totalAmountOfPages: Int { get }
    var itemsPerPage: Int { get }
    var currentPageNumber: Int { get }
}
