//
//  UDI3DESCryptor.swift
//  MyMind
//
//  Created by Barry Chen on 2021/6/28.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation

//private let cryptorKey: String = "9Edv7aN6h2ZUpK6V6SmHmugm"//"lyAOvVCxkYvyTzSeEyRwkfzX"

class UDI3DESCryptor {
    let key: String
    static func cryptorKey()-> String {
        if let crypto = Bundle.main.infoDictionary?["CryptoKey"] as? String {
            return crypto
        }
        return ""
    }
    init(key: String = UDI3DESCryptor.cryptorKey()) {
        self.key = key
    }

    func decrypt(value: String) -> String? {
        return tripleDESEncryptOrDecrypt(op: CCOperation(kCCDecrypt), value: value)
    }

    func encrypt(value: String) -> String? {
        return tripleDESEncryptOrDecrypt(op: CCOperation(kCCEncrypt), value: value)
    }

    private func tripleDESEncryptOrDecrypt(op: CCOperation, value: String) -> String? {

        // Key
        let keyData: NSData = self.key.data(using: String.Encoding.utf8, allowLossyConversion: true)! as NSData
        let keyBytes         = UnsafeMutableRawPointer(mutating: keyData.bytes)

        var data: NSData!
        if op == CCOperation(kCCEncrypt) {//加密内容
            data  = value.data(using: String.Encoding.utf8, allowLossyConversion: true)! as NSData
        }
        else {//解密内容
            data =  NSData(base64Encoded: value, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!
        }

        let dataLength    = size_t(data.length)
        let dataBytes     = UnsafeMutableRawPointer(mutating: data.bytes)

        // 返回数据
        let cryptData    = NSMutableData(length: Int(dataLength) + kCCBlockSize3DES)
        let cryptPointer = UnsafeMutableRawPointer(mutating: cryptData?.bytes)
        let cryptLength  = size_t(cryptData!.length)

        //  可选 的初始化向量
//        let viData :NSData = iv.data(using: String.Encoding.utf8, allowLossyConversion: true) as NSData!
//        let viDataBytes    = UnsafeMutableRawPointer(mutating: viData.bytes)

        // 特定的几个参数
        let keyLength              = size_t(kCCKeySize3DES)
        let operation: CCOperation = UInt32(op)
        let algoritm:  CCAlgorithm = UInt32(kCCAlgorithm3DES)
        let options:   CCOptions   = UInt32(kCCOptionPKCS7Padding)|UInt32(kCCOptionECBMode)

        var numBytesCrypted :size_t = 0

        let cryptStatus = CCCrypt(operation, // 加密还是解密
            algoritm, // 算法类型
            options,  // 密码块的设置选项
            keyBytes, // 秘钥的字节
            keyLength, // 秘钥的长度
            nil, // 可选初始化向量的字节
            dataBytes, // 加解密内容的字节
            dataLength, // 加解密内容的长度
            cryptPointer, // output data buffer
            cryptLength,  // output data length available
            &numBytesCrypted) // real output data length



        if UInt32(cryptStatus) == UInt32(kCCSuccess) {

            cryptData!.length = Int(numBytesCrypted)
            if op == CCOperation(kCCEncrypt)  {
                let base64cryptString = cryptData?.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
                return base64cryptString
            }
            else {
                let base64cryptString = String.init(data: cryptData! as Data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                return base64cryptString
            }
        } else {
            print("Error: \(cryptStatus)")
        }
        return nil
    }
}
