//
//  SceneDelegate.swift
//  MyMind
//
//  Created by Barry Chen on 2021/3/11.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        let contexts = connectionOptions.urlContexts
        if let context = contexts.first {
            Presenter.shared.handle(context.url)
        }

    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let context = URLContexts.first {
            Presenter.shared.handle(context.url)
        }
    }
}
/// Presenter
class Presenter {
    static let shared = Presenter()
    func handle(_ url: URL) {
        let scene = UIApplication.shared.connectedScenes.first
        if let sceneDelegate : SceneDelegate = (scene?.delegate as? SceneDelegate) {
            if url.scheme == "mymindwidget" {
                switch url.host {
                case "otp" :
                    let rootViewController = sceneDelegate.window?.rootViewController
                    if let navigationController = rootViewController as? UINavigationController {
                        navigationController.popToRootViewController(animated: false)
                        if let topViewController = navigationController.topViewController as? MainPageViewController {
                            topViewController.otp()
                        }
                    }
                case "dashboard":
                    let rootViewController = sceneDelegate.window?.rootViewController
                    if let navigationController = rootViewController as? UINavigationController {
                        navigationController.popToRootViewController(animated: false)
                        if let topViewController = navigationController.topViewController as? MainPageViewController {
                            topViewController.section = Section.thirtyDays.rawValue
                            topViewController.myMind()
                        }
                    }
                case "login":
                    let rootViewController = sceneDelegate.window?.rootViewController
                    if let navigationController = rootViewController as? UINavigationController {
                        navigationController.popToRootViewController(animated: false)
                        if let topViewController = navigationController.topViewController as? MainPageViewController {
                            topViewController.myMind()
                        }
                    }
                default:
                    break
                }
            }
        }
    }
}
