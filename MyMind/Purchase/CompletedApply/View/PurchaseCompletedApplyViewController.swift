//
//  PurchaseCompletedApplyViewController.swift
//  MyMind
//
//  Created by Chen Yi-Wei on 2021/6/22.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

final class PurchaseCompletedApplyViewController: NiblessViewController {
    // MARK: - Properties
    private var contentViewControllers: [UIViewController] = []

    let purchaseID: String
    let loader: PurchaseOrderLoader
    var purchaseOrder: PurchaseOrder?
    var isForRead: Bool = false

    // MARK: UI
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionHeadersPinToVisibleBounds = true

        let horizontalInset: CGFloat = 20
        layout.sectionInset = UIEdgeInsets(top: 15, left: horizontalInset, bottom: 15, right: horizontalInset)

        let collecitonView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collecitonView.backgroundColor = .white
        collecitonView.allowsSelection = false
        return collecitonView
    }()

    let backToHomeButton: UIButton = UIButton {
        $0.backgroundColor = .white
        $0.setTitleColor(UIColor(hex: "004477"), for: .normal)
        $0.setTitle("回首頁", for: .normal)
        $0.titleLabel?.font = .pingFangTCSemibold(ofSize: 16)
    }

    let backToListButton: UIButton = UIButton {
        $0.backgroundColor = UIColor(hex: "004477")
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("回採購管理", for: .normal)
        $0.titleLabel?.font = .pingFangTCSemibold(ofSize: 16)
    }

    let buttonsStackView: UIStackView = UIStackView {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
    }

    let bottomBorderView: UIView = UIView {
        $0.backgroundColor = .separator
    }

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        constructViewHierarchy()
        activateConstraints()
        configCollectionView()
        configureButtons()
        loadPurchaseOrder()
    }
    // MARK: - Methods
    init(purchaseID: String, loader: PurchaseOrderLoader) {
        self.purchaseID = purchaseID
        self.loader = loader
        super.init()
    }

    private func constructViewHierarchy() {
        view.addSubview(collectionView)
        guard isForRead == false else { return }

        buttonsStackView.addArrangedSubview(backToHomeButton)
        buttonsStackView.addArrangedSubview(backToListButton)
        view.addSubview(buttonsStackView)
        view.addSubview(bottomBorderView)
    }

    private func activateConstraints() {
        activateConstraintsCollecitonView()
        guard isForRead == false else { return }

        activateConstraintsStackView()
        activateConstraintsBottomBorderView()
    }

    private func configCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerCell(ContainerCollectionViewCell.self)
        collectionView.register(StageProgressCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: StageProgressCollectionReusableView.self))
    }

    private func configureButtons() {
        guard isForRead == false else { return }

        backToHomeButton.addTarget(self, action: #selector(backToHomeButtonDidTapped(_:)), for: .touchUpInside)
        backToListButton.addTarget(self, action: #selector(backToListButtonDidTapped(_:)), for: .touchUpInside)
    }

    private func loadPurchaseOrder() {
        startAnimatingActivityIndicator()
        loader.loadPurchaseOrder(with: purchaseID)
            .ensure {
                self.stopAnimatinActivityIndicator()
            }
            .done { [weak self] order in
                guard let self = self else { return }
                self.purchaseOrder = order
                self.generateContentViewControllers(with: order)
                self.collectionView.reloadData()
            }.catch { error in
                if let apiError = error as? APIError {
                    _ = ErrorHandler.shared.handle(apiError, controller: self)
                } else {
                    ToastView.showIn(self, message: error.localizedDescription)
                }
            }
    }

    private func generateContentViewControllers(with purchaseOrder: PurchaseOrder) {
        let purchaseOrderInfoViewController = PurchaseOrderInfoViewController.loadFormNib()
        purchaseOrderInfoViewController.purchaseOrder = purchaseOrder
        purchaseOrderInfoViewController.didTapCheckPurchasedProductButton = { [weak self] in
            let viewController = PurchasedProductsInfoViewController(style: .plain)
            viewController.productInfos = purchaseOrder.productInfos
            self?.show(viewController, sender: nil)
        }
        contentViewControllers.append(purchaseOrderInfoViewController)

        let purchaseLogInfoViewController = PurchaseLogInfoViewController.loadFormNib()
        purchaseLogInfoViewController.logInfos = purchaseOrder.logInfos
        contentViewControllers.append(purchaseLogInfoViewController)
    }

    @objc
    private func backToHomeButtonDidTapped(_ sender: UIButton) {

    }

    @objc
    private func backToListButtonDidTapped(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
}
// MARK: - Collection view data source
extension PurchaseCompletedApplyViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentViewControllers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(ContainerCollectionViewCell.self, for: indexPath) as? ContainerCollectionViewCell else {
            print("Wrong cell identifier or not register yet")
            return UICollectionViewCell()
        }
        let viewController = contentViewControllers[indexPath.item]
        cell.hostedView = viewController.view

        return cell
    }
}
// MARK: - Collection view delegate flow layout
extension PurchaseCompletedApplyViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: StageProgressCollectionReusableView.self), for: indexPath)
        view.backgroundColor = .white
        (view as? StageProgressCollectionReusableView)?.configProgressView(numberOfStage: 3, stageTitleList: ["採購建議", "採購申請", "送出審核"], currentStageIndex: 2)
        return view
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if isForRead {
            return .zero
        } else {
            return CGSize(width: view.frame.width, height: 125)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        var horizontalInsets: CGFloat = .zero
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            horizontalInsets = flowLayout.sectionInset.left + flowLayout.sectionInset.right
        }

        let width = screenWidth - horizontalInsets
        let viewController = contentViewControllers[indexPath.item]
        let height = viewController.view.systemLayoutSizeFitting(CGSize(width: width, height: 0), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel).height

        return CGSize(width: width, height: height)
    }
}
// MARK: - Layouts
extension PurchaseCompletedApplyViewController {
    private func activateConstraintsCollecitonView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let top = collectionView.topAnchor
            .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let leading = collectionView.leadingAnchor
            .constraint(equalTo: view.leadingAnchor)

        let bottom: NSLayoutConstraint
        if isForRead {
            bottom = collectionView.bottomAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        } else {
            bottom = collectionView.bottomAnchor
                .constraint(equalTo: buttonsStackView.topAnchor)
        }

        let trailing = collectionView.trailingAnchor
            .constraint(equalTo: view.trailingAnchor)

        NSLayoutConstraint.activate([
            top, leading, bottom, trailing
        ])
    }

    private func activateConstraintsStackView() {
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        let leading = buttonsStackView.leadingAnchor
            .constraint(equalTo: view.leadingAnchor)
        let trailing = buttonsStackView.trailingAnchor
            .constraint(equalTo: view.trailingAnchor)
        let bottom = buttonsStackView.bottomAnchor
            .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        let height = buttonsStackView.heightAnchor
            .constraint(equalToConstant: 50)

        NSLayoutConstraint.activate([
            leading, trailing, bottom, height
        ])
    }

    private func activateConstraintsBottomBorderView() {
        bottomBorderView.translatesAutoresizingMaskIntoConstraints = false
        let leading = bottomBorderView.leadingAnchor
            .constraint(equalTo: view.leadingAnchor)
        let trailing = bottomBorderView.trailingAnchor
            .constraint(equalTo: view.trailingAnchor)
        let bottom = bottomBorderView.bottomAnchor
            .constraint(equalTo: buttonsStackView.topAnchor)
        let height = bottomBorderView.heightAnchor
            .constraint(equalToConstant: 1)

        NSLayoutConstraint.activate([
            leading, trailing, bottom, height
        ])
    }
}
