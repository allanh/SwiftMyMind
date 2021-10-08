//
//  MainFunctionEntryViewController.swift
//  MyMind
//
//  Created by Barry Chen on 2021/3/11.
//

import UIKit
typealias FunctionControlInfo = (type: MainFunctoinType, category: MainFunctionCategory)
enum MainFunctoinType: String {
    case purchaseApply = "採購申請"
    case purchaseReview = "採購審核"
    case paybill = "付款單"
    case saleChart = "銷售報表"
    case revenueChart = "營收報表"
    case systemSetting = "系統設定"
    case accountSetting = "帳號設定"
    case announcement = "公告"
    var imageName: String {
        get {
            switch self {
            case .purchaseApply: return "buy_icon"
            case .purchaseReview: return "examine_icon"
            default: return ""
            }
        }
    }
}
enum MainFunctionCategory: String {
    case purchase = "採購管理"
    case order = "訂單管理"
    case storage = "庫存管理"
}
struct FunctionEntryList {
    var purchase: [FunctionControlInfo]
    var order: [FunctionControlInfo]
    var storage: [FunctionControlInfo]
    var allItems: [FunctionControlInfo] {
        get {
            return purchase+order+storage
        }
    }
    var allCategories: [MainFunctionCategory] {
        return [.purchase, .order, .storage]
    }
}
final class MainFunctionEntryViewController: NiblessViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    private var functionControls: [MainFunctionControl] = []
    private var functionInfos: FunctionEntryList = FunctionEntryList(purchase: [], order: [], storage: [])
//    private var functionControls: [UIView] = []
    var authorization: Authorization?


    private var functionControlInfos: [FunctionControlInfo] = [
//        (.purchaseApply, "buy_icon"),
//        (.purchaseReview, "examine_icon"),
//        (.paybill, "pay_icon"),
//        (.saleChart, "sale_icon"),
//        (.revenueChart, "renvenu_icon"),
//        (.systemSetting, "system_setting_icon"),
//        (.accountSetting, "account_setting_icon")
    ]

    private let stackView: UIStackView = UIStackView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.spacing = 16
        $0.axis = .vertical
        $0.distribution = .fillProportionally
    }
    private let scrollView: UIScrollView = UIScrollView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.automaticallyAdjustsScrollIndicatorInsets = false
        $0.backgroundColor = .red
    }
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = .init(top: 8, left: 16, bottom: 8, right: 17)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.isHidden = true
        collectionView.backgroundColor = .blue
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        self.tabBarItem.title = "功能"
        navigationController?.navigationBar.tintColor = .white
        if let authorization = authorization {
            if authorization.navigations.purchase.contains(.purapp) {
                functionControlInfos.append((.purchaseApply, .purchase))
                functionInfos.purchase.append((.purchaseApply, .purchase))
            }
            if authorization.navigations.purchase.contains(.purrev) {
                functionControlInfos.append((.purchaseReview, .purchase))
                functionInfos.purchase.append((.purchaseReview, .purchase))
            }
        }
//        functionControlInfos.append((.announcement, "calendar_icon"))
        constructViewHeirarchy()
//        constructScrollView()
//        activateConstraintsScrollView()
        activateConstraintsCategoryContainer()
        activateConstraintsCollectionView()
//        creatFuncitonControls()
//        constructStackViews()
//        activateConstraintsStackView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    private func constructViewHeirarchy() {
        let categoryContainerViewController = CategoryViewController(items: [("全部", nil), ("採購管理", nil), ("訂單管理", "order"), ("庫存管理", "storage")])
        categoryContainerViewController.insets = UIEdgeInsets(top: 14, left: 16, bottom: 14, right: 16)
        categoryContainerViewController.interspacing = 8
        categoryContainerViewController.font = .pingFangTCRegular(ofSize: 16)
        categoryContainerViewController.itemInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        categoryContainerViewController.delegate = self
        addChild(categoryContainerViewController)
        view.addSubview(categoryContainerViewController.view)
        categoryContainerViewController.didMove(toParent: self)
//        categoryContainerViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
//        categoryContainerViewController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        categoryContainerViewController.view.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//        categoryContainerViewController.view.heightAnchor.constraint(equalToConstant: 60).isActive = true

        view.addSubview(collectionView)
//        view.addSubview(stackView)
    }
    private func constructScrollView() {
        if functionInfos.allItems.count > 0 {
            
            let all = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
            all.setTitle("全部", for: .normal)
            all.backgroundColor = UIColor.prussianBlue
            scrollView.addSubview(all)
            
        }
    }
    private func activateConstraintsScrollView() {
        let top = scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let centerX = scrollView.centerXAnchor
            .constraint(equalTo: view.centerXAnchor)
        let width = scrollView.widthAnchor
            .constraint(equalTo: view.widthAnchor)
        let height = scrollView.heightAnchor.constraint(equalToConstant: 60)
        NSLayoutConstraint.activate([
            centerX, top, width, height
        ])
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
    private let rowHeight: CGFloat = 160
    private let columns = 2
    private func activateConstraintsStackView() {
        let top = stackView.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 20)
        let leading = stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        let trailing = stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
//        let centerX = stackView.centerXAnchor
//            .constraint(equalTo: view.centerXAnchor)
//        let width = stackView.widthAnchor
//            .constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        let numberOfRows = functionControlInfos.count / columns + 1
        let height = stackView.heightAnchor.constraint(equalToConstant: CGFloat(numberOfRows)*rowHeight+stackView.spacing)
        NSLayoutConstraint.activate([
            leading, top, trailing, height
        ])
    }
    private func constructStackViews() {
        var horizontalStackView: UIView? = creatHorizontalView()
        for index in 0..<functionControls.count {
            if horizontalStackView == nil {
                horizontalStackView = creatHorizontalView()
            }
            horizontalStackView?.addSubview(functionControls[index])
            if (index + 1) % 2 == 0{
                self.stackView.addArrangedSubview(horizontalStackView!)
                horizontalStackView = nil
            }
        }
        if let lastView = horizontalStackView {
            self.stackView.addArrangedSubview(lastView)
        }
    }
    private func creatHorizontalView() -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.stackView.bounds.width, height: rowHeight))
        return view
    }

    private func creatFuncitonControls() {
        let width = (view.bounds.width-48)
        let itemWidth = width * 0.5
        for (index, item) in functionControlInfos.enumerated() {
            let x = index%2 == 0 ? 0 : width-itemWidth+16
            let functionControl = MainFunctionControl(frame: CGRect(x: x, y: 0, width: itemWidth, height: rowHeight),  mainFunctionType: item.type)
            functionControl.imageView.image = UIImage(named: item.type.imageName)
            functionControl.addTarget(self, action: #selector(didTapFunctionControl(_:)), for: .touchUpInside)
            functionControls.append(functionControl)
        }
    }

    @objc
    private func didTapFunctionControl(_ sender: MainFunctionControl) {
        switch sender.functionType {
        case .purchaseApply:
            show(PurchaseListViewController(purchaseListLoader: MyMindPurchaseAPIService.shared), sender: nil)
        case .paybill:
            let storyboard: UIStoryboard = UIStoryboard(name: "TOTP", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "SecretListViewControllerNavi")
            present(viewController, animated: true, completion: nil)
        case .purchaseReview:
            show(PurchaseListViewController(purchaseListLoader: MyMindPurchaseReviewAPIService.shared, reviewing: true), sender: nil)
        case .announcement:
            show(AnnouncementListViewController(announcementListLoader: MyMindAnnouncementAPIService.shared), sender: nil)
//        case .accountSetting:
//            if let settingViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Setting") as? SettingViewController {
//                settingViewController.delegate = self
//                show(settingViewController, sender: nil)
//            }
        default:
            print(sender.functionType)
        }
    }
}
//extension MainFunctionEntryViewController: MixedDelegate {
//    func didSignOut() {
//        self.navigationController?.popToRootViewController(animated: true)
//    }
//    func didCancel() {
//        self.navigationController?.popViewController(animated: true)
//    }
//}
extension MainFunctionEntryViewController: CategoryViewControllerDelegate {
    func categoryViewController(_: CategoryViewController, didSelect index: Int) {
        // reload collection view here
        print(index)
    }
}
