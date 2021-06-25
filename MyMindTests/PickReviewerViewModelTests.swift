//
//  PickReviewerViewModelTests.swift
//  MyMindTests
//
//  Created by Barry Chen on 2021/6/9.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import XCTest
import PromiseKit
import RxSwift
@testable import MyMind

struct MockPurchaseReviewerListLoader: PurchaseReviewerListLoader {
    let deferred = Promise<[Reviewer]>.pending()

    func loadPurchaseReviewerList(level: Int) -> Promise<[Reviewer]> {
        return deferred.promise
    }
}

class PickReviewerViewModelTests: XCTestCase {

    var sut: PickPurchaseReviewerViewModel!
    var mockLoader: MockPurchaseReviewerListLoader!

    override func setUpWithError() throws {
        mockLoader = MockPurchaseReviewerListLoader()
        sut = PickPurchaseReviewerViewModel(loader: mockLoader)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_didPickReviewer_returnValidResult() {
        sut.pickedReviewer.accept(Reviewer(id: "123", account: "test"))
        XCTAssertEqual(sut.pickedReviewerValidationStatus.value, .valid)
    }

    func test_fetchReviewerList_success() throws {
        let mockReviewerList: [Reviewer] = [
            Reviewer(id: "136", account: "test1"),
            Reviewer(id: "138", account: "test2")
        ]


        let reviewerList = sut.reviewerList
            .asObservable()
            .observe(on: MainScheduler.instance)
            .skip(1)

        sut.loadPurchaseReviewerList()
        mockLoader.deferred.resolver.fulfill(mockReviewerList)

        let result = try reviewerList.toBlocking(timeout: 1).first()
        XCTAssertEqual(mockReviewerList, result)
    }
}
