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
    case sevenDaysSaleAmount
}
//typealias FunctionControlInfo = (type: MainFunctoinType, imageName: String, title: String)
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

    private func scrollThenReset(_ match: Int) {
        if let section = section, section == match {
            self.section = nil
            collectionView.scrollToItem(at: IndexPath(item: 0, section: section), at: .centeredVertically, animated: false)
        }
    }

    private var headerInfos: [(title: String, info: SwitcherInfo)] = [("", ("", "", 0, Section.bulliten)), ("", ("", "", 0, Section.todo)), ("今日數據", ("", "", 0, Section.today)), ("近30日銷售數量", ("銷售數量", "銷售總額", 0, Section.thirtyDays)), ("近7日SKU銷售排行", ("銷售數量", "銷售總額", 0, Section.sevenDaysSKU)), ("近7日銷售金額佔比", ("通路", "供應商", 0, Section.sevenDaysSaleAmount))]

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
    
    @IBAction func showAnnouncement(_ sender: Any) {
        show(AnnouncementListViewController(announcementListLoader: MyMindAnnouncementAPIService.shared), sender: nil)
    }
}
// MARK: data loading
extension HomeViewController {
    internal func handlerError(_ error: Error) {
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
                self.loadYesterdaySaleReports(todaySaleReportList: todaySaleReportList)
            }
            .ensure {
                self.isNetworkProcessing = false
            }
            .catch { error in
                self.saleReports = nil
                self.handlerError(error)
            }
    }
    
    private func loadYesterdaySaleReports(todaySaleReportList: SaleReportList) {
        isNetworkProcessing = true
        let dashboardLoader = MyMindDashboardAPIService.shared
        let end = Date()
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
        case Section.bulliten.rawValue:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BulletinCollectionViewCell", for: indexPath) as? BulletinCollectionViewCell {
                cell.config(with: bulletins)
                return cell
            }
            return UICollectionViewCell()
        case Section.todo.rawValue:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ToDoListCollectionViewCell", for: indexPath) as? ToDoListCollectionViewCell {
                if let items = toDoList?.items, items.count > 0 {
                    cell.config(with: items, delegate: self)
                } else {
                    cell.config(with: ToDoList.emptyItems, delegate: self)
                }
                return cell
            }
            return UICollectionViewCell()
        case Section.today.rawValue:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodaySaleReportCollectionViewCell", for: indexPath) as? TodaySaleReportCollectionViewCell {
                cell.config(with: saleReports)
                cell.addShadow()
                return cell
            }
            return UICollectionViewCell()
        case Section.thirtyDays.rawValue:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SaleReportCollectionViewCell", for: indexPath) as? SaleReportCollectionViewCell {
                cell.config(with: saleReportList, order: saleReportSortOrder)
                cell.addShadow()
                return cell
            }
            return UICollectionViewCell()
        case Section.sevenDaysSKU.rawValue:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SKURankingListCollectionViewCell", for: indexPath) as? SKURankingListCollectionViewCell {
                cell.config(delegate: self)
                cell.layer.masksToBounds = false
                cell.clipsToBounds = false
                return cell
            }
            return UICollectionViewCell()
        case Section.sevenDaysSaleAmount.rawValue:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SaleRankingListCollectionViewCell", for: indexPath) as? SaleRankingListCollectionViewCell {
                cell.config(delegate: self)
                cell.layer.masksToBounds = false
                cell.clipsToBounds = false
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
        case Section.sevenDaysSKU.rawValue:
            return CGSize(width: width,  height: 337)
        case Section.sevenDaysSaleAmount.rawValue:
            return CGSize(width: width,  height: 538)
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
        case Section.sevenDaysSKU.rawValue, Section.sevenDaysSaleAmount.rawValue: return false
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
//        case Section.sevenDaysSKU.rawValue:
//            print("seven days SKU ranking \(skuRankingSortOrder)")
//        case Section.sevenDaysSaleAmount.rawValue:
//            print("seven days set sale amount detail \(amountRankingDevider)")
//        case Section.sevenDaysGrossProfit.rawValue:
//            print("seven days set gross profit detail \(grossProfitRankingDevider)")
        default:
            print(indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case Section.bulliten.rawValue, Section.sevenDaysSKU.rawValue:
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
//        case Section.sevenDaysSKU:
//            skuRankingSortOrder = (index == 0) ? .TOTAL_SALE_QUANTITY : .TOTAL_SALE_AMOUNT
//        case Section.sevenDaysSaleAmount:
//            amountRankingDevider = (index == 0) ? .store : .vendor
//        case Section.sevenDaysGrossProfit:
//            grossProfitRankingDevider = (index == 0) ? .store : .vendor
        default:
            collectionView.reloadSections([section.rawValue])
            
        }
    }
}

extension HomeViewController: ToDoListCollectionViewCellDelegate {
    func showToDoListPopupWindow(index: Int) {
        if let items = toDoList?.items, items.count > 0 {
            let viewController = ToDoPopupWindowViewController(toDos: items, index: index)
            self.present(viewController, animated: true, completion: nil)
//        } else {
//            let viewController = ToDoPopupWindowViewController(toDos: ToDoList.emptyItems)
//            self.present(viewController, animated: true, completion: nil)
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
}

extension HomeViewController: RankingListCollectionViewCellDelegate {
    func showLoading(_ isNetworkProcessing: Bool) {
        self.isNetworkProcessing = isNetworkProcessing
    }

    func handlerCellError(_ error: Error) {
        self.handlerError(error)
    }
}
