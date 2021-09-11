//
//  MyMindPushAPIService.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/8/17.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import RxSwift
import PromiseKit

class MyMindPushAPIService: PromiseKitAPIService {
    static func pushAppKey()-> String {
        if let key = Bundle.main.infoDictionary?["PushAppKey"] as? String {
            return key
        }
        return ""
    }

    static let shared: MyMindPushAPIService = MyMindPushAPIService()

    func registration(with info: RegistrationInfo) -> Promise<Registration> {
        guard let body = try? JSONEncoder().encode(info) else {
            return .init(error: APIError.parseError)
        }

        let request = request(endPoint: .registration, httpMethod: "PUT", httpHeader: ["APPKEY": MyMindPushAPIService.pushAppKey()], httpBody: body)
        return sendRequest(request: request)
    }
    
    func openMessage(with token: String, messageID: String) -> Promise<Void> {
        let json: [String: Any] = [
            "device_token": token,
            "is_open": true
        ]
        
        let body = try? JSONSerialization.data(withJSONObject: json)
        let request = request(endPoint: .openMessage(messageID: messageID), httpMethod: "PUT", httpHeader: ["APPKEY": MyMindPushAPIService.pushAppKey()], httpBody: body)
        return sendRequest(request: request)
    }
}
