//
//  ForgotPasswordViewModelTests.swift
//  MyMindTests
//
//  Created by Barry Chen on 2021/3/29.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import XCTest
import RxBlocking
import RxSwift
@testable import MyMind

class ForgotPasswordViewModelTests: XCTestCase {

    var sut: ForgotPasswordViewModel!
    var mockSignInService: MockSignInService!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockSignInService = MockSignInService()
        sut = ForgotPasswordViewModel(signInService: mockSignInService, signInValidationService: SignInValidatoinService())
    }

    override func tearDownWithError() throws {
        // Make sure keychain cleared after test
        sut = nil
        mockSignInService = nil
    }

    func test_validate_input_info() {
        let validInfo = ForgotPasswordInfo(
            storeID: "AA0002",
            account: "tommy",
            email: "test@gmail.com",
            captchaKey: "test",
            captchaValue: "23412")
        sut.forgotPasswordInfo = validInfo
        var result = sut.validateInputInfo()
        XCTAssertTrue(result)

        let inValidInfo = ForgotPasswordInfo(
            storeID: "123",
            account: "mmy",
            email: "te@st@gmail.com",
            captchaKey: "test",
            captchaValue: "12")

        sut.forgotPasswordInfo = inValidInfo
        result = sut.validateInputInfo()
        XCTAssertFalse(result)
    }

    func test_send_confirm_email_success() {
        let validInfo = ForgotPasswordInfo(
            storeID: "AA0002",
            account: "tommy",
            email: "test@gmail.com",
            captchaKey: "test",
            captchaValue: "23412")
        sut.forgotPasswordInfo = validInfo
        sut.confirmSendEmail()

        let successMessage = sut.successMessage.asObservable()
        let result = try? successMessage.toBlocking(timeout: 1).first()
        XCTAssertEqual(result, "重設密碼連結已寄出！")
    }

    func test_send_confirm_email_failed() {
        let validInfo = ForgotPasswordInfo(
            storeID: "AA0002",
            account: "tommy",
            email: "test@gmail.com",
            captchaKey: "test",
            captchaValue: "23412")
        sut.forgotPasswordInfo = validInfo
        mockSignInService.isSuccess = false
        sut.confirmSendEmail()

        let errorMessage = sut.errorMessage.asObservable()
        let result = try? errorMessage.toBlocking(timeout: 1).first()
        XCTAssertEqual(result, sut.unexpectedErrorMessage)
    }

    func test_captcha_success() {
        sut.captcha()
        let captchaSessiong = sut.captchaSession.asObservable()

        let result = try?             captchaSessiong.toBlocking(timeout: 1).first()
        XCTAssertNotNil(result)
    }

    func test_captcha_failed() {
        mockSignInService.isSuccess = false
        sut.captcha()
        let errorMessage = sut.errorMessage.asObservable()

        let result = try?            errorMessage.toBlocking(timeout: 1).first()

        XCTAssertNotNil(result)
        XCTAssertEqual(sut.unexpectedErrorMessage, result)
    }

}
