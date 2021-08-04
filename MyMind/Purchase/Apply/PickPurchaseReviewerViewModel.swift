//
//  PickPurchaseReviewerViewModel.swift
//  MyMind
//
//  Created by Barry Chen on 2021/6/9.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

struct PickPurchaseReviewerViewModel {
    // MARK: - Properties
    let level: Int
    let isLastReview: Bool
    let reviewerList: BehaviorRelay<[Reviewer]> = .init(value: [])
    let editable: Bool
    let pickedReviewer: BehaviorRelay<Reviewer?> = .init(value: nil)
    let pickedReviewerValidationStatus: BehaviorRelay<ValidationResult> = .init(value: .invalid("此欄位必填"))
    let note: BehaviorRelay<String> = .init(value: "")
    let noteValidationStatus: BehaviorRelay<ValidationResult> = .init(value: .valid)
    let reviewerName: BehaviorRelay<String?> = .init(value: nil)

    let loader: PurchaseReviewerListLoader
    var logInfos: [PurchaseOrder.LogInfo]?

    let bag: DisposeBag = DisposeBag()
    // MARK: - Methods
    init(loader: PurchaseReviewerListLoader,
         reviewerName: String? = nil,
         logInfos: [PurchaseOrder.LogInfo]? = nil,
         level: Int = 0,
         isLastReview: Bool = false,
         editable: Bool = true) {
        self.loader = loader
        self.logInfos = logInfos
        self.level = level
        self.isLastReview = isLastReview
        self.editable = editable
        bindStatus()
        self.reviewerName.accept(reviewerName)
    }

    func bindStatus() {
        pickedReviewer
            .skip(1)
            .map { reviewer -> ValidationResult in
                reviewer != nil ? .valid : .invalid("此欄位必填")
            }
            .bind(to: pickedReviewerValidationStatus)
            .disposed(by: bag)

        note
            .map { text -> ValidationResult in
                let count = text.count
                return count <= 200 ? .valid : .invalid("最多 200 個字元")
            }
            .bind(to: noteValidationStatus)
            .disposed(by: bag)
    }

    func loadPurchaseReviewerList() {
        loader.loadPurchaseReviewerList(level: level+1)
            .done { list in
                reviewerList.accept(list)
            }
            .catch { error in
                print(error.localizedDescription)
                #warning("Error handling")
            }
    }
}
