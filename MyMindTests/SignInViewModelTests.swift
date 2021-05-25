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
import PromiseKit
@testable import MyMind

final class MockAuthService: AuthService {
    var isSuccess: Bool = true

    func captcha() -> Promise<CaptchaSession> {
        return Promise<CaptchaSession> { seal in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5, execute: {
                switch self.isSuccess {
                case true:
                    let session = CaptchaSession(key: "123", imageString: "123")
                    seal.fulfill(session)
                case false:
                    seal.reject(APIError.unexpectedError)
                }
            })
        }
    }

    func signIn(info: SignInInfo) -> Promise<UserSession> {
        return Promise<UserSession> { seal in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5, execute: {
                switch self.isSuccess {
                case true:
                    let session = UserSession(token: "test", customerInfo: .init(id: 1, name: "123"), businessInfo: .init(id: 1, name: "123"), partnerInfo: .init(id: 1, name: "123"), employeeInfo: .init(id: 1, name: "123"))
                    seal.fulfill(session)
                case false:
                    seal.reject(APIError.unexpectedError)
                }

            })
        }
    }

    func forgotPasswordMail(info: ForgotPasswordInfo) -> Promise<Void> {
        return Promise<Void> { seal in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5, execute: {
                switch self.isSuccess {
                case true: seal.fulfill(())
                case false: seal.reject(APIError.unexpectedError)
                }
            })
        }
    }
}

class MockUserSessionDataStore: UserSessionDataStore {
    var userSession: UserSession?

    func readUserSession() -> UserSession? {
        userSession
    }

    func saveUserSession(userSession: UserSession) -> Promise<UserSession> {
        self.userSession = userSession
        return .value(userSession)
    }

    func deleteUserSession() -> Promise<Void> {
        userSession = nil
        return .value
    }

}

class MockLastSignInInfoDataStore: LastSignInInfoDataStore {
    var shouldRememberFlag: Bool = true
    var lastSignInAccountInfo: SignInAccountInfo? = .init(storeID: "1", account: "123")

    func readShouldRememberLastSignAccountFlag() -> Promise<Bool> {
        .value(shouldRememberFlag)
    }

    func saveShouldRememberLastSignAccountFlag(_ flag: Bool) -> Promise<Bool> {
        shouldRememberFlag = flag
        return .value(shouldRememberFlag)
    }

    func readLastSignInAccountInfo() -> Promise<SignInAccountInfo> {
        guard let info = lastSignInAccountInfo else { return .init(error: APIError.unexpectedError) }
        return .value(info)
    }

    func saveLastSignInAccountInfo(info: SignInAccountInfo) -> Promise<SignInAccountInfo> {
        lastSignInAccountInfo = info
        return .value(lastSignInAccountInfo!)
    }

    func removeLastSignInAccountInfo() -> Promise<Void> {
        lastSignInAccountInfo = nil
        return .value
    }
}


class SignInViewModelTests: XCTestCase {

    var sut: SignInViewModel!
    var mockAuthService: MockAuthService!
    var mockUserSessionDataStore: MockUserSessionDataStore!
    var mockUserSessionRepository: MyMindUserSessionRepository!
    var mockLastSignInInfoDataStore: MockLastSignInInfoDataStore!

    func makeSUTComponents() -> (SignInViewModel, MockAuthService, MockUserSessionDataStore, MyMindUserSessionRepository, MockLastSignInInfoDataStore) {
        let mockAuthService = MockAuthService()
        let mockUserSessionDataStore = MockUserSessionDataStore()
        let mockUserSessionRepository = MyMindUserSessionRepository(dataStore: mockUserSessionDataStore, authService: mockAuthService)
        let mockLastSignInInfoDataStore = MockLastSignInInfoDataStore()
        let viewModel = SignInViewModel(userSessionRepository: mockUserSessionRepository, signInValidationService: SignInValidatoinService(), lastSignInInfoDataStore: mockLastSignInInfoDataStore)
        return (viewModel, mockAuthService, mockUserSessionDataStore, mockUserSessionRepository, mockLastSignInInfoDataStore)
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let components = makeSUTComponents()
        sut = components.0
        mockAuthService = components.1
        mockUserSessionDataStore = components.2
        mockUserSessionRepository = components.3
        mockLastSignInInfoDataStore = components.4
    }

    override func tearDownWithError() throws {
        // Make sure keychain cleared after test
        try sut.keychainHelper.removeItem(key: .lastSignInAccountInfo)
        let info = try? sut.keychainHelper.readItem(key: .lastSignInAccountInfo, valueType: SignInAccountInfo.self)
        XCTAssertNil(info)
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
        var signInAccountInfo: SignInAccountInfo?
        sut.signInInfo = signInInfo

        let userSession = sut.userSession.asObservable().observe(on: MainScheduler.instance)
        sut.signIn()
        
        sut.lastSignInInfoDataStore.readLastSignInAccountInfo()
            .done { info in
                signInAccountInfo = info
            }
            .cauterize()
        let result = try userSession.toBlocking(timeout: 1).first()

        XCTAssertNotNil(signInAccountInfo)
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
        let errorMessage = sut.errorMessage.asObservable().observe(on: MainScheduler.instance)
        mockAuthService.isSuccess = false
        sut.signIn()

        let result = try? errorMessage.toBlocking(timeout: 1).first()

        XCTAssertNotNil(result)
        XCTAssertEqual(sut.unexpectedErrorMessage, result)
    }

    func test_captcha_success() {
        let captchaSessiong = sut.captchaSession.asObservable().observe(on: MainScheduler.instance)
        sut.captcha()

        let result = try? captchaSessiong.toBlocking(timeout: 1).first()
        XCTAssertNotNil(result)
    }

    func test_captcha_failed() {
        let errorMessage = sut.errorMessage.asObservable().observe(on: MainScheduler.instance)
        mockAuthService.isSuccess = false
        sut.captcha()

        let result = try? errorMessage.toBlocking(timeout: 1).first()

        XCTAssertNotNil(result)
        XCTAssertEqual(sut.unexpectedErrorMessage, result)
    }
}
