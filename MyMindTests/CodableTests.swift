//
//  CodableTests.swift
//  MyMindTests
//
//  Created by Barry Chen on 2021/3/18.
//

import XCTest
@testable import MyMind

class CachedFileDataHelper {
    func cachedFileData(name: String, ext: String = "json") -> Data? {
        let bundle = Bundle(for: type(of: self))
        guard let path = bundle.path(forResource: name, ofType: ext) else {
            print("File not found.")
            return nil
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else {
            print("Create data error.")
            return nil
        }
        return data
    }
}

class CodableTests: XCTestCase {
    let cachedFileDataHelper = CachedFileDataHelper()
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_decode_capchaSession() {
        guard let data = cachedFileDataHelper.cachedFileData(name: "captcha_session") else {
            XCTFail()
            return
        }

        let captchaSession = try? JSONDecoder().decode(Response<CaptchaSession>.self, from: data).data
        XCTAssertNotNil(captchaSession)
        XCTAssertNotNil(captchaSession?.imageData)
        if let data = captchaSession?.imageData {
            let image = UIImage(data: data)
            XCTAssertNotNil(image)
        }
    }

    func test_decode_userSession() {
        guard let data = cachedFileDataHelper.cachedFileData(name: "user_session") else {
            XCTFail()
            return
        }

        let userSession = try? JSONDecoder().decode(Response<UserSession>.self, from: data).data
        XCTAssertNotNil(userSession)
    }

    func test_decode_purchaseList() {
        guard let data = cachedFileDataHelper.cachedFileData(name: "purchase_list") else {
            XCTFail()
            return
        }
        do {
            let purchaseList = try JSONDecoder().decode(Response<PurchaseList>.self, from: data).data
            XCTAssertNotNil(purchaseList)
        } catch let error {
            print(error)
            XCTFail()
        }
    }

    func test_decode_productMaterialList() {
        guard let data = cachedFileDataHelper.cachedFileData(name: "product_materials") else {
            XCTFail()
            return
        }

        do {
            let productMaterialList = try JSONDecoder().decode(Response<ProductMaterialList>.self, from: data).data
            XCTAssertNotNil(productMaterialList)
        } catch let error {
            print(error)
            XCTFail()
        }
    }

    func test_decode_productMaterialDetail() {
        guard let data = cachedFileDataHelper.cachedFileData(name: "product_material_detail") else {
            XCTFail()
            return
        }

        do {
            let productMaterialDetail = try JSONDecoder().decode(Response<ProductMaterialDetail>.self, from: data).data
            XCTAssertNotNil(productMaterialDetail)
        } catch let error {
            print(error)
            XCTFail()
        }
    }

    func test_decode_purchaseSuggestionInfos() {
        guard let data = cachedFileDataHelper.cachedFileData(name: "purchase_suggestion_list") else {
            XCTFail()
            return
        }

        do {
            let purchaseSuggstionInfoList = try JSONDecoder().decode(Response<PurchaseSuggestionInfoList>.self, from: data).data
            XCTAssertNotNil(purchaseSuggstionInfoList)
            XCTAssert(purchaseSuggstionInfoList?.items.isEmpty == false)
        } catch let error {
            print(error)
            XCTFail()
        }
    }
}
