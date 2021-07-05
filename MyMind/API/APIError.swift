//
//  APIError.swift
//  MyMind
//
//  Created by Barry Chen on 2021/3/18.
//

import Foundation

enum APIError : Error {
    case serviceError(String)
    case networkError
    case parseError
    case dataNotFoundError
    case emptyJsonError
    case environmentError
    case urlError
    case noAccessTokenError
    case unexpectedError
    case invalidAccessToken
    case reparingError
    case insufficientPrivilegeError
}
extension APIError: Equatable {
    
}
