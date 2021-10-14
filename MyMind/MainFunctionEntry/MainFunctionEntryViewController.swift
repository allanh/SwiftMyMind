//
//  MainFunctionEntryViewController.swift
//  MyMind
//
//  Created by Barry Chen on 2021/3/11.
//

import UIKit
struct FunctionEntryList {
    enum FunctionEntryCategory: Category, CaseIterable {
        case all
        case product
        case channel
        case storage
        case order
        case vender
        case purchase
        case payment
        case receipt
        case admin
        case setting

        var title: String {
            get {
                switch self {
                case .all: return "全部"
                case .product: return "product"
                case .channel: return "channel"
                case .storage: return "庫存管理"
                case .order: return "訂單管理"
                case .vender: return "vender"
                case .purchase: return "採購管理"
                case .payment: return "payment"
                case .receipt: return "receipt"
                case .admin: return "admin"
                case .setting: return "setting"
                }
            }
        }
        var imageName: String? {
            get {
                switch self {
                case .all: return nil
                case .product: return nil
                case .channel: return nil
                case .storage: return nil
                case .order: return nil
                case .vender: return nil
                case .purchase: return nil
                case .payment: return nil
                case .receipt: return nil
                case .admin: return nil
                case .setting: return nil
                }
            }
        }
    }
    struct FunctionEntry {
        enum FunctionEntryItem: String {
            //
            case purchaseApply = "採購申請"
            case purchaseReview = "採購審核"
            //
            case orderSale = "銷貨單"
            case orderReturn = "退貨單"
            case orderBorrow = "借貨單"
            case orderPayOff = "還貨單"
            case orderSupply = "補貨單"
            case orderExchange = "換貨單"
            //
            case paybill = "付款單"
            case saleChart = "銷售報表"
            case revenueChart = "營收報表"
            case systemSetting = "系統設定"
            case accountSetting = "帳號設定"
            case announcement = "公告"
            var imageName: String {
                get {
                    switch self {
                    case .purchaseApply: return "purchase.purchase"
                    case .purchaseReview: return "purchase.review"
                    default: return ""
                    }
                }
            }
            var gradient: [UIColor] {
                get {
                    switch self {
                    case .purchaseApply: return [UIColor(hex: "977df0"), UIColor(hex: "7461f0")]
                    case .purchaseReview: return [UIColor(hex: "1fa1ff"), UIColor(hex: "1fa1ff")]
                    case .orderSale: return [.white, .black]
                    case .orderReturn: return [.red, .green]
                    case .orderBorrow: return [.green, .blue]
                    case .orderPayOff: return [.blue, .yellow]
                    case .orderSupply: return [.yellow, .purple]
                    case .orderExchange: return [.purple, .prussianBlue]
                    default: return [.black, .white]
                    }
                }
            }
        }
        var category: FunctionEntryCategory
        var items: [FunctionEntryItem]
    }
    var entries: [FunctionEntry]
    var allItems: [FunctionEntry.FunctionEntryItem] {
        get {
            return entries.reduce([], {$0 + $1.items})
        }
    }
    var allCategories: [FunctionEntryCategory] {
        get {
            var categories: [FunctionEntryCategory] = [.all]
            categories.append(contentsOf: entries.map{ $0.category })
            return categories
        }
    }
    func item(for category: Category, at index: Int) -> FunctionEntry.FunctionEntryItem? {
        if let mainCategory = category as? FunctionEntryCategory {
            if mainCategory == .all {
                return allItems[index]
            }
            return entries.first { $0.category == mainCategory }?.items[index]
        }
        return nil
    }
    func category(for item: FunctionEntry.FunctionEntryItem) -> Category? {
        for entry in entries {
            if entry.items.contains(item) {
                return entry.category
            }
        }
        return nil
    }
}
extension Authorization {
    var entryList: FunctionEntryList {
        get {
            return FunctionEntryList(entries: navigations.entries)
        }
    }
}
extension Authorization.Navigations {
    var entries: [FunctionEntryList.FunctionEntry] {
        get {
            var entries: [FunctionEntryList.FunctionEntry] = []
            if product.functionEntry.items.count > 0 {
                entries.append(product.functionEntry)
            }
            if channel.functionEntry.items.count > 0 {
                entries.append(channel.functionEntry)
            }
            if storage.functionEntry.items.count > 0 {
                entries.append(storage.functionEntry)
            }
            if order.functionEntry.items.count > 0 {
                entries.append(order.functionEntry)
            }
            if vender.functionEntry.items.count > 0 {
                entries.append(vender.functionEntry)
            }
            if purchase.functionEntry.items.count > 0 {
                entries.append(purchase.functionEntry)
            }
            if payment.functionEntry.items.count > 0 {
                entries.append(payment.functionEntry)
            }
            if receipt.functionEntry.items.count > 0 {
                entries.append(receipt.functionEntry)
            }
            if admin.functionEntry.items.count > 0 {
                entries.append(admin.functionEntry)
            }
            if setting.functionEntry.items.count > 0 {
                entries.append(setting.functionEntry)
            }
            return entries
        }
    }
}
//
extension Authorization.Navigations.Product {
    var functionEntry: FunctionEntryList.FunctionEntry {
        get {
            return FunctionEntryList.FunctionEntry(category: .product, items: [])
        }
    }
}
extension Authorization.Navigations.Channel {
    var functionEntry: FunctionEntryList.FunctionEntry {
        get {
            return FunctionEntryList.FunctionEntry(category: .channel, items: [])
        }
    }
}
extension Authorization.Navigations.Storage {
    var functionEntry: FunctionEntryList.FunctionEntry {
        get {
            return FunctionEntryList.FunctionEntry(category: .storage, items: [])
        }
    }
}
extension Authorization.Navigations.Order {
    var functionEntry: FunctionEntryList.FunctionEntry {
        get {
            return FunctionEntryList.FunctionEntry(category: .order, items: [.orderSale, .orderReturn, .orderBorrow, .orderPayOff, .orderSupply, .orderExchange])
        }
    }
}
extension Authorization.Navigations.Vender {
    var functionEntry: FunctionEntryList.FunctionEntry {
        get {
            return FunctionEntryList.FunctionEntry(category: .vender, items: [])
        }
    }
}
extension Authorization.Navigations.Purchase {
    var functionEntry: FunctionEntryList.FunctionEntry {
        get {
            var entry: FunctionEntryList.FunctionEntry = FunctionEntryList.FunctionEntry(category: .purchase, items: [])
            if contains(.purapp) {
                entry.items.append(.purchaseApply)
            }
            if contains(.purrev) {
                entry.items.append(.purchaseReview)
            }
            return entry
        }
    }
}
extension Authorization.Navigations.Payment {
    var functionEntry: FunctionEntryList.FunctionEntry {
        get {
            return FunctionEntryList.FunctionEntry(category: .payment, items: [])
        }
    }
}
extension Authorization.Navigations.Receipt {
    var functionEntry: FunctionEntryList.FunctionEntry {
        get {
            return FunctionEntryList.FunctionEntry(category: .receipt, items: [])
        }
    }
}
extension Authorization.Navigations.Admin {
    var functionEntry: FunctionEntryList.FunctionEntry {
        get {
            return FunctionEntryList.FunctionEntry(category: .admin, items: [])
        }
    }
}
extension Authorization.Navigations.Setting {
    var functionEntry: FunctionEntryList.FunctionEntry {
        get {
            return FunctionEntryList.FunctionEntry(category: .setting, items: [])
        }
    }
}

final class MainFunctionEntryViewController: NiblessViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    var authorization: Authorization?
    var selectedCategory: Category = FunctionEntryList.FunctionEntryCategory.all {
        didSet {
            collectionView.reloadData()
        }
    }

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(hex: "f5f6f8")
        self.tabBarItem.title = "功能"
        navigationController?.navigationBar.tintColor = .white
        collectionView.registerCellFormNib(for: MainFunctionEntryCollectionViewCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self

        constructViewHeirarchy()
        activateConstraintsCategoryContainer()
        activateConstraintsCollectionView()
        selectedCategory = FunctionEntryList.FunctionEntryCategory.all
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    private func constructViewHeirarchy() {
        let categoryContainerViewController = CategoryViewController(items: authorization?.entryList.allCategories ?? [])
        categoryContainerViewController.insets = UIEdgeInsets(top: 14, left: 16, bottom: 14, right: 16)
        categoryContainerViewController.interspacing = 8
        categoryContainerViewController.font = .pingFangTCRegular(ofSize: 16)
        categoryContainerViewController.itemInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        categoryContainerViewController.delegate = self
        addChild(categoryContainerViewController)
        view.addSubview(categoryContainerViewController.view)
        categoryContainerViewController.didMove(toParent: self)
        view.addSubview(collectionView)
    }
    private func activateConstraintsCategoryContainer() {
        let container = (children.first?.view)!
        container.translatesAutoresizingMaskIntoConstraints = false
        let top = container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let centerX = container.centerXAnchor
            .constraint(equalTo: view.centerXAnchor)
        let width = container.widthAnchor
            .constraint(equalTo: view.widthAnchor)
        let height = container.heightAnchor.constraint(equalToConstant: 60)
        NSLayoutConstraint.activate([
            centerX, top, width, height
        ])
    }
    private func activateConstraintsCollectionView() {
        let top = collectionView.topAnchor.constraint(equalTo: (children.first?.view.bottomAnchor)!, constant: 20)
        let leading = collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        let trailing = collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        let bottom = collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        NSLayoutConstraint.activate([
            bottom, top, leading, trailing
        ])
    }
//    @objc
//    private func didTapFunctionControl(_ sender: MainFunctionControl) {
//        switch sender.functionType {
//        case .purchaseApply:
//            show(PurchaseListViewController(purchaseListLoader: MyMindPurchaseAPIService.shared), sender: nil)
//        case .paybill:
//            let storyboard: UIStoryboard = UIStoryboard(name: "TOTP", bundle: nil)
//            let viewController = storyboard.instantiateViewController(withIdentifier: "SecretListViewControllerNavi")
//            present(viewController, animated: true, completion: nil)
//        case .purchaseReview:
//            show(PurchaseListViewController(purchaseListLoader: MyMindPurchaseReviewAPIService.shared, reviewing: true), sender: nil)
//        case .announcement:
//            show(AnnouncementListViewController(announcementListLoader: MyMindAnnouncementAPIService.shared), sender: nil)
////        case .accountSetting:
////            if let settingViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Setting") as? SettingViewController {
////                settingViewController.delegate = self
////                show(settingViewController, sender: nil)
////            }
//        default:
//            print(sender.functionType)
//        }
//    }
}
extension MainFunctionEntryViewController: CategoryViewControllerDelegate {
    func categoryViewController(_: CategoryViewController, didSelect category: Category) {
        // reload collection view here
        selectedCategory = category
    }
}
extension MainFunctionEntryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let mainCategory = selectedCategory as? FunctionEntryList.FunctionEntryCategory {
            if mainCategory == .all {
                return authorization?.entryList.allItems.count ?? 0
            }
            return authorization?.entryList.entries.first{ $0.category == mainCategory }?.items.count ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(MainFunctionEntryCollectionViewCell.self, for: indexPath) as? MainFunctionEntryCollectionViewCell else {
            fatalError("Wrong cell indentifier or not registered")
        }
        if let item = authorization?.entryList.item(for: selectedCategory, at: indexPath.row), let category = authorization?.entryList.category(for: item) {
            cell.config(with: item, category: category)
        }
        return cell
    }
    
    
}
extension MainFunctionEntryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 163, height: 160)
    }
}
