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
    func handle(_ error: APIError, forceAction: Bool) -> Bool
}
class ErrorHandler: ErrorHandling {
    static let shared: ErrorHandler = .init()
    var topMostViewController: UIViewController? {
        get {
            let scene = UIApplication.shared.connectedScenes.first
            if let sceneDelegate : SceneDelegate = (scene?.delegate as? SceneDelegate) {
                return sceneDelegate.window?.topMostViewController
            }
            return nil
        }
    }
    func handle(_ error: APIError, forceAction: Bool = false) -> Bool {
        switch error {
        case .noAccessTokenError, .invalidAccessToken:
            showSignInPage()
        case .serviceError(_), .parseError:
            showServiceErrorPage()
        case .maintenanceError:
            showMaintenanceErrorPage(forceAction)
        case .networkError:
            showNetworkErrorPage(forceAction)
        case .insufficientPrivilegeError:
            showInsufficientPrivilegeAlert()
        default:
            break
        }
        return true
    }
}
extension ErrorHandler {
    private func showSignInPage() {
        if let topMostViewController = topMostViewController {
            topMostViewController.navigationController?.popToRootViewController(animated: true)
        }
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
        topMostViewController?.navigationController?.popToRootViewController(animated: false)
        topMostViewController?.show(signInViewController, sender: self)
    }
    
    private func showStaticPage(_ controller: UIViewController, page: StaticView) {
        controller.view.addSubview(page)
    }
    private func showServiceErrorPage() {
            if let topMostViewController = topMostViewController {
                let page = StaticView(frame: topMostViewController.view.bounds, type: .service, title:"哦喔～出了一點小狀況.......\n請稍候再試。" , descriptions: "您可以前往首頁或返回上一頁。", defaultButtonTitle: "回上一頁", alternativeButtonTitle: "前往首頁")
                page.defaultButton.addAction {
                    page.removeFromSuperview()
                    topMostViewController.navigationController?.popViewController(animated: true)
                }
                page.alternativeButton.addAction {
                    page.removeFromSuperview()
                    topMostViewController.navigationController?.popToRootViewController(animated: true)
                }
                showStaticPage(topMostViewController, page: page)
            }
    }
    
    private func showMaintenanceErrorPage(_ forceAction: Bool) {
        if let topMostViewController = topMostViewController {
            let page = StaticView(frame: topMostViewController.view.bounds, type: .maintenance, title:"系統維護中！" , descriptions: "為提供您更好的體驗， 我們正在進行服務更新， 敬請期待！", defaultButtonTitle: (forceAction) ? "關閉" : nil)
            if (forceAction) {
                page.defaultButton.addAction {
                    page.removeFromSuperview()
                }
            }
            showStaticPage(topMostViewController, page: page)
        }

    }
    
    private func showNetworkErrorPage(_ forceAction: Bool) {
        if let topMostViewController = topMostViewController {
            let page = StaticView(frame: topMostViewController.view.bounds, type: .maintenance, title:"網路異常" , descriptions: "網路連線異常，請確認網路連線狀態。", defaultButtonTitle: (forceAction) ? "關閉" : nil)
            if (forceAction) {
                page.defaultButton.addAction {
                    page.removeFromSuperview()
                }
            }
            showStaticPage(topMostViewController, page: page)
        }
    }
    
    private func showInsufficientPrivilegeAlert() {
        if let topMostViewController = topMostViewController {
            let contentView: UIView = topMostViewController.navigationController?.view ?? topMostViewController.view
            let alertView = CustomAlertView(frame: contentView.bounds, title: "權限不足", descriptions: "您在本商店無使用權限，\n請取得權限後再次登入!", needCancel: false)
            alertView.confirmButton.addAction {
                alertView.removeFromSuperview()
            }
            contentView.addSubview(alertView)
        }
    }
}
