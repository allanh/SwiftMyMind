//
//  SuggestionProductMaterialViewModelTests.swift
//  MyMindTests
//
//  Created by Chen Yi-Wei on 2021/6/3.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import XCTest
@testable import MyMind

class SuggestionProductMaterialViewModelTests: XCTestCase {

    var sut: SuggestionProductMaterialViewModel!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = makeSUT()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_inputInvalidPurchaseCostPerItem_returnInvalidResult() {
        sut.purchaseCostPerItemInput.accept("000")
        XCTAssertEqual(sut.purchaseCostPerItem.value, 0)
        XCTAssertEqual(sut.validationStatusForpurchaseCostPerItem.value, .invalid("此欄位必填"))

        sut.purchaseCostPerItemInput.accept("..1")
        XCTAssertEqual(sut.purchaseCostPerItem.value, 0)
        XCTAssertEqual(sut.validationStatusForpurchaseCostPerItem.value, .invalid("此欄位必填"))

        sut.purchaseCostPerItemInput.accept("")
        XCTAssertEqual(sut.purchaseCostPerItem.value, 0)
        XCTAssertEqual(sut.validationStatusForpurchaseCostPerItem.value, .invalid("此欄位必填"))
    }

    func test_inputValidPurchaseCostPerItem_returnValidResult() {
        sut.purchaseCostPerItemInput.accept("012")
        XCTAssertEqual(sut.purchaseCostPerItem.value, 12)
        XCTAssertEqual(sut.validationStatusForpurchaseCostPerItem.value, .valid)

        sut.purchaseCostPerItemInput.accept("2331")
        XCTAssertEqual(sut.purchaseCostPerItem.value, 2331)
        XCTAssertEqual(sut.validationStatusForpurchaseCostPerItem.value, .valid)
    }

    func test_inputInvalidQuantity_returnInvalidResult() {
        sut.purchaseQuantityInput.accept("000")
        XCTAssertEqual(sut.purchaseQuantity.value, 0)
        XCTAssertEqual(sut.validationStatusForPurchaseQuantity.value, .invalid("請輸入大於0的數量"))

        sut.purchaseQuantityInput.accept("1..01")
        XCTAssertEqual(sut.purchaseQuantity.value, 0)
        XCTAssertEqual(sut.validationStatusForPurchaseQuantity.value, .invalid("請輸入大於0的數量"))

        sut.purchaseQuantityInput.accept("")
        XCTAssertEqual(sut.purchaseQuantity.value, 0)
        XCTAssertEqual(sut.validationStatusForPurchaseQuantity.value, .invalid("請輸入大於0的數量"))
    }

    func test_inputValidQuantity_returnValidResult() {
        sut.purchaseQuantityInput.accept("012")

        XCTAssertEqual(sut.purchaseQuantity.value, 12)
        XCTAssertEqual(sut.validationStatusForPurchaseQuantity.value, .valid)

        sut.purchaseQuantityInput.accept("333")
        XCTAssertEqual(sut.purchaseQuantity.value, 333)
        XCTAssertEqual(sut.validationStatusForPurchaseQuantity.value, .valid)
    }

    func test_inputValidQuantity_returnValidTotalBox() {
        sut.purchaseQuantityInput.accept("333")

        let expectedResult = (Float(333/sut.quantityPerBox)*100).rounded() / 100
        XCTAssertEqual(sut.totalBox.value, expectedResult)
    }

    func test_inputValidPurchaseCostPerItemAndValidQuantity_returnCorrespondingPurchaseCost() {
        sut.purchaseCostPerItemInput.accept("1234.1")
        sut.purchaseQuantityInput.accept("123")

        let expectedResult = Float(1234.1 * 123)
        XCTAssertEqual(sut.purchaseCost.value, expectedResult)
    }

    private func makeSUT() -> SuggestionProductMaterialViewModel {
        let sut = SuggestionProductMaterialViewModel(
            imageURL: nil,
            number: "123",
            originalProductNumber: "123",
            name: "test",
            purchaseSuggestionQuantity: "100",
            stockUnitName: "串",
            quantityPerBox: 22,
            purchaseSuggestionInfo: .init(id: "00", number: "test", originalProductNumber: "123", name: "", quantityPerBox: "", channelStockQuantity: "", fineStockQuantity: "", totalStockQuantity: "", monthSaleQuantity: "", suggestedQuantity: "100", daysSalesOfInventory: "", cost: "", movingAverageCost: "", stockUnitName: "", boxStockUnitName: ""),
            purchaseCostPerItem: 200.0)
        return sut
    }
}
