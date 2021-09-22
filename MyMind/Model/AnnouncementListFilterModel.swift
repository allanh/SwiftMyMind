//
//  AnnouncementListFilterModel.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/9/22.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift
struct AnnouncementListFilterModel {
    let queryInfo: AnnouncementListQueryInfo
    let title: BehaviorRelay<String?> = .init(value: nil)
    let type: BehaviorRelay<AnnouncementType?> = .init(value: nil)
    let startDate: BehaviorRelay<Date?> = .init(value: nil)
    let endDate: BehaviorRelay<Date?> = .init(value: nil)
    let didUpdateQueryInfo: (AnnouncementListQueryInfo) -> Void
    let didCancelUpdate: () -> Void

    let bag: DisposeBag = DisposeBag()

    func reset() {
        title.accept(nil)
        startDate.accept(nil)
        endDate.accept(nil)
        type.accept(nil)
    }
    init(queryInfo: AnnouncementListQueryInfo, didUpdateQueryInfo: @escaping (AnnouncementListQueryInfo) -> Void, didCancelUpdate: @escaping () -> Void) {
        self.queryInfo = queryInfo
        self.didUpdateQueryInfo = didUpdateQueryInfo
        self.didCancelUpdate = didCancelUpdate
        subscribe()
        updateWithCurrentQuery()
    }
    private func updateWithCurrentQuery() {
        title.accept(queryInfo.title)
        type.accept(queryInfo.type)
        startDate.accept(queryInfo.start)
        endDate.accept(queryInfo.end)
    }
    private func subscribe() {
        title
            .subscribe(onNext: { title in
                self.queryInfo.title = title
            })
            .disposed(by: bag)
        startDate
            .subscribe(onNext: { date in
                self.queryInfo.start = date
            })
            .disposed(by: bag)
        endDate
            .subscribe(onNext: { date in
                self.queryInfo.end = date
            })
            .disposed(by: bag)
        type
            .subscribe(onNext: { announcementType in
                self.queryInfo.type = announcementType
            })
            .disposed(by: bag)
    }
}
