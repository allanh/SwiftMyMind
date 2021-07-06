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
                if let error = error {
                    seal.reject(error)
                    return
                }

                guard let data = data else {
                    seal.reject(APIError.dataNotFoundError)
                    return
                }

                do {
                    let response = try JSONDecoder().decode(Response<Int>.self, from: data)
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
}
