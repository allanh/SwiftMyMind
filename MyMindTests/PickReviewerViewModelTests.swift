//
//  PickReviewerViewModelTests.swift
//  MyMindTests
//
//  Created by Barry Chen on 2021/6/9.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import XCTest
import PromiseKit
@testable import MyMind

struct MockPurchaseReviewerListService: PurchaseReviewerListService {
    let mockReviewerList: [Reviewer] = [
        Reviewer(id: "136", account: "test1"),
        Reviewer(id: "138", account: "test2")

    ]

    var shouldSuccess: Bool = true

    func fetchPurchaseReviewer() -> Promise<[Reviewer]> {
        return Promise<[Reviewer]>.init { seal in
            if shouldSuccess {
                seal.fulfill(mockReviewerList)
            } else {
                seal.reject(APIError.dataNotFoundError)
            }
        }
    }
}

class PickReviewerViewModelTests: XCTestCase {

    var sut: PickReviewerViewModel!
    var mockService: MockPurchaseReviewerListService!

    override func setUpWithError() throws {
        mockService = MockPurchaseReviewerListService()
        sut = PickReviewerViewModel(service: mockService)

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_didPickReviewer_returnValidResult() {
        sut.pickedReviewer.accept(Reviewer(id: "123", account: "test"))
        XCTAssertEqual(sut.pickedReviewerValidationStatus.value, .valid)
    }

    func test_fetchReviewerList_success() {
        let expectation = expectation(description: "fetch reviewer list finish")
        sut.fetchPurchaseReviewerList()
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockService.mockReviewerList, sut.reviewerList.value)
    }
}
