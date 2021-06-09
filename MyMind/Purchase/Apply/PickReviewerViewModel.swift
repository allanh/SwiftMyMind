//
//  PickReviewerViewModel.swift
//  MyMind
//
//  Created by Barry Chen on 2021/6/9.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

struct PickReviewerViewModel {
    // MARK: - Properties
    let reviewerList: BehaviorRelay<[Reviewer]> = .init(value: [])
    let pickedReviewer: BehaviorRelay<Reviewer?> = .init(value: nil)
    let pickedReviewerValidationStatus: BehaviorRelay<ValidationResult> = .init(value: .invalid("此欄位必填"))
    let note: BehaviorRelay<String> = .init(value: "")

    let service: PurchaseReviewerListService

    let bag: DisposeBag = DisposeBag()
    // MARK: - Methods
    init(service: PurchaseReviewerListService) {
        self.service = service
        bindStatus()
    }

    func bindStatus() {
        pickedReviewer
            .skip(1)
            .map { reviewer -> ValidationResult in
                reviewer != nil ? .valid : .invalid("此欄位必填")
            }
            .bind(to: pickedReviewerValidationStatus)
            .disposed(by: bag)
    }

    func fetchPurchaseReviewerList() {
        service.fetchPurchaseReviewerList(level: 1)
            .done { list in
                reviewerList.accept(list)
            }
            .catch { error in
                print(error.localizedDescription)
            }
    }
}
