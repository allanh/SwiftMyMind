//
//  PickPurchaseStatusViewModel.swift
//  MyMind
//
//  Created by Barry Chen on 2021/5/28.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import RxRelay

struct PickPurchaseStatusViewModel {
    let title: String = "採購單狀態"
    let placeholder: String = "請選擇"
    let allStatus: [PurchaseStatus] = PurchaseStatus.allCases
    let pickedStatus: BehaviorRelay<PurchaseStatus?> = .init(value: nil)

    func cleanPickedStatus() {
        pickedStatus.accept(nil)
    }
}
