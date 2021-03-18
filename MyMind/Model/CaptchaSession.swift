//
//  CaptchaSession.swift
//  MyMind
//
//  Created by Barry Chen on 2021/3/18.
//

import Foundation

struct CaptchaSession: Codable {
    private enum CodingKeys: String, CodingKey {
        case key
        case imageString = "img"
    }
    let key: String
    let imageString: String

    var imageData: Data? {
        get {
            guard
                let indexToDrop = imageString.firstIndex(of: ",")
            else { return nil }
            let count: Int = imageString.distance(from: imageString.startIndex, to: indexToDrop) + 1
            let string = String(imageString.dropFirst(count))
            let data = Data.init(base64Encoded: string)
            return data
        }
    }
}
