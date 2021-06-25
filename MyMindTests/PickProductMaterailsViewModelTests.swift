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

class MockProductMaterialListLoader: ProductMaterialListLoader {
    var promise: Promise<ProductMaterialList>?
    let deferred = Promise<ProductMaterialList>.pending()

    func loadProductMaterialList(with query: ProductMaterialQueryInfo) -> Promise<ProductMaterialList> {
        return deferred.promise
    }
}

class PickProductMaterailsViewModelTests: XCTestCase {

    var sut: PickProductMaterialsViewModel!
    var mockLoader: MockProductMaterialListLoader!
    let cachedFileDataHelper = CachedFileDataHelper()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockLoader = MockProductMaterialListLoader()
        sut = PickProductMaterialsViewModel(vendorInfo: .init(id: "", name: ""), loader: mockLoader)
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


        sut.refreshFetchProductMaterials(with: .init(vendorInfo: .init(id: "", name: "")))
        mockLoader.deferred.resolver.fulfill(try makeMockProductMaterialList())

        let result = try currentProductMaterial.toBlocking(timeout: 1).first()

        XCTAssertFalse(try XCTUnwrap(result).isEmpty)
        XCTAssertEqual(try makeMockProductMaterialList().currentPageNumber, sut.currentPageInfo?.currentPageNumber)
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
        mockLoader.deferred.resolver.fulfill(try makeMockProductMaterialList())

        let result = try currentProductMaterial.toBlocking(timeout: 1).first()
        XCTAssertEqual(try XCTUnwrap(result), productMaterialList.materials + productMaterialList.materials)
        XCTAssertEqual(sut.currentQueryInfo.pageNumber, beforePageNumer + 1)
    }

    func test_pickMaterials() throws {
        let productMaterialList = try makeMockProductMaterialList()
        sut.currentProductMaterials.accept(productMaterialList.materials)
        sut.selectMaterial(at: 0)
        XCTAssertEqual(sut.pickedMaterials.first, productMaterialList.materials.first)
        XCTAssertTrue(sut.pickedMaterialIDs.contains(try XCTUnwrap(productMaterialList.materials.first?.id)))
        sut.selectMaterial(at: 0)
        XCTAssertEqual(sut.pickedMaterials, [])
        XCTAssertFalse(sut.pickedMaterialIDs.contains(try XCTUnwrap(productMaterialList.materials.first?.id)))
    }

    private func makeMockProductMaterialList(file: StaticString = #filePath, line: UInt = #line) throws -> ProductMaterialList {
        guard let data = self.cachedFileDataHelper.cachedFileData(name: "product_materials"),
              let productMaterialList = try? JSONDecoder().decode(Response<ProductMaterialList>.self, from: data).data
        else {
            throw APIError.dataNotFoundError
        }

        return productMaterialList
    }
}
