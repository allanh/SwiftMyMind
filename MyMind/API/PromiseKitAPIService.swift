//
//  PromiseKitAPIService.swift
//  MyMind
//
//  Created by Barry Chen on 2021/5/5.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import PromiseKit

protocol PromiseKitAPIService: RequestCreatable { }

extension PromiseKitAPIService {
    func sendRequest<T: Decodable>(request: URLRequest) -> Promise<T> {
        return Promise<T> { seal in
            URLSession.shared.dataTask(with: request) { data, urlResponse, error in
                if let httpResponse = urlResponse as? HTTPURLResponse {
                    // 1. auth api 沒有權限的問題, 所以不會回應403, 且回應401都是帳號密碼錯誤的狀況
                    // 2. mymind / dos api, 發生401驗證問題永遠都是token錯誤 or 過期
                    // 但 employee 也是在 auth api，所以仍需錯誤處理
                    if let host = httpResponse.url?.host,
                        let relativePath = httpResponse.url?.relativePath {
                        if !Endpoint.baseAuthURL.contains(host) || relativePath.contains(Endpoint.employeePath) {
                            switch httpResponse.statusCode {
                            case 401:
                                seal.reject(APIError.invalidAccessToken)
                                return
                            case 503:
                                seal.reject(APIError.maintenanceError)
                                return
                            case 403:
                                seal.reject(APIError.insufficientPrivilegeError)
                                return
                            default:
                                break
                            }
                        }
                    }
                }
                if let error = error {
                   seal.reject(error)
                    return
                }

                guard let data = data else {
                    seal.reject(APIError.dataNotFoundError)
                    return
                }
                                
                do {
                    let response = try JSONDecoder().decode(Response<T>.self, from: data)
                    guard let content = response.data else {
                        seal.reject(APIError.serviceError(response.message ?? ""))
                        return
                    }
                    seal.fulfill(content)
                } catch let error {
                    seal.reject(error)
                }
            }.resume()
        }
    }

    func sendRequest(request: URLRequest) -> Promise<Void> {
        return Promise<Void> { seal in
            URLSession.shared.dataTask(with: request) { data, urlResponse, error in
                if let httpResponse = urlResponse as? HTTPURLResponse {
                    if let host = httpResponse.url?.host,
                        let relativePath = httpResponse.url?.relativePath {
                        if !Endpoint.baseAuthURL.contains(host) || relativePath.contains(Endpoint.employeePath) {
                            switch httpResponse.statusCode {
                            case 401:
                                seal.reject(APIError.invalidAccessToken)
                                return
                            case 503:
                                seal.reject(APIError.maintenanceError)
                                return
                            case 403:
                                seal.reject(APIError.insufficientPrivilegeError)
                                return
                            default:
                                break
                            }
                        }
                    }
                }
                if let error = error {
                    seal.reject(error)
                    return
                }

                guard let data = data else {
                    seal.reject(APIError.dataNotFoundError)
                    return
                }

                do {
                    let response = try JSONDecoder().decode(Response<[Int]>.self, from: data)
                    if response.status == .SUCCESS {
                        seal.fulfill(())
                    } else {
                        seal.reject(APIError.serviceError(response.message ?? ""))
                    }
                } catch let error {
                    seal.reject(error)
                }
            }.resume()
        }
    }
    
    func sendRequest(request: URLRequest) -> Promise<Data> {
        return Promise<Data> { seal in
            URLSession.shared.dataTask(with: request) { data, urlResponse, error in
                if let httpResponse = urlResponse as? HTTPURLResponse {
                    if let host = httpResponse.url?.host,
                        let relativePath = httpResponse.url?.relativePath {
                        if !Endpoint.baseAuthURL.contains(host) || relativePath.contains(Endpoint.employeePath) {
                            switch httpResponse.statusCode {
                            case 401:
                                seal.reject(APIError.invalidAccessToken)
                                return
                            case 503:
                                seal.reject(APIError.maintenanceError)
                                return
                            case 403:
                                seal.reject(APIError.insufficientPrivilegeError)
                                return
                            default:
                                break
                            }
                        }
                    }
                }
                if let error = error {
                    seal.reject(error)
                    return
                }

                guard let data = data else {
                    seal.reject(APIError.dataNotFoundError)
                    return
                }

                seal.fulfill(data)
            }.resume()
        }
    }

}
