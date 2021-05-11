//
//  PurchaseFilterViewController.swift
//  MyMind
//
//  Created by Barry Chen on 2021/5/6.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
import PromiseKit

protocol PurchaseFilterViewControllerDelegate: AnyObject {
    func purchaseFilterViewController(_ purchaseFilterViewController: PurchaseFilterViewController, didConfirm queryInfo: PurchaseListQueryInfo)
}

enum PurchaseQueryType: String, CustomStringConvertible {
    case purchaseNumber, vendorID, purchaseStatus, applicant, productNumbers, expectPutInStoragePeriod, createdPeriod
    var description: String {
        switch self {
        case .purchaseNumber: return "採購單編號"
        case .vendorID: return "供應商"
        case .purchaseStatus: return "採購單狀態"
        case .applicant: return "申請人"
        case .productNumbers: return "商品編號"
        case .expectPutInStoragePeriod: return "預計入庫日"
        case .createdPeriod: return "填單日期"
        }
    }
}

class PurchaseFilterViewController: NiblessViewController {

//    private let topBarView: SideMenuTopBarView = SideMenuTopBarView {
//        $0.backgroundColor = .white
//    }

    private let scrollView: UIScrollView = UIScrollView {
        $0.backgroundColor = .white
        $0.showsHorizontalScrollIndicator = false
    }

    private let contentView: UIView = UIView {
        $0.backgroundColor = .white
    }

    private let bottomView: FilterSideMenuBottomView = FilterSideMenuBottomView {
        $0.backgroundColor = .white
    }

    weak var delegate: PurchaseFilterViewControllerDelegate?

    let purchaseAutoCompleteAPIService: PurchaseAutoCompleteAPIService = MyMindAutoCompleteAPIService(userSession: .testUserSession)

    var autoCompleteSource: [PurchaseQueryType: [AutoCompleteInfo]] = [:]

    let purchaseQueryRepository: PurchaseQueryRepository

    init(purchaseQueryRepository: PurchaseQueryRepository) {
        self.purchaseQueryRepository = purchaseQueryRepository
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addTapToResignKeyboardGesture()
        constructViewHierarchy()
        activateConstraints()
        configNavigtaionBar()
        purchaseQueryRepository.updateAutoCompleteSourceFromRemote()

        let vc = PurchaseAutoCompleteSearchViewController(purchaseQueryType: .purchaseNumber, purchaseQueryRepository: purchaseQueryRepository)
        contentView.addSubview(vc.view)
        addChild(vc)
        vc.didMove(toParent: self)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vc.view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            vc.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            vc.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            vc.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    private func constructViewHierarchy() {
//        view.addSubview(topBarView)
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
        view.addSubview(bottomView)
    }

    private func activateConstraints() {
        activateConstraintsTopBarView()
        activateConstraintsBottomView()
        activateConstraintsScrollView()
        activateConstraintsContentView()
    }

    private func configNavigtaionBar() {
        navigationItem.title = "篩選條件"
        let closeButton = UIButton()
        closeButton.setImage(UIImage(named: "close"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonDidTapped(_:)), for: .touchUpInside)
        let barItem = UIBarButtonItem(customView: closeButton)
        navigationItem.setRightBarButton(barItem, animated: true)
    }

    @objc
    private func closeButtonDidTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    private func fetchAllAutoCompleteList() {

    }
}
// MARK: - Layouts
extension PurchaseFilterViewController {
    private func activateConstraintsTopBarView() {
//        topBarView.translatesAutoresizingMaskIntoConstraints = false
//
//        let leading = topBarView.leadingAnchor
//            .constraint(equalTo: view.leadingAnchor)
//        let top = topBarView.topAnchor
//            .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
//        let trailing = topBarView.trailingAnchor
//            .constraint(equalTo: view.trailingAnchor)
//        let height = topBarView.heightAnchor
//            .constraint(equalToConstant: 44)

//        NSLayoutConstraint.activate([
//            leading, top, trailing, height
//        ])
    }

    private func activateConstraintsBottomView() {
        bottomView.translatesAutoresizingMaskIntoConstraints = false

        let leading = bottomView.leadingAnchor
            .constraint(equalTo: view.leadingAnchor)
        let bottom = bottomView.bottomAnchor
            .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        let trailing = bottomView.trailingAnchor
            .constraint(equalTo: view.trailingAnchor)
        let height = bottomView.heightAnchor
            .constraint(equalToConstant: 50)

        NSLayoutConstraint.activate([
            leading, bottom, trailing, height
        ])
    }

    private func activateConstraintsScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        let top = scrollView.topAnchor
            .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let leading = scrollView.leadingAnchor
            .constraint(equalTo: view.leadingAnchor)
        let trailing = scrollView.trailingAnchor
            .constraint(equalTo: view.trailingAnchor)
        let bottom = scrollView.bottomAnchor
            .constraint(equalTo: bottomView.topAnchor)

        NSLayoutConstraint.activate([
            top, leading, trailing, bottom
        ])
    }

    private func activateConstraintsContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        let top = contentView.topAnchor
            .constraint(equalTo: scrollView.topAnchor)
        let leading = contentView.leadingAnchor
            .constraint(equalTo: scrollView.leadingAnchor)
        let bottom = contentView.bottomAnchor
            .constraint(equalTo: scrollView.bottomAnchor)
        let trailing = contentView.trailingAnchor
            .constraint(equalTo: scrollView.trailingAnchor)
        let width = contentView.widthAnchor
            .constraint(equalTo: scrollView.widthAnchor)

        NSLayoutConstraint.activate([
            top, leading, bottom, trailing, width
        ])
    }
}
