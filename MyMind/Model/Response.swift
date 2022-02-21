//
//  Response.swift
//  MyMind
//
//  Created by Barry Chen on 2021/3/17.
//

import Foundation

enum Status: String, Codable {
    case SUCCESS, FAILURE
}

struct Response<T: Decodable> {
    enum ResponseKeys: String, CodingKey {
        case status, id, message, data, error
    }
    let status: Status
    let id: String
    let message: String?
    let data: T?
}

extension Response: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ResponseKeys.self)
        status = try container.decode(Status.self, forKey: .status)
        id = try container.decode(String.self, forKey: .id)
        data = try container.decodeIfPresent(T.self, forKey: .data)
        
        // 若 message array 有值，顯示 message 內所有訊息
        // 若 message array 為空值，就顯示 error.message
        if let messages = try? container.decodeIfPresent([String].self, forKey: .message), !messages.isEmpty {
            message = messages.joined(separator: ", ")
        } else {
            if let errorContainer = try? container.nestedContainer(keyedBy: ResponseKeys.self, forKey: .error) {
                message = try errorContainer.decodeIfPresent(String.self, forKey: .message)
            } else {
                message = nil
            }
        }
    }
}
extension Response: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: ResponseKeys.self)
        try container.encode(status, forKey: .status)
        try container.encode(id, forKey: .id)
        try? container.encode(message, forKey: .message)
    }
}
