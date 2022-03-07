//
//  ToDo.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/9.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//
import UIKit
// MARK: -- ToDo --
struct ToDo: Codable {
    struct ToDoItem: Codable {
        enum ToDoItemType: String, Codable {
            case TRANSFER, TRANSFER_RETURN, BORROWING, BORROWING_RETURN, PURCHASE_UNUSUAL, PURCHASE_REVIEW_REJECT, PURCHASE_APPROVED, PURCHASE_REVIEW, INBOUND_UNUSUAL, INBOUND_PENDING, LOW_STOCK, NONE_STOCK, UNDERSTOCK
            var displayName: String {
                get {
                    switch self {
                    case .TRANSFER: return "轉單"
                    case .TRANSFER_RETURN: return "轉單銷退"
                    case .BORROWING: return "借貨"
                    case .BORROWING_RETURN: return "還貨"
                    case .PURCHASE_UNUSUAL: return "異常入庫(採購)"
                    case .PURCHASE_REVIEW_REJECT: return "審核退回"
                    case .PURCHASE_APPROVED: return "審核通過"
                    case .PURCHASE_REVIEW: return "待審核"
                    case .INBOUND_UNUSUAL: return "異常入庫(倉庫)"
                    case .INBOUND_PENDING: return "待入庫"
                    case .LOW_STOCK: return "低庫存"
                    case .NONE_STOCK: return "無庫存"
                    case .UNDERSTOCK: return "庫存不足"
                    }
                }
            }
        }
        
        private enum CodingKeys: String, CodingKey {
            case type
            case count
        }
        
        let type: ToDoItemType
        let count: Int
    }
    
    enum ToDoType: String, Codable {
        case RECEIPT, RECEIPT_RETURN, PURCHASE, INBOUND, STOCK
        
        var imageName: String {
            get {
                switch self {
                case .RECEIPT: return "receipt_bg"
                case .RECEIPT_RETURN: return "receipt_return_bg"
                case .PURCHASE: return "purchase_bg"
                case .INBOUND: return "inbound_bg"
                case .STOCK: return "stock_bg"
                }
            }
        }
        
        var popupImageName: String {
            get {
                switch self {
                case .RECEIPT: return "receipt_popup_bg"
                case .RECEIPT_RETURN: return "receipt_return_popup_bg"
                case .PURCHASE: return "purchase_popup_bg"
                case .INBOUND: return "inbound_popup_bg"
                case .STOCK: return "stock_popup_bg"
                }
            }
        }
        
        var gradients: [CGColor] {
            get {
                switch self {
                case .RECEIPT: return [UIColor(hex: "3dcc94").cgColor, UIColor(hex: "11a97b").cgColor]
                case .RECEIPT_RETURN: return [UIColor(hex: "ffd13c").cgColor, UIColor(hex: "ffb31e").cgColor]
                case .PURCHASE: return [UIColor(hex: "977df0").cgColor, UIColor(hex: "7461f0").cgColor]
                case .INBOUND: return [UIColor(hex: "ff6161").cgColor, UIColor(hex: "ef1d62").cgColor]
                case .STOCK: return [UIColor(hex: "82d453").withAlphaComponent(0).cgColor, UIColor(hex: "22a829").cgColor]
                }
            }
        }
        
        var displayName: String {
            get {
                switch self {
                case .RECEIPT: return "訂單/借貨"
                case .RECEIPT_RETURN: return "退貨/還貨"
                case .PURCHASE: return "採購管理"
                case .INBOUND: return "倉庫管理"
                case .STOCK: return "庫存管理"
                }
            }
        }
    }
    
    let type: ToDoType
    let items: [ToDoItem]
    
    private enum CodingKeys: String, CodingKey {
        case type
        case items = "info"
    }
}

// MARK: -- ToDoList --
struct ToDoList: Codable {
    let items: [ToDo]
    let total: Int
    
    private enum CodingKeys: String, CodingKey {
        case items = "detail"
        case total
    }

    static let emptyItems: [ToDo] = [ToDo(type: .RECEIPT, items: [ToDo.ToDoItem(type: .TRANSFER, count: 0), ToDo.ToDoItem(type: .BORROWING, count: 0)]), ToDo(type: .RECEIPT_RETURN, items: [ToDo.ToDoItem(type: .TRANSFER_RETURN, count: 0), ToDo.ToDoItem(type: .BORROWING_RETURN, count: 0)]), ToDo(type: .PURCHASE, items: [ToDo.ToDoItem(type: .PURCHASE_UNUSUAL, count: 0), ToDo.ToDoItem(type: .PURCHASE_REVIEW_REJECT, count: 0), ToDo.ToDoItem(type: .PURCHASE_APPROVED, count: 0), ToDo.ToDoItem(type: .PURCHASE_REVIEW, count: 0)]), ToDo(type: .INBOUND, items: [ToDo.ToDoItem(type: .INBOUND_UNUSUAL, count: 0), ToDo.ToDoItem(type: .INBOUND_PENDING, count: 0)]), ToDo(type: .STOCK, items: [ToDo.ToDoItem(type: .LOW_STOCK, count: 0), ToDo.ToDoItem(type: .NONE_STOCK, count: 0), ToDo.ToDoItem(type: .UNDERSTOCK, count: 0)])]
}
