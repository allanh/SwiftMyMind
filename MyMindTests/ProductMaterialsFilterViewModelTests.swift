//
//  ProductMaterialsFilterViewModelTests.swift
//  MyMindTests
//
//  Created by Barry Chen on 2021/5/25.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import XCTest
import PromiseKit
import RxSwift

@testable import MyMind

class MockAutoCompleteAPIService: AutoCompleteAPIService {
    func productMaterialBrandNameAutoComplete(searchTerm: String, vendorID: String?) -> Promise<AutoCompleteList> {
        return deffered.promise
    }
    
    func announcementTitleAutoComplete(searchTerm: String) -> Promise<AutoCompleteList> {
        return deffered.promise
    }
    
    func announcementTypeAutoComplete(searchTerm: String) -> Promise<AutoCompleteList> {
        return deffered.promise
    }
    
    let deffered = Promise<AutoCompleteList>.pending()

    func purchaseNumberAutoComplete(searchTerm: String) -> Promise<AutoCompleteList> {
        return deffered.promise
    }

    func vendorNameAutoComplete(searchTerm: String) -> Promise<AutoCompleteList> {
        return deffered.promise
    }

    func applicantAutoComplete(searchTerm: String) -> Promise<AutoCompleteList> {
        return deffered.promise
    }

    func productNumberAutoComplete(searchTerm: String) -> Promise<AutoCompleteList> {
        return deffered.promise
    }

    func productMaterialBrandNameAutoComplete(searchTerm: String, vendorID: String) -> Promise<AutoCompleteList> {
        return deffered.promise
    }

    func productMaterailOriginalNumberAutoComplete(searchTerm: String) -> Promise<AutoCompleteList> {
        return deffered.promise
    }

    func productNumberSetAutoComplete(searchTerm: String) -> Promise<AutoCompleteList> {
        return deffered.promise
    }
}

class ProductMaterialsFilterViewModelTests: XCTestCase {

    var sut: ProductMaterialsFilterViewModel!
    var mockAutoCompleteAPIService: MockAutoCompleteAPIService!
    var updatedQueryInfo: ProductMaterialQueryInfo?

    override func setUpWithError() throws {
        mockAutoCompleteAPIService = MockAutoCompleteAPIService()
        sut = ProductMaterialsFilterViewModel(
            service: mockAutoCompleteAPIService,
            queryInfo: .init(vendorInfo: .init(id: "3", name: "test")),
            didUpdateQueryInfo: { info in
                self.updatedQueryInfo = info
            })
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        updatedQueryInfo = nil
    }

    func test_updateQueryInfo_thenConfirmSearch() {
        sut.brandNameViewModel.pickedItemViewModels.accept([AutoCompleteItemViewModel.init(representTitle: "test", identifier: "test")])
        sut.productNumberViewModel.pickedItemViewModels.accept([AutoCompleteItemViewModel.init(representTitle: "333", identifier: "333")])
        sut.confirmSearch()

        XCTAssertEqual(updatedQueryInfo, ProductMaterialQueryInfo(
                        vendorInfo: .init(id: "3", name: "test"),
                        brandNames: [.init(id: nil, number: nil, name: "test")],
                        materialNumbers: [.init(id: nil, number: "333", name: nil)]))
    }

    func test_updateQueryInfo_thenCleanToDefaultStatus() {
        sut.brandNameViewModel.pickedItemViewModels.accept([AutoCompleteItemViewModel.init(representTitle: "test", identifier: "test")])
        sut.productNumberViewModel.pickedItemViewModels.accept([AutoCompleteItemViewModel.init(representTitle: "333", identifier: "333")])

        sut.cleanToDefaultStatus()
        XCTAssertEqual(ProductMaterialQueryInfo.init(vendorInfo: .init(id: "3", name: "test")), sut.queryInfo)
    }

    func test_brandNameViewModel_searchWithSearchTerm() throws {
        let viewModels = sut.brandNameViewModel.autoCompleteItemViewModels
            .asObservable()
            .skip(1)
            .subscribe(on: MainScheduler.instance)

        sut.brandNameViewModel.searchTerm.accept("test")
        mockAutoCompleteAPIService.deffered.resolver.fulfill(.init(item: [.init(id: nil, number: nil, name: "test")]))

        let result = try viewModels.toBlocking(timeout: 2).first()
        XCTAssertEqual(result, [.init(representTitle: "test", identifier: "test")])
    }

    func test_productNumberViewModel_searchWithSearchTerm() throws {
        let viewModels = sut.productNumberViewModel.autoCompleteItemViewModels
            .asObservable()
            .skip(1)
            .subscribe(on: MainScheduler.instance)

        sut.productNumberViewModel.searchTerm.accept("123")
        mockAutoCompleteAPIService.deffered.resolver.fulfill(.init(item: [.init(id: "123", number: "123", name: "123")]))

        let result = try viewModels.toBlocking(timeout: 2).first()
        XCTAssertEqual(result, [.init(representTitle: "123", identifier: "123")])
    }

    func test_originalNumberViewModel_searchWithSearchTerm() throws {
        let viewModels = sut.originalNumberViewModel.autoCompleteItemViewModels
            .asObservable()
            .skip(1)
            .subscribe(on: MainScheduler.instance)

        sut.productNumberViewModel.searchTerm.accept("123")
        mockAutoCompleteAPIService.deffered.resolver.fulfill(.init(item: [.init(id: nil, number: nil, name: "123")]))

        let result = try viewModels.toBlocking(timeout: 2).first()
        XCTAssertEqual(result, [.init(representTitle: "123", identifier: "123")])
    }

    func test_searchMaterialNamesViewModel_addSearchTerm() {
        sut.searchMaterialNameViewModel.searchTerm.accept("test")
        sut.searchMaterialNameViewModel.addSearchTerm()

        XCTAssertEqual(["test"], sut.searchMaterialNameViewModel.addedSearchTerms.value)
    }
}
