//
//  APIService.swift
//  MyMind
//
//  Created by Barry Chen on 2021/3/18.
//

import Foundation
import RxSwift
import RxCocoa

protocol RequestCreatable { }

extension RequestCreatable {
    func request(endPoint: Endpoint,
                 httpMethod: String = "GET",
                 httpHeader: [String: String]? = nil,
                 httpBody: Data? = nil,
                 timeoutInterval: TimeInterval = 5) -> URLRequest {
        let url = endPoint.url

        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: timeoutInterval)
        request.httpMethod = httpMethod

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
}

protocol APIService: RequestCreatable { }

extension APIService {
    func sendRequest<T: Decodable>(_ request: URLRequest, completionHandler: @escaping (Result<T, Error>) -> Void) {

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                completionHandler(Result.failure(error!))
                return
            }

            guard let jsonData = data else {
                completionHandler(Result.failure(APIError.dataNotFoundError))
                return
            }

            do {
                let response = try JSONDecoder().decode(Response<T>.self, from: jsonData)
                guard let item = response.data else {
                    completionHandler(Result.failure(APIError.dataNotFoundError))
                    return
                }
                completionHandler(Result.success(item))
            } catch {
                completionHandler(Result.failure(APIError.parseError))
            }
        }
        task.resume()
    }

    func sendRequest(_ request: URLRequest, completionHandler: @escaping (Result<Void, Error>) -> Void) {

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                completionHandler(Result.failure(error!))
                return
            }

            guard let jsonData = data else {
                completionHandler(Result.failure(APIError.dataNotFoundError))
                return
            }

            do {
                let response = try JSONDecoder().decode(Response<Int>.self, from: jsonData)
                guard response.status == .SUCCESS else {
                    completionHandler(Result.failure(APIError.serviceError(response.message ?? "")))
                    return
                }
                completionHandler(Result.success(()))
            } catch {
                completionHandler(Result.failure(APIError.parseError))
            }
        }
        task.resume()
    }

    func dataTask(endPoint: Endpoint,
                  httpMethod: String = "GET",
                  httpHeader: [String: String]? = nil,
                  httpBody: Data? = nil,
                  timeoutInterval: TimeInterval = 5) -> Observable<(response: HTTPURLResponse, data: Data)> {
        let request: URLRequest = self.request(endPoint: endPoint, httpMethod: httpMethod, httpHeader: httpHeader, httpBody: httpBody, timeoutInterval: timeoutInterval)
        return URLSession.shared.rx.response(request: request)
    }
}
