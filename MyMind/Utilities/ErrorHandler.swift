//
//  ErrorHandler.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/6.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import UIKit
protocol ErrorHandling {
    func handle(_ error: APIError, controller: UIViewController?) -> Bool
}
class ErrorHandler: ErrorHandling {
    static let shared: ErrorHandler = .init()
    func handle(_ error: APIError, controller: UIViewController? = nil) -> Bool {
        switch error {
        case .noAccessTokenError, .invalidAccessToken:
            showHomePage()
        default:
            break
        }
        return true
    }
}
extension ErrorHandler {
    private func showHomePage(_ controller: UIViewController? = nil) {
        let scene = UIApplication.shared.connectedScenes.first
        if let sceneDelegate : SceneDelegate = (scene?.delegate as? SceneDelegate) {
            let viewModel = SignInViewModel(
                userSessionRepository: MyMindUserSessionRepository.shared,
                signInValidationService: SignInValidatoinService(),
                lastSignInInfoDataStore: MyMindLastSignInInfoDataStore()
            )
            let signInViewController = SignInViewController(viewModel: viewModel)
            sceneDelegate.window?.rootViewController = signInViewController
        }
    }
}
