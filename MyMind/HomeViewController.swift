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
final class HomeViewController: UIViewController {

    private let cellTitles = ["異常入庫", "審核退回", "審核通過", "待審核"]
    private let headerTitles = ["待辦事項", "", "", "近7日SKU銷售排行", "近7日加工組合SKU銷售排行", "近7日銷售金額佔比", "近7日銷售毛利佔比"]
    private let functionControlInfos: [FunctionControlInfo] = [
        (.purchaseApply, "buy_icon", "採購申請"),
        (.paybill, "examine_icon", "採購審核"),
        (.accountSetting, "system_setting_icon", "帳號設定"),
        (.saleChart, "account_setting_icon", "OTP")
    ]
    private var toDoList: ToDoList? {
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
//    private func loadPurchaseList() {
//        isNetworkProcessing = true
//        let purchaseListLoader = MyMindPurchaseAPIService.shared
//        purchaseListLoader.loadPurchaseList(with: nil)
//            .done { purchaseList in
//                self.handleSuccessFetchPurchaseList(purchaseList)
//            }
//            .ensure {
//                self.isNetworkProcessing = false
//            }
//            .catch(handleErrorForFetchPurchaseList(_:))
//    }
//    private func handleSuccessFetchPurchaseList(_ purchaseList: PurchaseList) {
//
//        if self.purchaseList != nil {
//            self.purchaseList?.updateWithNextPageList(purchaseList: purchaseList)
//        } else {
//            self.purchaseList = purchaseList
//        }
//    }
//
//    private func handleErrorForFetchPurchaseList(_ error: Error) {
//        if let apiError = error as? APIError {
//            _ = ErrorHandler.shared.handle(apiError, controller: self)
//        } else {
//            ToastView.showIn(self, message: error.localizedDescription)
//        }
//    }

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

        remoteConfig.fetch { status, error in
            self.remoteConfig.activate()
            self.loadHomeData()
//            self.loadPurchaseList()
        }
    }
}
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 1 : remoteConfig["otp_enable"].boolValue ? 4 : 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ToDoListCollectionViewCell", for: indexPath) as? ToDoListCollectionViewCell {
                if let items = toDoList?.items {
                    cell.config(with: items)
                }
                return cell
            }
            return UICollectionViewCell()
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActionCollectionViewCell", for: indexPath) as? ActionCollectionViewCell
        cell?.config(with: functionControlInfos[indexPath.item])
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        let left = collectionView.frame.origin.x
        let insets = ((collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset ?? .zero)
        let itemSpaceing = ((collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumLineSpacing ?? 10)
        let itemWidth = width-left-itemSpaceing-insets.left
        if indexPath.section == 0 {
            return CGSize(width: itemWidth, height: 280)
        } else {
            return CGSize(width: itemWidth, height: itemWidth)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = collectionView.bounds.width
        return CGSize(width: width, height: 50)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HomeHeader", for: indexPath) as? HomeCollectionViewHeaderView {
                headerView.config(with: 6, title: headerTitles[indexPath.section])
                return headerView
            }
            return UICollectionReusableView()
        } else if kind == UICollectionView.elementKindSectionFooter {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HomeFooter", for: indexPath)
            return footerView
        }
        return UICollectionReusableView()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let width = collectionView.bounds.width
        return CGSize(width: width, height: section == 0 ? 40 : 0)
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
extension HomeViewController: NavigationActionDelegate {
    func didCancel() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//final class HorizontalCellSizePagingFlowLayout: UICollectionViewFlowLayout {
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        scrollDirection = .horizontal
//    }
//    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
//
//        guard let collectionView = self.collectionView else {
//            let latestOffset = super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
//            return latestOffset
//        }
//
//        // Page width used for estimating and calculating paging.
//        let pageWidth = self.itemSize.width + self.minimumInteritemSpacing //- 60
//
//        // Make an estimation of the current page position.
//        let approximatePage = collectionView.contentOffset.x/pageWidth
//
//        // Determine the current page based on velocity.
//        let currentPage = velocity.x == 0 ? round(approximatePage) : (velocity.x < 0.0 ? floor(approximatePage) : ceil(approximatePage))
//
//        // Create custom flickVelocity.
//        let flickVelocity = velocity.x * 0.3
//
//        // Check how many pages the user flicked, if <= 1 then flickedPages should return 0.
//        let flickedPages = (abs(round(flickVelocity)) <= 1) ? 0 : round(flickVelocity)
//
//        // Calculate newHorizontalOffset.
//        let newHorizontalOffset = ((currentPage + flickedPages) * pageWidth) - collectionView.contentInset.left
//
//        return CGPoint(x: newHorizontalOffset, y: proposedContentOffset.y)
//    }
//
//}
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
