//
//  CodableTests.swift
//  MyMindTests
//
//  Created by Barry Chen on 2021/3/18.
//

import XCTest
@testable import MyMind

class CodableTests: XCTestCase {

    private func cachedFileData(name: String, ext: String = "json") -> Data? {
        guard let path = Bundle.main.path(forResource: name, ofType: ext) else {
            print("File not found.")
            return nil
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else {
            print("Create data error.")
            return nil
        }
        return data
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_Decode_CapchaSession() {
        guard let data = cachedFileData(name: "captcha_session") else {
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
}
