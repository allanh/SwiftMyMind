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

enum PurchaseQueryType: String, CustomStringConvertible, CaseIterable {
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

        addChildViewControllers()
        configViewForChildViewControllers()
    }

    private func configViewForChildViewControllers() {
        var lastChildView: UIView?
        for index in 0..<children.count {
            guard let childView = children[index].view else { return }
            childView.translatesAutoresizingMaskIntoConstraints = false
            childView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
            childView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
            if index == 0 {
                childView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
            }
            if let lastView = lastChildView {
                childView.topAnchor.constraint(equalTo: lastView.bottomAnchor).isActive = true
            }
            if index == children.count - 1 {
               childView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
            }
            lastChildView = childView
        }
    }

    private func addChildViewControllers() {
        let allCases = PurchaseQueryType.allCases
        allCases.forEach {
            switch $0 {
            case .purchaseStatus:
                let viewController = PurchaseStatusSelectionViewController(purchaseQueryRepository: purchaseQueryRepository)
                contentView.addSubview(viewController.view)
                addChild(viewController)
                viewController.didMove(toParent: self)
            case .createdPeriod, .expectPutInStoragePeriod:
                let viewController = PurchaseQueryDateSelectionViewController(purchaseQueryRepository: purchaseQueryRepository, purchaseQueryType: $0)
                contentView.addSubview(viewController.view)
                addChild(viewController)
                viewController.didMove(toParent: self)
            default:
                generateAutoCompleteSearchViewController(with: $0)
            }
        }
    }

    private func generateAutoCompleteSearchViewController(with purchaseQueryType: PurchaseQueryType) {
        let viewController = PurchaseAutoCompleteSearchViewController(purchaseQueryType: purchaseQueryType, purchaseQueryRepository: purchaseQueryRepository)
        contentView.addSubview(viewController.view)
        addChild(viewController)
        viewController.didMove(toParent: self)
    }

    private func constructViewHierarchy() {
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
        view.addSubview(bottomView)
    }

    private func activateConstraints() {
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
}
// MARK: - Layouts
extension PurchaseFilterViewController {
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
