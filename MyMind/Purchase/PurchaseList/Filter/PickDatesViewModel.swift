//
//  PickDatesViewModel.swift
//  MyMind
//
//  Created by Barry Chen on 2021/5/28.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import RxRelay

struct PickDatesViewModel {
    let title: String
    let startDatePlaceholder: String = "開始日期"
    let endDatePlaceholder: String = "結束日期"
    let startDate: BehaviorRelay<Date?> = .init(value: nil)
    let endDate: BehaviorRelay<Date?> = .init(value: nil)

    func cleanPickedDates() {
        startDate.accept(nil)
        endDate.accept(nil)
    }
}
