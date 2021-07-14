//
//  HomeViewController.swift
//  MyMind
//
//  Created by Barry Chen on 2021/6/24.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
import Firebase
protocol NavigationActionDelegate: AnyObject {
    func didCancel()
}
typealias FunctionControlInfo = (type: MainFunctoinType, imageName: String, title: String)
typealias SwitcherInfo = (firstTitle: String, secondTitle: String, current: Int, section: Int)
final class HomeViewController: UIViewController {

    var skuRankingSortOrder: SKURankingReportSortOrder = .TOTAL_SALE_QUANTITY {
        didSet {
            loadSKURankingReportList()
        }
    }
    var setSKURankingSortOrder: SKURankingReportSortOrder = .TOTAL_SALE_QUANTITY {
        didSet {
            loadSetSKURankingReportList()
        }
    }
    private var headerInfos: [(title: String, info: SwitcherInfo)] = [("待辦事項", ("", "", 0, 0)), ("", ("", "", 0, 1)), ("近30日銷售數量", ("銷售數量", "銷售總額", 0, 2)), ("近7日SKU銷售排行", ("銷售數量", "銷售總額", 0, 3)), ("近7日加工組合SKU銷售排行", ("銷售數量", "銷售總額", 0, 4)), ("近7日銷售金額佔比", ("通路", "供應商", 0, 5)), ("近7日銷售毛利佔比", ("通路", "供應商", 0, 6))]
    private var toDoList: ToDoList? {
        didSet {
            collectionView.reloadSections([0])
        }
    }
    private var saleReports: SaleReports? {
        didSet {
            collectionView.reloadSections([1, 2])
        }
    }
    private var skuRankingReportList: SKURankingReportList? {
        didSet {
            collectionView.reloadSections([3])
        }
    }
    private var setSKURankingReportList: SKURankingReportList? {
        didSet {
            collectionView.reloadSections([4])
        }
    }
    private var saleRankingReports: SaleRankingReports? {
        didSet {
            print(saleRankingReports)
//            collectionView.reloadData()
        }
    }
    private var grossProfitRankingReports: SaleRankingReports? {
        didSet {
            print(grossProfitRankingReports)
//            collectionView.reloadData()
        }
    }

    private var homeModelData: HomeModel? {
        didSet {
            collectionView.reloadData()
        }
    }
    var authorization: Authorization?
    var remoteConfig: RemoteConfig!
    /// Must set on main thread
    private var isNetworkProcessing: Bool = false {
        didSet {
            switch isNetworkProcessing {
            case true: startAnimatingActivityIndicator()
            case false: stopAnimatinActivityIndicator()
            }
        }
    }

    @IBOutlet weak var collectionView: UICollectionView!
    private func loadHomeData() {
        loadToDoList()
        loadSaleReports()
        loadSKURankingReportList()
        loadSetSKURankingReportList()
//        loadSaleRankingReports()
//        loadGrossProfitRankingReports()
    }
    private func loadToDoList() {
        if let authorization = authorization {
            isNetworkProcessing = true
            let dashboardLoader = MyMindDashboardAPIService.shared

            dashboardLoader.todo(with: authorization.navigations.description)
                .done { toDoList in
                    self.toDoList = toDoList
                }
                .ensure {
                    self.isNetworkProcessing = false
                }
                .catch { error in
                    if let apiError = error as? APIError {
                        _ = ErrorHandler.shared.handle(apiError, controller: self)
                    } else {
                        ToastView.showIn(self, message: error.localizedDescription)
                    }
                }
        }
    }
    private func loadSaleReports() {
        isNetworkProcessing = true
        let dashboardLoader = MyMindDashboardAPIService.shared
        let end = Date()
        dashboardLoader.orderSaleReport(start: end, end: end, type: .byType)
            .done { typeSaleReportList in
                dashboardLoader.orderSaleReport(start: end.thirtyDaysBefore, end: end, type: .byDate)
                    .done { dateSaleReportList in
                        let transformedSaleReport = typeSaleReportList.reports.first {
                            $0.type == .TRANSFORMED
                        }
                        let shippedSaleReport = typeSaleReportList.reports.first {
                            $0.type == .SHIPPED
                        }
                        self.saleReports = SaleReports(todayTransformedSaleReport: transformedSaleReport, todayShippedSaleReport: shippedSaleReport, dateSaleReportList: dateSaleReportList)
                    }
                    .ensure {
                        self.isNetworkProcessing = false
                    }
                    .catch { error in
                        if let apiError = error as? APIError {
                            _ = ErrorHandler.shared.handle(apiError, controller: self)
                        } else {
                            ToastView.showIn(self, message: error.localizedDescription)
                        }
                    }
            }
            .catch { error in
                if let apiError = error as? APIError {
                    _ = ErrorHandler.shared.handle(apiError, controller: self)
                } else {
                    ToastView.showIn(self, message: error.localizedDescription)
                }
            }
    }
    private func loadSKURankingReportList() {
        isNetworkProcessing = true
        let dashboardLoader = MyMindDashboardAPIService.shared
        let end = Date()
        dashboardLoader.skuRankingReport(start: end.sevenDaysBefore, end: end, isSet: false, order: skuRankingSortOrder.rawValue, count: 5)
            .done { rankingReportList in
                self.skuRankingReportList = rankingReportList
            }
            .ensure {
                self.isNetworkProcessing = false
            }
            .catch { error in
                if let apiError = error as? APIError {
                    _ = ErrorHandler.shared.handle(apiError, controller: self)
                } else {
                    ToastView.showIn(self, message: error.localizedDescription)
                }
            }
    }
    private func loadSetSKURankingReportList() {
        isNetworkProcessing = true
        let dashboardLoader = MyMindDashboardAPIService.shared
        let end = Date()
        dashboardLoader.skuRankingReport(start: end.sevenDaysBefore, end: end, isSet: true, order: setSKURankingSortOrder.rawValue, count: 5)
            .done { setRankingReportList in
                self.setSKURankingReportList = setRankingReportList
            }
            .ensure {
                self.isNetworkProcessing = false
            }
            .catch { error in
                if let apiError = error as? APIError {
                    _ = ErrorHandler.shared.handle(apiError, controller: self)
                } else {
                    ToastView.showIn(self, message: error.localizedDescription)
                }
            }
    }
    private func loadSaleRankingReports() {
        isNetworkProcessing = true
        let dashboardLoader = MyMindDashboardAPIService.shared
        let end = Date()
        dashboardLoader.storeRankingReport(start: end.sevenDaysBefore, end: end, order: "TOTAL_SALE_AMOUNT")
            .done { storeRankingReportList in
                dashboardLoader.channelRankingReport(start: end.sevenDaysBefore, end: end, order: "TOTAL_SALE_AMOUNT")
                    .done { channelRankingReportList in
                        self.saleRankingReports = SaleRankingReports(storeRankingReportList: storeRankingReportList, channelRankingReportList: channelRankingReportList)
                    }
                    .ensure {
                        self.isNetworkProcessing = false
                    }
                    .catch { error in
                        if let apiError = error as? APIError {
                            _ = ErrorHandler.shared.handle(apiError, controller: self)
                        } else {
                            ToastView.showIn(self, message: error.localizedDescription)
                        }
                    }
            }
            .catch { error in
                if let apiError = error as? APIError {
                    _ = ErrorHandler.shared.handle(apiError, controller: self)
                } else {
                    ToastView.showIn(self, message: error.localizedDescription)
                }
            }
    }
    private func loadGrossProfitRankingReports() {
        isNetworkProcessing = true
        let dashboardLoader = MyMindDashboardAPIService.shared
        let end = Date()
        dashboardLoader.storeRankingReport(start: end.sevenDaysBefore, end: end, order: "SALE_GROSS_PROFIT")
            .done { storeRankingReportList in
                dashboardLoader.channelRankingReport(start: end.sevenDaysBefore, end: end, order: "SALE_GROSS_PROFIT")
                    .done { channelRankingReportList in
                        self.grossProfitRankingReports = SaleRankingReports(storeRankingReportList: storeRankingReportList, channelRankingReportList: channelRankingReportList)
                    }
                    .ensure {
                        self.isNetworkProcessing = false
                    }
                    .catch { error in
                        if let apiError = error as? APIError {
                            _ = ErrorHandler.shared.handle(apiError, controller: self)
                        } else {
                            ToastView.showIn(self, message: error.localizedDescription)
                        }
                    }
            }
            .catch { error in
                if let apiError = error as? APIError {
                    _ = ErrorHandler.shared.handle(apiError, controller: self)
                } else {
                    ToastView.showIn(self, message: error.localizedDescription)
                }
            }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonTitle = ""
        self.title = "MyMind"
        self.tabBarItem.title = "首頁"
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        collectionView.register(HomeCollectionViewHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomeHeader")
        collectionView.register(HomeCollectionViewSwitchContentHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomeSwitchContentHeader")
        remoteConfig.fetch { status, error in
            self.remoteConfig.activate()
            self.loadHomeData()
        }
    }
}
/// UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 7
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0, 1, 3, 4: return 1
        default: return 0//return remoteConfig["otp_enable"].boolValue ? 4 : 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ToDoListCollectionViewCell", for: indexPath) as? ToDoListCollectionViewCell {
                if let items = toDoList?.items {
                    cell.config(with: items)
                }
                return cell
            }
            return UICollectionViewCell()
        case 1:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodaySaleReportCollectionViewCell", for: indexPath) as? TodaySaleReportCollectionViewCell {
                let formatter = DateFormatter {
                    $0.dateFormat = "yyyy-MM-dd"
                }
                let now = Date()
                let reportOfToday = saleReports?.dateSaleReportList.reports.first(where: { report in
                    report.date == formatter.string(from: now)
                })
                let reportOfYesterday = saleReports?.dateSaleReportList.reports.first(where: { report in
                    report.date == formatter.string(from: now.yesterday)
                })
                cell.config(with: reportOfToday, yesterday: reportOfYesterday, transformed: saleReports?.todayTransformedSaleReport, shipped: saleReports?.todayShippedSaleReport)
                return cell
            }
            return UICollectionViewCell()
        case 3:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SKURankingCollectionViewCell", for: indexPath) as? SKURankingCollectionViewCell {
                cell.config(with: skuRankingReportList, order: skuRankingSortOrder)
                return cell
            }
            return UICollectionViewCell()
        case 4:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SKURankingCollectionViewCell", for: indexPath) as? SKURankingCollectionViewCell {
                cell.config(with: setSKURankingReportList, order: setSKURankingSortOrder)
                return cell
            }
            return UICollectionViewCell()
        default:
            return UICollectionViewCell()
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActionCollectionViewCell", for: indexPath) as? ActionCollectionViewCell
//            cell?.config(with: functionControlInfos[indexPath.item])
//            return cell ?? UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        let left = collectionView.frame.origin.x
        let insets = ((collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset ?? .zero)
        let itemSpaceing = ((collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumLineSpacing ?? 10)
        let itemWidth = width-left-itemSpaceing-insets.left
        switch indexPath.section {
        case 0, 1:
            return CGSize(width: itemWidth, height: 280)
        case 3, 4:
            return CGSize(width: itemWidth, height: CGFloat(236))
        default:
            return CGSize(width: itemWidth, height: itemWidth)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = collectionView.bounds.width
        switch section {
        case 1:
            return .zero
        default:
            return CGSize(width: width, height: 50)
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            if indexPath.section == 0 {
                if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HomeHeader", for: indexPath) as? HomeCollectionViewHeaderView {
                    headerView.config(with: 6, title: headerInfos[indexPath.section].title)
                    return headerView
                }
            } else {
                if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HomeSwitchContentHeader", for: indexPath) as? HomeCollectionViewSwitchContentHeaderView {
                    headerView.config(with: 6, title: headerInfos[indexPath.section].title, switcher: headerInfos[indexPath.section].info, delegate: self)
                    return headerView
                }
            }
            return UICollectionReusableView()
        }
        return UICollectionReusableView()
    }
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            let purchaseListViewController = PurchaseListViewController(purchaseListLoader: MyMindPurchaseAPIService.shared)
            show(purchaseListViewController, sender: nil)
        case 1:
            let purchaseListViewController = PurchaseListViewController(purchaseListLoader: MyMindPurchaseReviewAPIService.shared, reviewing: true)
            show(purchaseListViewController, sender: nil)
        case 2:
            if let settingViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Setting") as? SettingViewController {
                settingViewController.delegate = self
                show(settingViewController, sender: nil)
            }
            break
        case 3:
            let storyboard: UIStoryboard = UIStoryboard(name: "TOTP", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "SecretListViewControllerNavi")
            present(viewController, animated: true, completion: nil)
        default:
            break
        }
    }
}
/// IndicatorSwitchContentHeaderViewDelegate
extension HomeViewController: IndicatorSwitchContentHeaderViewDelegate {
    func contentNeedSwitch(to index: Int, for section: Int) {
        headerInfos[section].info.current = index
        switch section {
        case 3:
            skuRankingSortOrder = (index == 0) ? .TOTAL_SALE_QUANTITY : .TOTAL_SALE_AMOUNT
        case 4:
            setSKURankingSortOrder = (index == 0) ? .TOTAL_SALE_QUANTITY : .TOTAL_SALE_AMOUNT
        default:
            collectionView.reloadSections([section])
            
        }
    }
}
/// SettingViewControllerDelegate
extension HomeViewController: SettingViewControllerDelegate {
    func didSignOut() {
        self.navigationController?.popViewController(animated: true)
        let scene = UIApplication.shared.connectedScenes.first
        if let sceneDelegate : SceneDelegate = (scene?.delegate as? SceneDelegate) {
            let viewModel = SignInViewModel(
                userSessionRepository: MyMindUserSessionRepository.shared,
                signInValidationService: SignInValidatoinService(),
                lastSignInInfoDataStore: MyMindLastSignInInfoDataStore()
            )
            let signInViewController = SignInViewController(viewModel: viewModel)
            sceneDelegate.window?.rootViewController = signInViewController
        }
    }
}
/// NavigationActionDelegate
extension HomeViewController: NavigationActionDelegate {
    func didCancel() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

final class ActionCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = 6.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor(hex: "e5e5e5").cgColor
        contentView.layer.masksToBounds = true

        layer.shadowColor = UIColor(hex: "e5e5e5").cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 6.0
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = contentView.bounds
        let color1 = UIColor(hex: "e5e5e5").cgColor
        let color2 = UIColor.tertiarySystemBackground.cgColor
        gradientLayer.colors = [color1, color2]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        contentView.layer.insertSublayer(gradientLayer, at: 0)
    }
    func config(with info: FunctionControlInfo) {
        iconImageView.image = UIImage(named: info.imageName)
        titleLabel.text = info.title
    }
}
