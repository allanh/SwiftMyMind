//
//  HomeViewController.swift
//  MyMind
//
//  Created by Barry Chen on 2021/6/24.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
protocol NavigationActionDelegate: AnyObject {
    func didCancel()
}
enum Section: Int, CaseIterable {
    case bulliten = 0
    case todo
    case today
    case thirtyDays
    case sevenDaysSKU
    case sevenDaysSetSKU
    case sevenDaysSaleAmount
    case sevenDaysGrossProfit
}
typealias FunctionControlInfo = (type: MainFunctoinType, imageName: String, title: String)
typealias SwitcherInfo = (firstTitle: String, secondTitle: String, current: Int, section: Section)
final class HomeViewController: UIViewController {

    var section: Int?
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    private var saleReportSortOrder: SKURankingReport.SKURankingReportSortOrder = .TOTAL_SALE_QUANTITY {
        didSet {
            collectionView.reloadSections([Section.thirtyDays.rawValue])
        }
    }
    private var skuRankingSortOrder: SKURankingReport.SKURankingReportSortOrder = .TOTAL_SALE_QUANTITY {
        didSet {
            loadSKURankingReportList()
        }
    }
    private var setSKURankingSortOrder: SKURankingReport.SKURankingReportSortOrder = .TOTAL_SALE_QUANTITY {
        didSet {
            loadSetSKURankingReportList()
        }
    }
    private var amountRankingDevider: SaleRankingReport.SaleRankingReportDevider = .store {
        didSet {
            loadSaleRankingReportList()
        }
    }
    private var grossProfitRankingDevider: SaleRankingReport.SaleRankingReportDevider = .store {
        didSet {
            loadGrossProfitRankingReportList()
        }
    }
    private func scrollThenReset(_ match: Int) {
        if let section = section, section == match {
            self.section = nil
            collectionView.scrollToItem(at: IndexPath(item: 0, section: section), at: .centeredVertically, animated: false)
        }
    }

    private var headerInfos: [(title: String, info: SwitcherInfo)] = [("", ("", "", 0, Section.bulliten)), ("", ("", "", 0, Section.todo)), ("今日數據", ("", "", 0, Section.today)), ("近30日銷售數量", ("銷售數量", "銷售總額", 0, Section.thirtyDays)), ("近7日SKU銷售排行", ("銷售數量", "銷售總額", 0, Section.sevenDaysSKU)), ("近7日加工組合SKU銷售排行", ("銷售數量", "銷售總額", 0, Section.sevenDaysSetSKU)), ("近7日銷售金額佔比", ("通路", "供應商", 0, Section.sevenDaysSaleAmount)), ("近7日銷售毛利佔比", ("通路", "供應商", 0, Section.sevenDaysGrossProfit))]

    private var bulletins: BulletinList? {
        didSet {
            collectionView.reloadSections([Section.bulliten.rawValue])
            scrollThenReset(Section.bulliten.rawValue)
        }
    }
    private var toDoList: ToDoList? {
        didSet {
            collectionView.reloadSections([Section.todo.rawValue])
            scrollThenReset(Section.todo.rawValue)
        }
    }
    private var saleReports: SaleReports? {
        didSet {
            collectionView.reloadSections([Section.today.rawValue])
            scrollThenReset(Section.today.rawValue)
        }
    }
    private var saleReportList: SaleReportList? {
        didSet {
            collectionView.reloadSections([Section.thirtyDays.rawValue])
            scrollThenReset(Section.thirtyDays.rawValue)
        }
    }
    private var skuRankingReportList: SKURankingReportList? {
        didSet {
            collectionView.reloadSections([Section.sevenDaysSKU.rawValue])
            scrollThenReset(Section.sevenDaysSKU.rawValue)
        }
    }
    private var setSKURankingReportList: SKURankingReportList? {
        didSet {
            collectionView.reloadSections([Section.sevenDaysSetSKU.rawValue])
            scrollThenReset(Section.sevenDaysSetSKU.rawValue)
        }
    }
    private var saleRankingReportList: SaleRankingReportList? {
        didSet {
            collectionView.reloadSections([Section.sevenDaysSaleAmount.rawValue])
            scrollThenReset(Section.sevenDaysSaleAmount.rawValue)
        }
    }
    private var grossProfitRankingReportList: SaleRankingReportList? {
        didSet {
            collectionView.reloadSections([Section.sevenDaysGrossProfit.rawValue])
            scrollThenReset(Section.sevenDaysGrossProfit.rawValue)
        }
    }
    
    var authorization: Authorization?
    /// Must set on main thread
    private var isNetworkProcessing: Bool = false {
        didSet {
            switch isNetworkProcessing {
            case true: startAnimatingActivityIndicator()
            case false: stopAnimatinActivityIndicator()
            }
        }
    }
    
    private var statusBarFrame: CGRect!
    private var statusBarView: UIView!
    private var offset: CGFloat!

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //header view begins under the navigation bar
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.navigationBar.alpha = 0.0
        collectionView.contentInsetAdjustmentBehavior = .never
        configStatuView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonTitle = ""
        title = "首頁"
        collectionView.register(HomeCollectionViewHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomeHeader")
        collectionView.register(HomeCollectionViewSwitchContentHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomeSwitchContentHeader")
        
        loadHomeData()
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func showAnnouncement(_ sender: Any) {
        show(AnnouncementListViewController(announcementListLoader: MyMindAnnouncementAPIService.shared), sender: nil)
    }
}
// MARK: data loading
extension HomeViewController {
    private func handlerError(_ error: Error) {
        if let apiError = error as? APIError {
            _ = ErrorHandler.shared.handle(apiError)
        } else {
            ToastView.showIn(self.tabBarController ?? self, message: error.localizedDescription)
        }
    }
    private func loadHomeData() {
        loadBulletins()
        loadToDoList()
        loadTodaySaleReports()
        loadSaleReportList()
        loadSKURankingReportList()
        loadSetSKURankingReportList()
        loadSaleRankingReportList()
        loadGrossProfitRankingReportList()
    }
    private func loadBulletins() {
        let dashboardLoader = MyMindDashboardAPIService.shared

        dashboardLoader.bulletins()
            .done { bulletins in
                self.bulletins = bulletins
            }
            .ensure {
                self.isNetworkProcessing = false
            }
            .catch { error in
                self.bulletins = nil
                self.handlerError(error)
            }
    }
//    private func loadAnnouncements() {
//        let announcementLoader = MyMindAnnouncementAPIService.shared
//        let info = AnnouncementInfo()
//        announcementLoader.announcements(info: info)
//            .done { announcements in
//                print(announcements)
//            }
//            .ensure {
//                self.isNetworkProcessing = false
//            }
//            .catch { error in
//                self.handlerError(error)
//            }
//    }
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
                    self.toDoList = nil
                    self.handlerError(error)
                }
        }
    }
    private func loadTodaySaleReports() {
        isNetworkProcessing = true
        let dashboardLoader = MyMindDashboardAPIService.shared
        let end = Date()
        dashboardLoader.orderSaleReport(start: end, end: end, type: .byType)
            .done { todaySaleReportList in
                dashboardLoader.orderSaleReport(start: end.yesterday, end: end.yesterday, type: .byType)
                    .done { yesterdaySaleReportList in
                        let todayTransformedSaleReport = todaySaleReportList.reports.first {
                            $0.type == .TRANSFORMED
                        }
                        let todayShippedSaleReport = todaySaleReportList.reports.first {
                            $0.type == .SHIPPED
                        }
                        let yesterdayTransformedSaleReport = yesterdaySaleReportList.reports.first {
                            $0.type == .TRANSFORMED
                        }
                        let yesterdayShippedSaleReport = yesterdaySaleReportList.reports.first {
                            $0.type == .SHIPPED
                        }
                        self.saleReports = SaleReports(dateString: end.shortDateString, todayTransformedSaleReport: todayTransformedSaleReport, todayShippedSaleReport: todayShippedSaleReport, yesterdayTransformedSaleReport: yesterdayTransformedSaleReport, yesterdayShippedSaleReport: yesterdayShippedSaleReport)
                    }
                    .ensure {
                        self.isNetworkProcessing = false
                    }
                    .catch { error in
                        self.saleReports = nil
                        self.handlerError(error)
                    }
            }
            .catch { error in
                self.saleReports = nil
                self.handlerError(error)
            }
    }
    private func loadSaleReportList() {
        isNetworkProcessing = true
        let dashboardLoader = MyMindDashboardAPIService.shared
        let end = Date()
        dashboardLoader.orderSaleReport(start: end.thirtyDaysBefore, end: end.yesterday, type: .byDate)
            .done { saleReportList in
                self.saleReportList = saleReportList
            }
            .ensure {
                self.isNetworkProcessing = false
            }
            .catch { error in
                self.saleReportList = nil
                self.handlerError(error)
            }
    }
    private func loadSKURankingReportList() {
        isNetworkProcessing = true
        let dashboardLoader = MyMindDashboardAPIService.shared
        let end = Date()
        dashboardLoader.skuRankingReport(start: end.sevenDaysBefore, end: end.yesterday, isSet: false, order: skuRankingSortOrder.rawValue, count: 5)
            .done { rankingReportList in
                self.skuRankingReportList = rankingReportList
            }
            .ensure {
                self.isNetworkProcessing = false
            }
            .catch { error in
                self.skuRankingReportList = nil
                self.handlerError(error)
            }
    }
    private func loadSetSKURankingReportList() {
        isNetworkProcessing = true
        let dashboardLoader = MyMindDashboardAPIService.shared
        let end = Date()
        dashboardLoader.skuRankingReport(start: end.sevenDaysBefore, end: end.yesterday, isSet: true, order: setSKURankingSortOrder.rawValue, count: 5)
            .done { setRankingReportList in
                self.setSKURankingReportList = setRankingReportList
            }
            .ensure {
                self.isNetworkProcessing = false
            }
            .catch { error in
                self.setSKURankingReportList = nil
                self.handlerError(error)
            }
    }
    private func loadSaleRankingReportList() {
        isNetworkProcessing = true
        let dashboardLoader = MyMindDashboardAPIService.shared
        let end = Date()
        if amountRankingDevider == .store {
            dashboardLoader.storeRankingReport(start: end.sevenDaysBefore, end: end.yesterday, order: "TOTAL_SALE_AMOUNT")
                .done { saleRankingReportList in
                    self.saleRankingReportList = saleRankingReportList
                }
                .ensure {
                    self.isNetworkProcessing = false
                }
                .catch { error in
                    self.saleRankingReportList = nil
                    self.handlerError(error)
                }
        } else {
            dashboardLoader.vendorRankingReport(start: end.sevenDaysBefore, end: end.yesterday, order: "TOTAL_SALE_AMOUNT")
                .done { saleRankingReportList in
                    self.saleRankingReportList = saleRankingReportList
                }
                .ensure {
                    self.isNetworkProcessing = false
                }
                .catch { error in
                    self.saleRankingReportList = nil
                    self.handlerError(error)
                }
        }
    }
    private func loadGrossProfitRankingReportList() {
        isNetworkProcessing = true
        let dashboardLoader = MyMindDashboardAPIService.shared
        let end = Date()
        if grossProfitRankingDevider == .store {
            dashboardLoader.storeRankingReport(start: end.sevenDaysBefore, end: end.yesterday, order: "SALE_GROSS_PROFIT")
                .done { grossProfitRankingReportList in
                    self.grossProfitRankingReportList = grossProfitRankingReportList
                }
                .ensure {
                    self.isNetworkProcessing = false
                }
                .catch { error in
                    self.grossProfitRankingReportList = nil
                    self.handlerError(error)
                }
        } else {
            dashboardLoader.vendorRankingReport(start: end.sevenDaysBefore, end: end.yesterday, order: "SALE_GROSS_PROFIT")
                .done { grossProfitRankingReportList in
                    self.grossProfitRankingReportList = grossProfitRankingReportList
                }
                .ensure {
                    self.isNetworkProcessing = false
                }
                .catch { error in
                    self.grossProfitRankingReportList = nil
                    self.handlerError(error)
                }
        }
    }
}
// MARK: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
/// UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case Section.todo.rawValue:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ToDoListCollectionViewCell", for: indexPath) as? ToDoListCollectionViewCell {
                if let items = toDoList?.items, items.count > 0 {
                    cell.config(with: items)
                } else {
                    cell.config(with: ToDoList.emptyItems)
                }
                return cell
            }
            return UICollectionViewCell()
        case Section.today.rawValue:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodaySaleReportCollectionViewCell", for: indexPath) as? TodaySaleReportCollectionViewCell {
                cell.config(with: saleReports)
                configCellShadow(cell)
                return cell
            }
            return UICollectionViewCell()
        case Section.thirtyDays.rawValue:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SaleReportCollectionViewCell", for: indexPath) as? SaleReportCollectionViewCell {
                cell.config(with: saleReportList, order: saleReportSortOrder)
                configCellShadow(cell)
                return cell
            }
            return UICollectionViewCell()
        case Section.sevenDaysSKU.rawValue:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SKURankingCollectionViewCell", for: indexPath) as? SKURankingCollectionViewCell {
                cell.config(with: skuRankingReportList, order: skuRankingSortOrder)
                configCellShadow(cell)
                return cell
            }
            return UICollectionViewCell()
        case Section.sevenDaysSetSKU.rawValue:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SKURankingCollectionViewCell", for: indexPath) as? SKURankingCollectionViewCell {
                cell.config(with: setSKURankingReportList, order: setSKURankingSortOrder)
                configCellShadow(cell)
                return cell
            }
            return UICollectionViewCell()
        case Section.sevenDaysSaleAmount.rawValue:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SaleRankingCollectionViewCell", for: indexPath) as? SaleRankingCollectionViewCell {
                cell.config(with: saleRankingReportList, devider: amountRankingDevider, profit: false)
                return cell
            }
            return UICollectionViewCell()
        case Section.sevenDaysGrossProfit.rawValue:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SaleRankingCollectionViewCell", for: indexPath) as? SaleRankingCollectionViewCell {
                cell.config(with: grossProfitRankingReportList, devider: grossProfitRankingDevider, profit: true)
                configCellShadow(cell)
                return cell
            }
            return UICollectionViewCell()
        case Section.bulliten.rawValue:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BulletinCollectionViewCell", for: indexPath) as? BulletinCollectionViewCell {
                cell.config(with: bulletins)
                return cell
            }
            return UICollectionViewCell()
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        switch indexPath.section {
        case Section.bulliten.rawValue:
            return CGSize(width: width, height: 158)
        case Section.todo.rawValue:
            return CGSize(width: width, height: 96)
        case Section.today.rawValue:
            return CGSize(width: width-32,  height: 322)
        case Section.thirtyDays.rawValue:
            return CGSize(width: width-32,  height: 316)
        case Section.sevenDaysSaleAmount.rawValue, Section.sevenDaysGrossProfit.rawValue:
            return CGSize(width: width-32,  height: 632)
        default:
            return CGSize(width: width-32, height: width*0.75)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        let width = collectionView.bounds.width
//        switch section {
//        case Section.bulliten.rawValue, Section.todo.rawValue:
            return .zero
//        default:
//            return CGSize(width: width-32, height: 50)
//        }
    }
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        if kind == UICollectionView.elementKindSectionHeader {
//            if indexPath.section == Section.today.rawValue {
//                if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HomeHeader", for: indexPath) as? HomeCollectionViewHeaderView {
//                    headerView.config(with: 6, title: headerInfos[indexPath.section].title)
//                    return headerView
//                }
//            } else {
//                if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HomeSwitchContentHeader", for: indexPath) as? HomeCollectionViewSwitchContentHeaderView {
//                    var title = headerInfos[indexPath.section].title
//                    if indexPath.section == Section.thirtyDays.rawValue, saleReportSortOrder == .TOTAL_SALE_AMOUNT {
//                        title = "近30日銷售總額"
//                    }
//                    headerView.config(with: 6, title: title, switcher: headerInfos[indexPath.section].info, delegate: self)
//                    return headerView
//                }
//            }
//            return UICollectionReusableView()
//        }
//        return UICollectionReusableView()
//    }
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case Section.sevenDaysSKU.rawValue, Section.sevenDaysSetSKU.rawValue, Section.sevenDaysSaleAmount.rawValue, Section.sevenDaysGrossProfit.rawValue: return false
        default: return false
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        switch indexPath.section {
//        case Section.bulliten.rawValue:
//            if let bulletinCell = cell as? BulletinCollectionViewCell {
//                bulletinCell.marqueeView.dataSource = self
//                bulletinCell.marqueeView.marqueeDelegate = self
//                bulletinCell.marqueeView.startAnimateMarqueeDuration(8, delay: 0.4, completion: nil)
//            }
//        default:
//            break
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case Section.sevenDaysSKU.rawValue:
            print("seven days SKU ranking \(skuRankingSortOrder)")
        case Section.sevenDaysSetSKU.rawValue:
            print("seven days set SKU ranking \(setSKURankingSortOrder)")
        case Section.sevenDaysSaleAmount.rawValue:
            print("seven days set sale amount detail \(amountRankingDevider)")
        case Section.sevenDaysGrossProfit.rawValue:
            print("seven days set gross profit detail \(grossProfitRankingDevider)")
        default:
            print(indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case Section.bulliten.rawValue:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        case Section.todo.rawValue:
            return UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        default:
            return UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
        }
    }
}
// MARK: IndicatorSwitchContentHeaderViewDelegate
/// IndicatorSwitchContentHeaderViewDelegate
extension HomeViewController: IndicatorSwitchContentHeaderViewDelegate {
    func contentNeedSwitch(to index: Int, for section: Section) {
        headerInfos[section.rawValue].info.current = index
        switch section {
        case Section.thirtyDays:
            saleReportSortOrder = (index == 0) ? .TOTAL_SALE_QUANTITY : .TOTAL_SALE_AMOUNT
        case Section.sevenDaysSKU:
            skuRankingSortOrder = (index == 0) ? .TOTAL_SALE_QUANTITY : .TOTAL_SALE_AMOUNT
        case Section.sevenDaysSetSKU:
            setSKURankingSortOrder = (index == 0) ? .TOTAL_SALE_QUANTITY : .TOTAL_SALE_AMOUNT
        case Section.sevenDaysSaleAmount:
            amountRankingDevider = (index == 0) ? .store : .vendor
        case Section.sevenDaysGrossProfit:
            grossProfitRankingDevider = (index == 0) ? .store : .vendor
        default:
            collectionView.reloadSections([section.rawValue])
            
        }
    }
}
// MARK: UDNSKInteractiveMarqueeViewDataSource
//extension HomeViewController: UDNSKInteractiveMarqueeViewDataSource, UDNSKInteractiveMarqueeViewDelegate {
//    func interactiveMarqueeView(_ marqueeView: UDNSKInteractiveMarqueeView, contentViewAt indexPath: IndexPath) -> UIView {
//        let label: UILabel = UILabel {
//            $0.text = bulletins?.items[indexPath.row].title
//            $0.textColor = .label
//            $0.backgroundColor = UIColor(hex: "fefbe8")
//            $0.frame = CGRect(origin: .zero, size: CGSize(width: marqueeView.bounds.width, height: 24))
//        }
//        return label
//    }
//
//    func numberOfMarquees(in marqueeView: UDNSKInteractiveMarqueeView) -> Int {
//        return bulletins?.items.count ?? 0
//    }
//
//    func direction(of marqueeView: UDNSKInteractiveMarqueeView) -> UDNSKInteractiveMarqueeView.ScrollDirection {
//        .left
//    }
//    func interactiveMarqueeView(_ marqueeView: UDNSKInteractiveMarqueeView, didSelectItemAt indexPath: IndexPath) {
//        print(bulletins?.items[indexPath.row].id)
//        #warning("show single bulletin")
//    }
//
//}
/*
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
*/


extension HomeViewController {
    func configStatuView() {
         //get height of status bar

         if #available(iOS 13.0, *) {
             statusBarFrame = UIWindow.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
         } else {
             // Fallback on earlier versions
             statusBarFrame = UIApplication.shared.statusBarFrame
         }

         //initially add a view which overlaps the status bar. Will be altered later.
         statusBarView = UIView(frame: statusBarFrame)
         statusBarView.isOpaque = false
         statusBarView.backgroundColor = .prussianBlue
         view.addSubview(statusBarView)
    }
    
    //function that is called everytime the scrollView scrolls
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //Mark the end of the offset
        guard let navigationBar = navigationController?.navigationBar else {
            return
        }
        let targetHeight = 200 - navigationBar.bounds.height - statusBarFrame.height
        
        //calculate how much has been scrolled relative to the targetHeight
        offset = scrollView.contentOffset.y / targetHeight
                
        //cap offset to 1 to conform to UIColor alpha parameter
        if offset > 1 {
            offset = 1
        }
        navigationBar.alpha = offset
        if offset > 0 {
            navigationController?.setNavigationBarHidden(false, animated: false)
        } else {
            navigationController?.setNavigationBarHidden(true, animated: false)
        }
    }
    
    func configCellShadow(_ cell: UICollectionViewCell) {
        // Configure the cell
        cell.contentView.layer.cornerRadius = 16.0
        cell.contentView.layer.masksToBounds = true
        cell.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 8.0)
        cell.layer.shadowRadius = 16.0
        cell.layer.shadowOpacity = 1
        cell.layer.masksToBounds = false
    }
}
