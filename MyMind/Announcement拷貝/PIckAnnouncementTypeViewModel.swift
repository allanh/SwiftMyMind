//
//  PIckAnnouncementTypeViewModel.swift
//  MyMind
//
//  Created by Chijung Chan on 2021/8/30.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import RxRelay

struct PickAnnouncementTypeViewModel {
    let title: String = "公告類別"
    let placeholder: String = "請選擇"
    let allType: [AnnouncementType] = AnnouncementType.allCases
    let pickedType: BehaviorRelay<AnnouncementType?> = .init(value: nil)
    
    func cleanPickedType() {
        pickedType.accept(nil)
    }
}
