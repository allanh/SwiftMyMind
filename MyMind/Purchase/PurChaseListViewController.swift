//
//  PurChaseListViewController.swift
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
        fetchPurchaseList(with: "3")
        rootView.organizeOptionView.layoutButton.addTarget(self, action: #selector(layoutButtonDidTapped(_:)), for: .touchUpInside)
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

    private func fetchPurchaseList(
        with partherID: String,
        purchaseListQueryInfo: PurchaseListQueryInfo? = nil) {
        isNetworkProcessing = true
        purchaseAPIService.fetchPurchaseList(with: partherID, purchaseListQueryInfo: purchaseListQueryInfo) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let purchaseList):
                if self.purchaseList != nil {
                    self.purchaseList?.updateWithNextPageList(purchaseList: purchaseList)
                } else {
                    self.purchaseList = purchaseList
                }
                self.purchaseListQueryInfo.updateCurrentPageInfo(with: purchaseList)
                DispatchQueue.main.async {
                    self.rootView.tableView.reloadData()
                    self.rootView.collectionView.reloadData()
                    self.isNetworkProcessing = false
                }
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.isNetworkProcessing = false
                }
            }
        }
    }

    @objc
    private func layoutButtonDidTapped(_ sender: UIButton) {
        rootView.collectionView.isHidden.toggle()
        rootView.tableView.isHidden.toggle()
        let imageName = rootView.collectionView.isHidden ? "list" : "grid"
        sender.setImage(UIImage(named: imageName), for: .normal)
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
            fetchPurchaseList(with: purchaseListQueryInfo.partnerID, purchaseListQueryInfo: purchaseListQueryInfo)
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
