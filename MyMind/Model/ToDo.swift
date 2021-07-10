//
//  ToDo.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/9.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
struct ToDo: Codable {
    struct ToDoItem: Codable {
        enum ToDoItemType: String, Codable {
            case TRANSFER, TRANSFER_RETURN, BORROWING, BORROWING_RETURN, PURCHASE_UNUSAL, PURCHASE_REVIEW_REJECT, PURCHASE_APPROVED, PURCHASE_REIVEW, INBOUND_UNUSAL, INBOUND_PENDING, LOW_STOCK, NONE_STOCK, SALE, SALE_RETURN
            var displayName: String {
                get {
                    switch self {
                    case .TRANSFER: return "轉單"
                    case .TRANSFER_RETURN: return "轉單銷退"
                    case .BORROWING: return "借貨"
                    case .BORROWING_RETURN: return "還貨"
                    case .PURCHASE_UNUSAL: return "異常入庫(採購)"
                    case .PURCHASE_REVIEW_REJECT: return "審核退回"
                    case .PURCHASE_APPROVED: return "審核通過"
                    case .PURCHASE_REIVEW: return "待審核"
                    case .INBOUND_UNUSAL: return "異常入庫(倉庫)"
                    case .INBOUND_PENDING: return "待入庫"
                    case .LOW_STOCK: return "低庫存"
                    case .NONE_STOCK: return "無庫存"
                    case .SALE: return "SALE"
                    case .SALE_RETURN: return "SALE_RETURN"
                    }
                }
            }
            //  "TRANSFER:轉單", "TRANSFER_RETURN:轉單銷退", "BORROWING:借貨", "BORROWING_RETURN:還貨", "PURCHASE_UNUSAL:異常入庫(採購)", "PURCHASE_REVIEW_REJECT:審核退回(採購)", "PURCHASE_APPROVED:審核通過(採購)", "PURCHASE_REIVEW:待審核(採購)", "INBOUND_UNUSAL:異常入庫(倉庫)", "INBOUND_PENDING:待入庫(倉庫)", "LOW_STOCK:低庫存", "NONE_STOCK:無庫存"
        }
        private enum CodingKeys: String, CodingKey {
            case type
            case count
        }
        let type: ToDoItemType
        #warning("type may need change")
        let count: String
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            type = try container.decode(ToDoItemType.self, forKey: .type)
            count = try container.decode(String.self, forKey: .count)
        }

    }
    enum ToDoType: String, Codable {
        case RECEIPT, RECEIPT_RETURN, PURCHASE, INBOUND, STOCK
        var imageName: String {
            get {
                switch self {
                case .RECEIPT: return "order"
                case .RECEIPT_RETURN: return "return"
                case .PURCHASE: return "purchase"
                case .INBOUND: return "warehouse"
                case .STOCK: return "storage"
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
        //  "RECEIPT:訂單/借貨","RECEIPT_RETURN:退貨/還貨","PURCHASE:採購管理","INBOUND:倉庫管理","STOCK:庫存管理"
    }
    let type: ToDoType
    let items: [ToDoItem]
    private enum CodingKeys: String, CodingKey {
        case type
        case items = "info"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(ToDoType.self, forKey: .type)
        items = try container.decode([ToDoItem].self, forKey: .items)
    }
}
struct ToDoList: Codable {
    let items: [ToDo]
    private enum CodingKeys: String, CodingKey {
        case items = "detail"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        items = try container.decode([ToDo].self, forKey: .items)
    }
}
