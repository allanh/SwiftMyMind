//
//  PickProductMaterailsViewModelTests.swift
//  MyMindTests
//
//  Created by Chen Yi-Wei on 2021/5/20.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import XCTest
import RxSwift
import PromiseKit

@testable import MyMind

class MockPuchaseAPIService: PurchaseAPIService {
    let userSession: UserSession
    var shouldSuccess: Bool = true
    let cachedFileDataHelper = CachedFileDataHelper()
    var cachedMaterialListResult: ProductMaterialList?

    init() {
        userSession = .testUserSession
    }

    func fetchPurchaseList(purchaseListQueryInfo: PurchaseListQueryInfo?) -> Promise<PurchaseList> {
        return Promise<PurchaseList> { seal in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.2) {
                if self.shouldSuccess {
                    guard let data = self.cachedFileDataHelper.cachedFileData(name: "purchase_list"),
                          let purchaseList = try? JSONDecoder().decode(Response<PurchaseList>.self, from: data).data
                    else {
                        seal.reject(APIError.dataNotFoundError)
                        return
                    }
                    seal.fulfill(purchaseList)
                } else {
                    seal.reject(APIError.dataNotFoundError)
                }
            }
        }
    }

    func fetchProductMaterialList(with query: ProductMaterialQueryInfo) -> Promise<ProductMaterialList> {
        return Promise<ProductMaterialList> { seal in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.2) {
                if self.shouldSuccess {
                    guard let data = self.cachedFileDataHelper.cachedFileData(name: "product_materials"),
                          let productMaterialList = try? JSONDecoder().decode(Response<ProductMaterialList>.self, from: data).data
                    else {
                        seal.reject(APIError.dataNotFoundError)
                        return
                    }
                    self.cachedMaterialListResult = productMaterialList
                    seal.fulfill(productMaterialList)
                } else {
                    seal.reject(APIError.dataNotFoundError)
                }
            }
        }
    }
}

class PickProductMaterailsViewModelTests: XCTestCase {

    var sut: PickProductMaterialsViewModel!
    var mockAPIService: MockPuchaseAPIService!
    let cachedFileDataHelper = CachedFileDataHelper()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockAPIService = MockPuchaseAPIService()
        sut = PickProductMaterialsViewModel(purchaseAPIService: mockAPIService)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.

    }

    func test_refreshFetchMaterials_success() throws {
        let currentProductMaterial = sut
            .currentProductMaterials
            .asObservable()
            .observe(on: MainScheduler.instance)
            .skip(1)

        sut.refreshFetchProductMaterials(with: .defaultQuery())

        let result = try currentProductMaterial.toBlocking(timeout: 1).first()

        XCTAssertFalse(try XCTUnwrap(result).isEmpty)
        XCTAssertEqual(mockAPIService.cachedMaterialListResult?.currentPageNumber, sut.currentPageInfo?.currentPageNumber)
    }

    func test_fetchMoreMaterials_success() throws {
        guard let data = self.cachedFileDataHelper.cachedFileData(name: "product_materials"),
              let productMaterialList = try? JSONDecoder().decode(Response<ProductMaterialList>.self, from: data).data
        else {
            XCTFail("data not found")
            return
        }
        sut.currentProductMaterials.accept(productMaterialList.materials)
        sut.currentPageInfo = productMaterialList

        let currentProductMaterial = sut
            .currentProductMaterials
            .asObservable()
            .observe(on: MainScheduler.instance)
            .skip(1)

        let beforePageNumer = try XCTUnwrap(sut.currentQueryInfo.pageNumber)
        sut.fetchMoreProductMaterials(with: &sut.currentQueryInfo)

        let result = try currentProductMaterial.toBlocking(timeout: 1).first()
        XCTAssertEqual(try XCTUnwrap(result), productMaterialList.materials + productMaterialList.materials)
        XCTAssertEqual(sut.currentQueryInfo.pageNumber, beforePageNumer + 1)
    }

    func test_pickMaterials() throws {
        guard let data = self.cachedFileDataHelper.cachedFileData(name: "product_materials"),
              let productMaterialList = try? JSONDecoder().decode(Response<ProductMaterialList>.self, from: data).data
        else {
            XCTFail("data not found")
            return
        }
        sut.currentProductMaterials.accept(productMaterialList.materials)
        sut.selectMaterial(at: 0)
        XCTAssertEqual(sut.pickedMaterials.first, productMaterialList.materials.first)
        XCTAssertTrue(sut.pickedMaterialIDs.contains(try XCTUnwrap(productMaterialList.materials.first?.id)))
        sut.selectMaterial(at: 0)
        XCTAssertEqual(sut.pickedMaterials, [])
        XCTAssertFalse(sut.pickedMaterialIDs.contains(try XCTUnwrap(productMaterialList.materials.first?.id)))
    }
}
