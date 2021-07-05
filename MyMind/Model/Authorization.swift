//
//  Authorization.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/5.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
protocol Permit: OptionSet, CustomStringConvertible where RawValue: FixedWidthInteger {
    var navigation: String {get}
}
extension Permit {
    var navigation: String {
        get {
            var value: [String] = []
            for element in self.elements() {
                value.append(element.description)
            }
            return value.joined(separator: ",")
        }
    }
}

struct Authorization: Decodable {
    struct Navigations: Decodable, CustomStringConvertible {
        struct Product: Permit {
            let rawValue: Int
            
            static let invalid = Product(rawValue: 1 >> 1)
            static let proman = Product(rawValue: 1 << 0)
            static let procom = Product(rawValue: 1 << 1)
            static let prosale = Product(rawValue: 1 << 2)
            
            static let all: Product = [.proman, .procom, .prosale]
            init(rawValue: Int) {
                self.rawValue = rawValue
            }
            init(string: String?) {
                if let string = string {
                    switch string {
                    case Product.proman.description:
                        self = .proman
                    case Product.procom.description:
                        self = .procom
                    case Product.prosale.description:
                        self = .prosale
                    default:
                        self = .invalid
                    }
                } else {
                    self = .invalid
                }
            }
            var description: String {
                get {
                    switch self {
                    case .procom:
                        return "procom"
                    case .proman:
                        return "proman"
                    case .prosale:
                        return "prosale"
                    default:
                        return ""
                    }
                }
            }
        }
        struct Channel: Permit {
            let rawValue: Int
            
            static let invalid = Channel(rawValue: 1 >> 1)
            static let chacha = Channel(rawValue: 1 << 0)
            static let chaman = Channel(rawValue: 1 << 1)
            static let chamal = Channel(rawValue: 1 << 2)
            static let chasho = Channel(rawValue: 1 << 3)
            static let chaauc = Channel(rawValue: 1 << 4)
            static let chapla = Channel(rawValue: 1 << 5)
            static let chagro = Channel(rawValue: 1 << 6)

            static let all: Channel = [.chacha, .chaman, .chamal, .chasho, .chaauc, .chapla, .chagro]
            init(rawValue: Int) {
                self.rawValue = rawValue
            }
            init(string: String?) {
                if let string = string {
                    switch string {
                    case Channel.chacha.description:
                        self = .chacha
                    case Channel.chaman.description:
                        self = .chaman
                    case Channel.chamal.description:
                        self = .chamal
                    case Channel.chasho.description:
                        self = .chasho
                    case Channel.chaauc.description:
                        self = .chaauc
                    case Channel.chapla.description:
                        self = .chapla
                    case Channel.chagro.description:
                        self = .chagro
                    default:
                        self = .invalid
                    }
                } else {
                    self = .invalid
                }
            }
            var description: String {
                get {
                    switch self {
                    case .chacha:
                        return "chacha"
                    case .chaman:
                        return "chaman"
                    case .chamal:
                        return "chamal"
                    case .chasho:
                        return "chasho"
                    case .chaauc:
                        return "chaauc"
                    case .chapla:
                        return "chapla"
                    case .chagro:
                        return "chagro"
                    default:
                        return ""
                    }
                }
            }
        }
        struct Storage: Permit {
            let rawValue: Int
            
            static let invalid = Storage(rawValue: 1 >> 1)
            static let stosel = Storage(rawValue: 1 << 0)
            static let stosea = Storage(rawValue: 1 << 1)
            static let stoimp = Storage(rawValue: 1 << 2)
            static let stoexp = Storage(rawValue: 1 << 3)
            static let stomov = Storage(rawValue: 1 << 4)
            static let stopro = Storage(rawValue: 1 << 5)
            static let stoage = Storage(rawValue: 1 << 6)
            static let stoinb = Storage(rawValue: 1 << 7)
            static let stoout = Storage(rawValue: 1 << 8)
            static let stoinv = Storage(rawValue: 1 << 9)

            static let all: Storage = [.stosel, .stosea, .stoimp, .stoexp, .stomov, .stopro, .stoage, .stoinb, .stoout, .stoinv]
            init(rawValue: Int) {
                self.rawValue = rawValue
            }
            init(string: String?) {
                if let string = string {
                    switch string {
                    case Storage.stosel.description:
                        self = .stosel
                    case Storage.stosea.description:
                        self = .stosea
                    case Storage.stoimp.description:
                        self = .stoimp
                    case Storage.stoexp.description:
                        self = .stoexp
                    case Storage.stomov.description:
                        self = .stomov
                    case Storage.stopro.description:
                        self = .stopro
                    case Storage.stoage.description:
                        self = .stoage
                    case Storage.stoinb.description:
                        self = .stoinb
                    case Storage.stoout.description:
                        self = .stoout
                    case Storage.stoinv.description:
                        self = .stoinv
                    default:
                        self = .invalid
                    }
                } else {
                    self = .invalid
                }
            }
            var description: String {
                get {
                    switch self {
                    case .stosel:
                        return "stosel"
                    case .stosea:
                        return "stosea"
                    case .stoimp:
                        return "stoimp"
                    case .stoexp:
                        return "stoexp"
                    case .stomov:
                        return "stomov"
                    case .stopro:
                        return "stopro"
                    case .stoage:
                        return "stoage"
                    case .stoinb:
                        return "stoinb"
                    case .stoout:
                        return "stoout"
                    case .stoinv:
                        return "stoinv"
                    default:
                        return ""
                    }
                }
            }
        }
        struct Order: Permit {
            let rawValue: Int
            
            static let invalid = Order(rawValue: 1 >> 1)
            static let recsal = Order(rawValue: 1 << 0)
            static let recret = Order(rawValue: 1 << 1)
            static let reclen = Order(rawValue: 1 << 2)
            static let recler = Order(rawValue: 1 << 3)
            static let recrep = Order(rawValue: 1 << 4)
            static let recexc = Order(rawValue: 1 << 5)
            static let recshp = Order(rawValue: 1 << 6)
            static let recshpsal = Order(rawValue: 1 << 7)
            static let recmom = Order(rawValue: 1 << 8)
            static let recmomsal = Order(rawValue: 1 << 9)
            static let recmomret = Order(rawValue: 1 << 10)

            static let all: Order = [.recsal, .recret, .reclen, .recler, .recrep, .recexc, .recshp, .recshpsal, .recmom, .recmomsal, recmomret]
            init(rawValue: Int) {
                self.rawValue = rawValue
            }
            init(string: String?) {
                if let string = string {
                    switch string {
                    case Order.recsal.description:
                        self = .recsal
                    case Order.recret.description:
                        self = .recret
                    case Order.reclen.description:
                        self = .reclen
                    case Order.recler.description:
                        self = .recler
                    case Order.recrep.description:
                        self = .recrep
                    case Order.recexc.description:
                        self = .recexc
                    case Order.recshp.description:
                        self = .recshp
                    case Order.recshpsal.description:
                        self = .recshpsal
                    case Order.recmom.description:
                        self = .recmom
                    case Order.recmomsal.description:
                        self = .recmomsal
                    case Order.recmomret.description:
                        self = .recmomret
                    default:
                        self = .invalid
                    }
                } else {
                    self = .invalid
                }
            }
            var description: String {
                get {
                    switch self {
                    case .recsal:
                        return "recsal"
                    case .recret:
                        return "recret"
                    case .reclen:
                        return "reclen"
                    case .recler:
                        return "recler"
                    case .recrep:
                        return "recrep"
                    case .recexc:
                        return "recexc"
                    case .recshp:
                        return "recshp"
                    case .recshpsal:
                        return "recshpsal"
                    case .recmom:
                        return "recmom"
                    case .recmomsal:
                        return "recmomsal"
                    case .recmomret:
                        return "recmomret"
                    default:
                        return ""
                    }
                }
            }
        }
        struct Vender: Permit {
            let rawValue: Int
            
            static let invalid = Vender(rawValue: 1 >> 1)
            static let venman = Vender(rawValue: 1 << 0)
            
            static let all: Vender = [.venman]
            init(rawValue: Int) {
                self.rawValue = rawValue
            }
            init(string: String?) {
                if let string = string {
                    switch string {
                    case Vender.venman.description:
                        self = .venman
                    default:
                        self = .invalid
                    }
                } else {
                    self = .invalid
                }
            }
            var description: String {
                get {
                    switch self {
                    case .venman:
                        return "venman"
                    default:
                        return ""
                    }
                }
            }
        }
        struct Purchase: Permit {
            let rawValue: Int
            
            static let invalid = Purchase(rawValue: 1 >> 1)
            static let purapp = Purchase(rawValue: 1 << 0)
            static let purrev = Purchase(rawValue: 1 << 1)

            static let all: Purchase = [.purapp, purrev]
            init(rawValue: Int) {
                self.rawValue = rawValue
            }
            init(string: String?) {
                if let string = string {
                    switch string {
                    case Purchase.purapp.description:
                        self = .purapp
                    case Purchase.purrev.description:
                        self = .purrev
                    default:
                        self = .invalid
                    }
                } else {
                    self = .invalid
                }
            }
            var description: String {
                get {
                    switch self {
                    case .purapp:
                        return "purapp"
                    case .purrev:
                        return "purrev"
                    default:
                        return ""
                    }
                }
            }
        }
        struct Payment: Permit {
            let rawValue: Int
            
            static let invalid = Payment(rawValue: 1 >> 1)
            static let paypay = Payment(rawValue: 1 << 0)
            
            static let all: Payment = [.paypay]
            init(rawValue: Int) {
                self.rawValue = rawValue
            }
            init(string: String?) {
                if let string = string {
                    switch string {
                    case Payment.paypay.description:
                        self = .paypay
                    default:
                        self = .invalid
                    }
                } else {
                    self = .invalid
                }
            }
            var description: String {
                get {
                    switch self {
                    case .paypay:
                        return "paypay"
                    default:
                        return ""
                    }
                }
            }
        }
        struct Receipt: Permit {
            let rawValue: Int
            
            static let invalid = Receipt(rawValue: 1 >> 1)
            static let repsal = Receipt(rawValue: 1 << 0)
            static let reprev = Receipt(rawValue: 1 << 1)

            static let all: Receipt = [.repsal, reprev]
            init(rawValue: Int) {
                self.rawValue = rawValue
            }
            init(string: String?) {
                if let string = string {
                    switch string {
                    case Receipt.repsal.description:
                        self = .repsal
                    case Receipt.reprev.description:
                        self = .reprev
                    default:
                        self = .invalid
                    }
                } else {
                    self = .invalid
                }
            }
            var description: String {
                get {
                    switch self {
                    case .repsal:
                        return "repsal"
                    case .reprev:
                        return "reprev"
                    default:
                        return ""
                    }
                }
            }
        }
        struct Admin: Permit {
            let rawValue: Int
            
            static let invalid = Admin(rawValue: 1 >> 1)
            static let admacc = Admin(rawValue: 1 << 0)
            static let admadm = Admin(rawValue: 1 << 1)

            static let all: Admin = [.admacc, admadm]
            init(rawValue: Int) {
                self.rawValue = rawValue
            }
            init(string: String?) {
                if let string = string {
                    switch string {
                    case Admin.admacc.description:
                        self = .admacc
                    case Admin.admadm.description:
                        self = .admadm
                    default:
                        self = .invalid
                    }
                } else {
                    self = .invalid
                }
            }
            var description: String {
                get {
                    switch self {
                    case .admacc:
                        return "admacc"
                    case .admadm:
                        return "admadm"
                    default:
                        return ""
                    }
                }
            }
        }
        struct Setting: Permit {
            let rawValue: Int
            
            static let invalid = Setting(rawValue: 1 >> 1)
            static let setbas = Setting(rawValue: 1 << 0)
            static let setdos = Setting(rawValue: 1 << 1)

            static let all: Setting = [.setbas, setdos]
            init(rawValue: Int) {
                self.rawValue = rawValue
            }
            init(string: String?) {
                if let string = string {
                    switch string {
                    case Setting.setbas.description:
                        self = .setbas
                    case Setting.setdos.description:
                        self = .setdos
                    default:
                        self = .invalid
                    }
                } else {
                    self = .invalid
                }
            }
            var description: String {
                get {
                    switch self {
                    case .setbas:
                        return "setbas"
                    case .setdos:
                        return "setdos"
                    default:
                        return ""
                    }
                }
            }
        }
        internal class Navigation: Decodable {
            enum NavigationKeys: String, CodingKey {
                case name, navigation_no, is_function, descendant
            }
            let name: String?
            let navigationNo: String?
            let isFunction: Bool?
            let descendants: [Navigation]?
            required init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: NavigationKeys.self)
                name = try container.decode(String.self, forKey: .name)
                navigationNo = try container.decode(String.self, forKey: .navigation_no)
                isFunction = try container.decode(Bool.self, forKey: .is_function)
                descendants = try container.decode([Navigation].self, forKey: .descendant)
            }
        }

        var product: Product = []
        var channel: Channel = []
        var storage: Storage = []
        var order: Order = []
        var vender: Vender = []
        var purchase: Purchase = []
        var payment: Payment = []
        var receipt: Receipt = []
        var admin: Admin = []
        var setting: Setting = []
        init(from decoder: Decoder) throws {
            var container = try decoder.unkeyedContainer()
            while !container.isAtEnd {
                let navigation = try container.decode(Navigation.self)
                if let descendents = navigation.descendants {
                    for descendent in descendents {
                        if let enabled = descendent.isFunction, enabled {
                            product.insert(Product(string: descendent.navigationNo))
                            channel.insert(Channel(string: descendent.navigationNo))
                            storage.insert(Storage(string: descendent.navigationNo))
                            order.insert(Order(string: descendent.navigationNo))
                            vender.insert(Vender(string: descendent.navigationNo))
                            purchase.insert(Purchase(string: descendent.navigationNo))
                            payment.insert(Payment(string: descendent.navigationNo))
                            receipt.insert(Receipt(string: descendent.navigationNo))
                            admin.insert(Admin(string: descendent.navigationNo))
                            setting.insert(Setting(string: descendent.navigationNo))
                        }
                    }
                }
            }
        }
        var description: String {
            get {
                return product.navigation+","+channel.navigation+","+storage.navigation+","+order.navigation+","+vender.navigation+","+purchase.navigation+","+payment.navigation+","+receipt.navigation+","+admin.navigation+","+setting.navigation
            }
        }
    }
    let list: [String]
    let navigations: Navigations
    enum AuthorizationKeys: String, CodingKey {
        case permit, navigation_list
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AuthorizationKeys.self)
        list = try container.decode([String].self, forKey: .permit)
        navigations = try container.decode(Navigations.self, forKey: .navigation_list)
    }
}
