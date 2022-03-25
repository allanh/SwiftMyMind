//
//  SaleReportCellViewModel.swift
//  MyMind
//
//  Created by Shih Allan on 2022/3/25.
//  Copyright © 2022 United Digital Intelligence. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class SaleReportCellViewModel {
        
    // 月數據類型 (數量或總額)
    let reportOrderType: BehaviorRelay<SKURankingReport.SKURankingReportSortOrder> = .init(value: .TOTAL_SALE_QUANTITY)

    // 月數據類型 (銷售、取消或退貨)
    let reportPointsType: BehaviorRelay<SaleReportList.SaleReportPointsType> = .init(value: .sale)
    

}
