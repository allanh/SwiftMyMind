//
//  NetworkManager.swift
//  MyMind WidgetsExtension
//
//  Created by Nelson Chan on 2021/10/1.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
/// NetworkManager
class NetworkManager {
    static let shared: NetworkManager = .init()
    let version: String = "v1"
    static let baseURL: String = {
        if let url = Bundle.main.infoDictionary?["ServerURL"] as? String {
            return url
        }
        return ""
    }()
    private var authorizationURL: URL {
        get {
            var components: URLComponents? = URLComponents(string: NetworkManager.baseURL)
            components?.path = "/api/admin/\(version)/authorization"
            guard let url = components?.url else {
                preconditionFailure("Invalid URL components: \(String(describing: components))")
            }
            return url
        }
    }
    private func saleReport(partnerID: String, start: Date, end: Date, type: SaleReport.SaleReportType) -> URL {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let items = [
            URLQueryItem(name: "partner_id", value: partnerID),
            URLQueryItem(name: "channel_receipt_date_from", value: formatter.string(from: start)+" 00:00:00"),
            URLQueryItem(name: "channel_receipt_date_to", value: formatter.string(from: end)+" 23:59:59")
        ]
        var components: URLComponents? = URLComponents(string: NetworkManager.baseURL)
        switch type {
        case .byType:
            components?.path = "/api/admin/\(version)/dashboard/order_sale_by_type"
            components?.queryItems = items
            guard let url = components?.url else {
                preconditionFailure("Invalid URL components: \(String(describing: components))")
            }
            return url
        case .byDate:
            components?.path = "/api/admin/\(version)/dashboard/order_sale_by_date"
            components?.queryItems = items
            guard let url = components?.url else {
                preconditionFailure("Invalid URL components: \(String(describing: components))")
            }
            return url
        }
    }
    private func todo(partnerID: String, navigationNo: String) -> URL {
        let items = [
            URLQueryItem(name: "partner_id", value: partnerID),
            URLQueryItem(name: "navigation_no", value: navigationNo),
        ]
        var components: URLComponents? = URLComponents(string: NetworkManager.baseURL)
        components?.path = "/api/admin/\(version)/dashboard/todo"
        components?.queryItems = items
        guard let url = components?.url else {
            preconditionFailure("Invalid URL components: \(String(describing: components))")
        }
        return url
    }
    private func notifications(number: Int) -> URL {
        var components: URLComponents? = URLComponents(string: NetworkManager.baseURL)
        components?.path = "/api/admin/\(version)/notification"
        components?.queryItems = [URLQueryItem(name: "take", value: String(number))]
        guard let url = components?.url else {
            preconditionFailure("Invalid URL components: \(String(describing: components))")
        }
        return url
    }
    private func readUserSession() -> UserSession? {
        do {
            let userSession = try KeychainHelper.default.readItem(key: .userSession, valueType: UserSession.self)
            return userSession
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    private func request(url: URL,
                 httpMethod: String = "GET",
                 httpHeader: [String: String]? = nil,
                 httpBody: Data? = nil,
                 timeoutInterval: TimeInterval = 15) -> URLRequest {

        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: timeoutInterval)
        request.httpMethod = httpMethod

        request.addValue("application/json", forHTTPHeaderField: "Accept")
        if let body = httpBody {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = body
        }

        if let header = httpHeader {
            for (key, value) in header {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        return request
    }

    func authorization(completion: @escaping (Authorization?, Bool) -> ()) {
        guard let userSession = readUserSession() else {
            completion(nil, false)
            return
        }
        let request = request(url: authorizationURL, httpHeader: ["Authorization": "Bearer \(userSession.token)"])
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                completion(nil, false)
                return
            }

            guard let jsonData = data else {
                completion(nil, false)
                return
            }
            do {
                let response = try JSONDecoder().decode(Response<Authorization>.self, from: jsonData)
                guard let authorization = response.data else {
                    completion(nil, false)
                    return
                }
                completion(authorization, true)
            } catch {
                completion(nil, false)
            }
        }
        task.resume()
    }
    func saleReportList(completion: @escaping (SaleReportList?) -> ()) {
        guard let userSession = readUserSession() else {
            completion(nil)
            return
        }
        let end = Date()
        let request = request(
            url: saleReport(partnerID: "\(userSession.partnerInfo.id)", start: end.thirtyDaysBefore, end: end, type: .byDate),
            httpHeader: ["Authorization": "Bearer \(userSession.token)"]
        )
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                completion(nil)
                return
            }

            guard let jsonData = data else {
                completion(nil)
                return
            }
            do {
                let response = try JSONDecoder().decode(Response<SaleReportList>.self, from: jsonData)
                guard let item = response.data else {
                    completion(nil)
                    return
                }
                completion(item)
            } catch {
                completion(nil)
            }
        }
        task.resume()
    }
    func toDoCount(with navigationNo: String, completion: @escaping  (Int?) -> ()) {
        guard let userSession = readUserSession() else {
            completion(nil)
            return
        }

        let url = todo(partnerID: "\(userSession.partnerInfo.id)", navigationNo: navigationNo)


        let request = request(
            url: url,
            httpHeader: ["Authorization": "Bearer \(userSession.token)"]
        )
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                completion(nil)
                return
            }

            guard let jsonData = data else {
                completion(nil)
                return
            }
            do {
                let response = try JSONDecoder().decode(Response<ToDoList>.self, from: jsonData)
                guard let item = response.data else {
                    completion(nil)
                    return
                }
                completion(item.items.count)
            } catch {
                completion(nil)
            }
        }
        task.resume()
    }
    func announcementCount(completion: @escaping (Int?) -> ()) {
        guard let userSession = readUserSession() else {
            completion(nil)
            return
        }

        let url = notifications(number: 3)

        let request = request(
            url: url,
            httpHeader: ["Authorization": "Bearer \(userSession.token)"]
        )
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                completion(nil)
                return
            }

            guard let jsonData = data else {
                completion(nil)
                return
            }
            do {
                let response = try JSONDecoder().decode(Response<MyMindNotificationList>.self, from: jsonData)
                guard let item = response.data else {
                    completion(nil)
                    return
                }
                completion(item.unreaded)
            } catch {
                completion(nil)
            }
        }
        task.resume()
    }
}
