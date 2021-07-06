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
            showSignInPage()
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
    private func showSignInPage() {
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
    private func showHomePage() {
        MyMindEmployeeAPIService.shared.authorization()
            .done { authorization in
                let scene = UIApplication.shared.connectedScenes.first
                if let sceneDelegate : SceneDelegate = (scene?.delegate as? SceneDelegate) {
                    if let rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Home") as? HomeViewController {
                        rootViewController.authorization = authorization
                        let navigationViewController = UINavigationController(rootViewController: rootViewController)
                        sceneDelegate.window?.rootViewController = navigationViewController
                    } else {
                        let navigationViewController = UINavigationController(rootViewController: UIViewController())
                        sceneDelegate.window?.rootViewController = navigationViewController
                    }
                }
            }
            .ensure {
            }
            .catch { error in
                _ = ErrorHandler.shared.handle((error as! APIError))
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
                self.showHomePage()
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
