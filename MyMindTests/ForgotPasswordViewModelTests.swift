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
    var mockSignInService: MockAuthService!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockSignInService = MockAuthService()
        sut = ForgotPasswordViewModel(authService: mockSignInService, signInValidationService: SignInValidatoinService())
    }

    override func tearDownWithError() throws {

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
        let successMessage = sut.successMessage.asObservable()

        sut.forgotPasswordInfo = validInfo
        sut.confirmSendEmail()

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
        let errorMessage = sut.errorMessage.asObservable()

        mockSignInService.isSuccess = false
        sut.confirmSendEmail()

        let result = try? errorMessage.toBlocking(timeout: 1).first()
        XCTAssertEqual(result, sut.unexpectedErrorMessage)
    }

    func test_captcha_success() {
        let captchaSessiong = sut.captchaSession.asObservable()
        sut.captcha()

        let result = try? captchaSessiong.toBlocking(timeout: 1).first()
        XCTAssertNotNil(result)
        sut = nil
    }

    func test_captcha_failed() {
        let errorMessage = sut.errorMessage.asObservable()
        mockSignInService.isSuccess = false
        sut.captcha()

        let result = try? errorMessage.toBlocking(timeout: 1).first()

        XCTAssertNotNil(result)
        XCTAssertEqual(sut.unexpectedErrorMessage, result)
    }

}
