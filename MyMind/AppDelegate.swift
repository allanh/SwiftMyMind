//
//  AppDelegate.swift
//  MyMind
//
//  Created by Barry Chen on 2021/3/11.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setUpNavigationBarAppearance()
        FirebaseApp.configure()

        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound, .provisional]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
            print(granted)
        }
        application.registerForRemoteNotifications()
        do {
            _ = try KeychainHelper.default.readItem(key: .uuid, valueType: String.self)
        } catch {
            if let keychainError = error as? KeychainError, keychainError == KeychainError.noValueFound {
                let uuid = UUID().uuidString
                do {
                    try KeychainHelper.default.saveItem(uuid, for: .uuid)
                } catch {}
            } else {
                print("keychain save fail")
            }
        }

        return true
    }

    private func setUpNavigationBarAppearance() {
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().barTintColor = UIColor(hex: "040d34")
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.pingFangTCSemibold(ofSize: 18)
        ]
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("APNs token retrieved: \(deviceTokenString)")
        Messaging.messaging().apnsToken = deviceToken
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("**** didReceive ***")
        let userInfo = response.notification.request.content.userInfo
        let messageID = userInfo["message_id"] as? String

        if let messageID = userInfo["message_id"] as? String {
            Messaging.messaging().token { token, error in
                if let error = error {
                    print("Error fetching remote instance ID for sending open status to server: \(error.localizedDescription)")
                } else if let token = token {
                    MyMindPushAPIService.shared.openMessage(with: token, messageID: messageID)
                        .done { registration in
                            print("success")
                        }
                        .catch { error in
                            print(error.localizedDescription)
                        }

                }
            }
        }
    }
}
extension AppDelegate: MessagingDelegate {
    public func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase did refresh registration token: \(String(describing: fcmToken))")
        // Register to udn push center.
        if let token = fcmToken {
            do {
                try KeychainHelper.default.saveItem(token, for: .token)
                MyMindPushAPIService.shared.registration(with: RegistrationInfo(token: token))
                    .done { registration in
                        print(registration)
                    }
                    .catch { error in
                        print(error.localizedDescription)
                    }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
