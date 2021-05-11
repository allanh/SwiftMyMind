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
        
//        var message = try container.decodeIfPresent(String.self, forKey: .message)
        if let errorContainer = try? container.nestedContainer(keyedBy: ResponseKeys.self, forKey: .error) {
            message = try errorContainer.decodeIfPresent(String.self, forKey: .message)
        } else {
            message = nil
        }
//        self.message = message
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
