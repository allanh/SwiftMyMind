//
//  AnnouncementFilterViewModel.swift
//  MyMind
//
//  Created by Chijung Chan on 2021/8/20.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import RxSwift

class AnnouncementFilterViewModel {
    let title: String = "篩選條件"
    var queryInfo: AnnouncementListQueryInfo
    let didUpdateQueryInfo:  (AnnouncementListQueryInfo) -> Void
    let service: AutoCompleteAPIService
    
    lazy var announcementTitleViewModel:AutoCompleteSearchViewModel = {
        makeViewModelForTitle()
    }()
    
    let announcementTypeViewModel: PickAnnouncementTypeViewModel = PickAnnouncementTypeViewModel()
    
    let startedAtViewModel: PickDatesViewModel = PickDatesViewModel(title: "發表時間")
    
    let bag: DisposeBag = DisposeBag()
    
    init(service: AutoCompleteAPIService,queryInfo: AnnouncementListQueryInfo, didUpdateQueryInfo: @escaping(AnnouncementListQueryInfo) -> Void) {
        self.service = service
        self.queryInfo = queryInfo
        // self.queryInfo.pageNumber = 1
        self.didUpdateQueryInfo = didUpdateQueryInfo
        
        updateWithCurrentQuery()
        subscribeChildViewModels()
    }
    // MARK: - Method
    private func subscribeChildViewModels() {
        announcementTitleViewModel.pickedItemViewModels
            .subscribe(onNext: { [unowned self] items in
                self.queryInfo.title = items.map({ items in
                    AutoCompleteInfo(id: nil, number: items.identifier, name: nil)
                })
            })
            .disposed(by: bag)
        
        announcementTypeViewModel.pickedType
            .subscribe(onNext: { [unowned self] type in
                self.queryInfo.type = type
            })
            .disposed(by: bag)
        
        startedAtViewModel.startDate
            .subscribe(onNext: { [unowned self] date in
                self.queryInfo.startedAtFrom = date
            }).disposed(by: bag)
        
        startedAtViewModel.endDate
            .subscribe(onNext: {[unowned self] date in
                self.queryInfo.startedAtTo = date
            })
            .disposed(by: bag)
        
    }
    
    private func updateWithCurrentQuery(){
        announcementTypeViewModel.pickedType.accept(queryInfo.type)
        updateCurrentQueryForTitle()
        updateCurrentQueryForStartedAt()
    }
    
    func updateCurrentQueryForTitle(){
        let items = queryInfo.title.map {
            AutoCompleteItemViewModel(representTitle: $0.name ?? "", identifier: $0.id ?? "")}
        announcementTitleViewModel.autoCompleteItemViewModels.accept(items)
    }

    func updateCurrentQueryForStartedAt() {
        startedAtViewModel.startDate.accept(queryInfo.startedAtFrom)
        startedAtViewModel.endDate.accept(queryInfo.startedAtTo)
    }
    
    func cleanQueryInfo(){
        queryInfo = .defaultQuery()
        
        announcementTitleViewModel.cleanPickedItemViewModel()
        announcementTypeViewModel.cleanPickedType()
        startedAtViewModel.cleanPickedDates()
    }
    
}
// MARK: - Child view models factory methods
extension AnnouncementFilterViewModel {
    private func makeViewModelForTitle() -> AutoCompleteSearchViewModel {
        let adapter =
            RxTitleAutoCompletItemViewModelAdapter(service: service)
        let viewModel = AutoCompleteSearchViewModel(title: "公告標題", placeholder: "請輸入", loader: adapter)
        return viewModel
    }
        
}
