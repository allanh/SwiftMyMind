//
//  SignInViewModelTests.swift
//  MyMindTests
//
//  Created by Barry Chen on 2021/3/26.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import XCTest
import RxBlocking
import RxSwift
@testable import MyMind

final class MockSignInService: SignInService {
    var isSuccess: Bool = true

    func captcha() -> Single<CaptchaSession> {
        return Single<CaptchaSession>.create { single in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5, execute: {
                switch self.isSuccess {
                case true:
                    let session = CaptchaSession(key: "123", imageString: "123")
                    single(.success(session))
                case false:
                    single(.failure(APIError.unexpectedError))
                }

            })
            return Disposables.create()
        }
    }

    func signIn(info: SignInInfo) -> Single<UserSession> {
        return Single<UserSession>.create { single in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5, execute: {
                switch self.isSuccess {
                case true:
                    let session = UserSession(token: "test", customerInfo: .init(id: 1, name: "123"), businessInfo: .init(id: 1, name: "123"), partnerInfo: .init(id: 1, name: "123"), employeeInfo: .init(id: 1, name: "123"))
                    single(.success(session))
                case false:
                    single(.failure(APIError.unexpectedError))
                }

            })
            return Disposables.create()
        }
    }

    func forgotPasswordMail(info: ForgotPasswordInfo) -> Completable {
        return Completable.create { completable in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5, execute: {
                switch self.isSuccess {
                case true: completable(.completed)
                case false: completable(.error(APIError.unexpectedError))
                }
            })
            return Disposables.create()
        }
    }
}

class SignInViewModelTests: XCTestCase {

    var sut: SignInViewModel!
    var mockSignInService: MockSignInService!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockSignInService = MockSignInService()
        sut = SignInViewModel(signInService: mockSignInService, signInValidationService: SignInValidatoinService())
    }

    override func tearDownWithError() throws {
        // Make sure keychain cleared after test
        try sut.keychainHelper.removeItem(key: .lastSignInAccountInfo)
        let info = try? sut.keychainHelper.readItem(key: .lastSignInAccountInfo, valueType: SignInAccountInfo.self)
        XCTAssertNil(info)
        sut = nil
        mockSignInService = nil
    }

    func test_validate_signInInfo() {
        let signInInfo = SignInInfo(
            storeID: "AA0002",
            account: "tommy",
            password: "123456",
            captchaKey: "testkey",
            captchaValue: "33414"
        )
        sut.signInInfo = signInInfo
        let result = sut.validateSignInInfo()
        XCTAssertTrue(result)

        let inValidSignInInfo = SignInInfo(
            storeID: "",
            account: "tommy",
            password: "",
            captchaKey: "testkey",
            captchaValue: "33414"
        )
        sut.signInInfo = inValidSignInInfo
        let invalidResult = sut.validateSignInInfo()
        XCTAssertFalse(invalidResult)
    }

    func test_signIn_success() throws {
        let signInInfo = SignInInfo(
            storeID: "AA0002",
            account: "tommy",
            password: "123456",
            captchaKey: "testkey",
            captchaValue: "33414"
        )
        sut.signInInfo = signInInfo
        sut.signIn()
        let userSession = sut.userSession.asObservable()

        let result = try             userSession.toBlocking(timeout: 1).first()
        let info = try? sut.keychainHelper.readItem(key: .lastSignInAccountInfo, valueType: SignInAccountInfo.self)
        XCTAssertNotNil(info)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.token, "test")
    }

    func test_signIn_failed() throws {
        let signInInfo = SignInInfo(
            storeID: "AA0002",
            account: "tommy",
            password: "123456",
            captchaKey: "testkey",
            captchaValue: "33414"
        )
        sut.signInInfo = signInInfo
        mockSignInService.isSuccess = false
        sut.signIn()
        let errorMessage = sut.errorMessage.asObservable()

        let result = try?            errorMessage.toBlocking(timeout: 1).first()

        XCTAssertNotNil(result)
        XCTAssertEqual(sut.unexpectedErrorMessage, result)
    }

    func test_captcha_success() {
        sut.captcha()
        let captchaSessiong = sut.captchaSession.asObservable()

        do {
            let result = try             captchaSessiong.toBlocking(timeout: 1).first()
            XCTAssertNotNil(result)
        } catch let error {
            let apiError = error as? APIError
            XCTAssertNil(apiError)
        }
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
