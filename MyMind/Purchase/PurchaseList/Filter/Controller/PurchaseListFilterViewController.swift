//
//  PurchaseListFilterViewController.swift
//  MyMind
//
//  Created by Barry Chen on 2021/5/6.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
import PromiseKit
import RxSwift
import RxRelay

enum PurchaseQueryType: String, CustomStringConvertible, CaseIterable {
    case purchaseNumber, vendorID, purchaseStatus, applicant, productNumbers, brandName, expectPutInStoragePeriod, createdPeriod
    var description: String {
        switch self {
        case .purchaseNumber: return "採購單編號"
        case .vendorID: return "供應商"
        case .purchaseStatus: return "採購單狀態"
        case .applicant: return "申請人"
        case .productNumbers: return "商品編號"
        case .expectPutInStoragePeriod: return "預計入庫日"
        case .createdPeriod: return "填單日期"
        case .brandName: return "品牌"
        }
    }
}

class PurchaseListFilterViewController: NiblessViewController {
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

    let viewModel: PurchaseListFilterViewModel

    init(viewModel: PurchaseListFilterViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.title
        view.backgroundColor = .white
        addTapToResignKeyboardGesture()
        constructViewHierarchy()
        activateConstraints()
        configNavigtaionBar()

        addChildViewControllers()
        configViewForChildViewControllers()
        configBottomView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardObservers()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
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
            case .purchaseNumber:
                addAutoSearchViewCotrollerAsChild(with: viewModel.purchaseNumberViewModel)
            case .vendorID:
                addAutoSearchViewCotrollerAsChild(with: viewModel.vendorViewModel)
            case .applicant:
                addAutoSearchViewCotrollerAsChild(with: viewModel.applicantViewModel)
            case .productNumbers:
                addAutoSearchViewCotrollerAsChild(with: viewModel.productNumberViewModel)
            case .purchaseStatus:
                let viewController = PurchaseStatusSelectionViewController(viewModel: viewModel.purchaseStatusViewModel)
                addViewControllerAsChild(viewController)
            case .createdPeriod:
                let viewController = PurchaseQueryDateSelectionViewController(viewModel: viewModel.expectPutInStoragePeriodViewModel)
                addViewControllerAsChild(viewController)
            case .expectPutInStoragePeriod:
                let viewController = PurchaseQueryDateSelectionViewController(viewModel: viewModel.creatPeriodViewModel)
                addViewControllerAsChild(viewController)
            case .brandName:
                addAutoSearchViewCotrollerAsChild(with: viewModel.brandNameViewModel)
            }
        }
    }

    private func addViewControllerAsChild(_ viewController: UIViewController) {
        contentView.addSubview(viewController.view)
        addChild(viewController)
        viewController.didMove(toParent: self)
    }

    private func addAutoSearchViewCotrollerAsChild(with viewModel: AutoCompleteSearchViewModel) {
        let viewController = AutoCompleteSearchViewController(viewModel: viewModel)
        addViewControllerAsChild(viewController)
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

    private func configBottomView() {
        bottomView.confirmButton.addTarget(self, action: #selector(confirmButtonDidTapped(_:)), for: .touchUpInside)
        bottomView.cancelButton.addTarget(self, action: #selector(cleanButtonDidTapped(_:)), for: .touchUpInside)
    }

    @objc
    private func confirmButtonDidTapped(_ sender: UIButton) {
        viewModel.didUpdateQueryInfo(viewModel.queryInfo)
        dismiss(animated: true, completion: nil)
    }

    @objc
    private func cleanButtonDidTapped(_ sender: UIButton) {
        viewModel.cleanQueryInfo()
    }

    @objc
    private func closeButtonDidTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
// MARK: - Layouts
extension PurchaseListFilterViewController {
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
// MARK: - Keyboard handle
extension PurchaseListFilterViewController {
    func addKeyboardObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(handleContentUnderKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(handleContentUnderKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    func removeObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }

    @objc func handleContentUnderKeyboard(notification: Notification) {
        if let userInfo = notification.userInfo,
           let keyboardEndFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let convertedKeyboardEndFrame = view.convert(keyboardEndFrame.cgRectValue, from: view.window)
            if notification.name == UIResponder.keyboardWillHideNotification {
                scrollView.contentInset.bottom = .zero
            } else {
                var insets = scrollView.contentInset
                insets.bottom = convertedKeyboardEndFrame.height + 150
                scrollView.contentInset = insets
            }
        }
    }
}
