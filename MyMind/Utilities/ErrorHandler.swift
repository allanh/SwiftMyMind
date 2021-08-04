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
            showSignInPage(controller)
        case .serviceError(_), .parseError:
            showServiceErrorPage(controller)
        case .maintenanceError:
            showMaintenanceErrorPage(controller)
        case .networkError:
            showNetworkErrorPage(controller)
        case .insufficientPrivilegeError:
            showInsufficientPrivilegeAlert(controller)
        default:
            break
        }
        return true
    }
}
extension ErrorHandler {
    private func showSignInPage(_ controller: UIViewController?) {
        controller?.navigationController?.popToRootViewController(animated: false)
        let scene = UIApplication.shared.connectedScenes.first
        if let sceneDelegate : SceneDelegate = (scene?.delegate as? SceneDelegate) {
            var otpEnabled: Bool = false
            do {
                otpEnabled = try KeychainHelper.default.readItem(key: .otpStatus, valueType: Bool.self)
            } catch {
                print(error)
            }
            let viewModel = SignInViewModel(
                userSessionRepository: MyMindUserSessionRepository.shared,
                signInValidationService: SignInValidatoinService(),
                lastSignInInfoDataStore: MyMindLastSignInInfoDataStore(),
                otpEnabled: otpEnabled
            )
            let signInViewController = SignInViewController(viewModel: viewModel)
            signInViewController.modalPresentationStyle = .custom
            signInViewController.transitioningDelegate = SignInTransitionDelegate.shared
            sceneDelegate.window?.rootViewController?.present(signInViewController, animated: true, completion: nil)
        }
    }
    private func showHomePage() {
        MyMindEmployeeAPIService.shared.authorization()
            .done { authorization in
                let scene = UIApplication.shared.connectedScenes.first
                if let sceneDelegate : SceneDelegate = (scene?.delegate as? SceneDelegate) {
                    let rootTabBarViewController = RootTabBarController(authorization: authorization)
                    sceneDelegate.window?.rootViewController?.navigationController?.popToViewController(rootTabBarViewController, animated: true)
                }
            }
            .ensure {
            }
            .catch { error in
                if let apiError = error as? APIError {
                    _ = ErrorHandler.shared.handle(apiError)
                }
            }
    }
    
    private func showStaticPage(_ controller: UIViewController, page: StaticView) {
        controller.view.addSubview(page)
    }
    private func showServiceErrorPage(_ controller: UIViewController?) {
        if let controller = controller {
            let page = StaticView(frame: controller.view.bounds, type: .service, title:"哦喔～出了一點小狀況.......\n請稍候再試。" , descriptions: "您可以前往首頁或返回上一頁。", defaultButtonTitle: "回上一頁", alternativeButtonTitle: "前往首頁")
            page.defaultButton.addAction {
                page.removeFromSuperview()
                controller.navigationController?.popViewController(animated: true)
            }
            page.alternativeButton.addAction {
                page.removeFromSuperview()
                controller.navigationController?.popToRootViewController(animated: true)
            }
            showStaticPage(controller, page: page)
        }
    }
    
    private func showMaintenanceErrorPage(_ controller: UIViewController?) {
        if let controller = controller {
            let page = StaticView(frame: controller.view.bounds, type: .maintenance, title:"系統維護中！" , descriptions: "為提供您更好的體驗， 我們正在進行服務更新， 敬請期待！")
            showStaticPage(controller, page: page)
        }

    }
    
    private func showNetworkErrorPage(_ controller: UIViewController?) {
        if let controller = controller {
            let page = StaticView(frame: controller.view.bounds, type: .maintenance, title:"網路異常" , descriptions: "網路連線異常，請確認網路連線狀態。")
            showStaticPage(controller, page: page)
        }
    }
    
    private func showInsufficientPrivilegeAlert(_ controller: UIViewController?) {
        if let controller = controller {
            let contentView: UIView = controller.navigationController?.view ?? controller.view
            let alertView = CustomAlertView(frame: contentView.bounds, title: "權限不足", descriptions: "您在本商店無使用權限，\n請取得權限後再次登入!", needCancel: false)
            alertView.confirmButton.addAction {
                alertView.removeFromSuperview()
            }
            contentView.addSubview(alertView)
        }
    }
}
