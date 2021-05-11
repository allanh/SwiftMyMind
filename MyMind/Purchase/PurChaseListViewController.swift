//
//  PurchaseListViewController.swift
//  MyMind
//
//  Created by Barry Chen on 2021/4/29.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

final class PurchaseListViewController: NiblessViewController {
    // MARK: - Properties
    var rootView: PurchaseListRootView { view as! PurchaseListRootView }

    let purchaseAPIService: PurchaseAPIService

    var purchaseList: PurchaseList?

    lazy var purchaseListQueryInfo: PurchaseListQueryInfo = {
        let partnerID = String(purchaseAPIService.userSession.partnerInfo.id)
        return .defaultQueryInfo(for: partnerID)
    }()

    /// Must set on main thread
    private var isNetworkProcessing: Bool = false {
        didSet {
            switch isNetworkProcessing {
            case true: startAnimatingActivityIndicator()
            case false: stopAnimatinActivityIndicator()
            }
        }
    }

    var filterViewController: PurchaseFilterViewController?
    var backgroundMaskView: UIView?
    var isSideMenuShowing: Bool = false
    var isSideMenuAnimating: Bool = false
    // MARK: - View life cycle
    override func loadView() {
        super.loadView()
        view = PurchaseListRootView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configTableView()
        configCollectionView()
        fetchPurchaseList()
        rootView.organizeOptionView.layoutButton.addTarget(self, action: #selector(layoutButtonDidTapped(_:)), for: .touchUpInside)
        rootView.organizeOptionView.filterButton.addTarget(self, action: #selector(filterButtonDidTapped(_:)), for: .touchUpInside)
    }
    // MARK: - Methods
    init(purchaseAPIService: PurchaseAPIService) {
        self.purchaseAPIService = purchaseAPIService
        super.init()
    }

    private func configTableView() {
        rootView.tableView.delegate = self
        rootView.tableView.dataSource = self
        rootView.tableView.registerCell(PurchaseBriefTableViewCell.self)
    }

    private func configCollectionView() {
        rootView.collectionView.delegate = self
        rootView.collectionView.dataSource = self
        rootView.collectionView.registerCellFormNib(for: PurchaseBriefCollectionViewCell.self)
    }

    private func fetchPurchaseList(purchaseListQueryInfo: PurchaseListQueryInfo? = nil) {
        isNetworkProcessing = true
        purchaseAPIService.fetchPurchaseList(purchaseListQueryInfo: purchaseListQueryInfo)
            .done { purchaseList in
                self.handleSuccessFetchPurchaseList(purchaseList)
            }
            .ensure {
                self.isNetworkProcessing = false
            }
            .catch(handleErrorForFetchPurchaseList(_:))
    }

    private func handleSuccessFetchPurchaseList(_ purchaseList: PurchaseList) {
        if self.purchaseList != nil {
            self.purchaseList?.updateWithNextPageList(purchaseList: purchaseList)
        } else {
            self.purchaseList = purchaseList
        }
        purchaseListQueryInfo.updateCurrentPageInfo(with: purchaseList)
        rootView.tableView.reloadData()
        rootView.collectionView.reloadData()
    }

    private func handleErrorForFetchPurchaseList(_ error: Error) {
        print(error.localizedDescription)
    }

    @objc
    private func layoutButtonDidTapped(_ sender: UIButton) {
        rootView.collectionView.isHidden.toggle()
        rootView.tableView.isHidden.toggle()
        let imageName = rootView.collectionView.isHidden ? "list" : "grid"
        sender.setImage(UIImage(named: imageName), for: .normal)
    }

    @objc
    private func filterButtonDidTapped(_ sender: UIButton) {
        let repository = PurchaseQueryRepository(currentQueryInfo: purchaseListQueryInfo, remoteAPIService: MyMindAutoCompleteAPIService.init(userSession: .testUserSession))
        let purchaseFilterViewController = PurchaseFilterViewController(purchaseQueryRepository: repository)
        let navigationController = UINavigationController(rootViewController: purchaseFilterViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
}
// MARK: - Scroll view delegate
extension PurchaseListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard isNetworkProcessing == false,
              let purchaseList = purchaseList
        else { return }

        let currentScrolledHeight = scrollView.frame.height + scrollView.contentOffset.y
        let currentScrolledPercentage = currentScrolledHeight / scrollView.contentSize.height
        let threshold: CGFloat = 0.8

        if currentScrolledPercentage > threshold,
           purchaseListQueryInfo.updatePageNumberForNextPage(with: purchaseList) {
            fetchPurchaseList(purchaseListQueryInfo: purchaseListQueryInfo)
        }
    }
}
// MARK: - Table view delegate
extension PurchaseListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return purchaseList?.items.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeReusableCell(PurchaseBriefTableViewCell.self, for: indexPath) as? PurchaseBriefTableViewCell else {
            fatalError("Worng cell identifier")
        }
        if let purchaseBrief = purchaseList?.items[indexPath.row] {
            cell.config(with: purchaseBrief)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
// MARK: - Collection view delegate
extension PurchaseListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return purchaseList?.items.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(PurchaseBriefCollectionViewCell.self, for: indexPath) as? PurchaseBriefCollectionViewCell else {
            fatalError("Please register cell first or wrong identifier")
        }
        if let purchaseBrief = purchaseList?.items[indexPath.item] {
            cell.config(with: purchaseBrief)
        }
        return cell
    }
}
// MARK: - Collection view flow layout
extension PurchaseListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var horizontalSpace: CGFloat = 0
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            horizontalSpace = layout.minimumLineSpacing + layout.sectionInset.left + layout.sectionInset.right
        }
        let width = (collectionView.frame.width - horizontalSpace) / 2
        return CGSize(width: width, height: 280)
    }
}
// MARK: - Purchase filter view controller delegate
extension PurchaseListViewController: PurchaseFilterViewControllerDelegate {
    func purchaseFilterViewController(_ purchaseFilterViewController: PurchaseFilterViewController, didConfirm queryInfo: PurchaseListQueryInfo) {
        fetchPurchaseList(purchaseListQueryInfo: queryInfo)
    }
}
