//
//  PurchaseCompletedApplyViewController.swift
//  MyMind
//
//  Created by Chen Yi-Wei on 2021/6/22.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
import Accelerate

final class PurchaseCompletedApplyViewController: NiblessViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    // MARK: - Properties
    private var contentViewControllers: [UIViewController] = []

    let purchaseID: String
    let loader: PurchaseOrderLoader
    var purchaseOrder: PurchaseOrder?
    var isForRead: Bool = false
    let documentInteractionController: UIDocumentInteractionController = UIDocumentInteractionController()

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
        $0.setTitleColor(.prussianBlue, for: .normal)
        $0.setTitle("回首頁", for: .normal)
        $0.titleLabel?.font = .pingFangTCSemibold(ofSize: 16)
    }

    let backToListButton: UIButton = UIButton {
        $0.backgroundColor = .prussianBlue
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
        addCustomBackNavigationItem()
        navigationItem.backButtonTitle = ""
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

        backToHomeButton.addTarget(self, action: #selector(alternativeButtonDidTapped(_:)), for: .touchUpInside)
        backToListButton.addTarget(self, action: #selector(defaultButtonDidTapped(_:)), for: .touchUpInside)
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
                if order.type != .normal {
                    self.backToListButton.setTitle("匯出", for: .normal)
                    self.backToHomeButton.setTitle("返回", for: .normal)
                }
                self.collectionView.reloadData()
            }.catch { error in
                if let apiError = error as? APIError {
                    _ = ErrorHandler.shared.handle(apiError)
                } else {
                    _ = ErrorHandler.shared.handle(APIError.serviceError(error.localizedDescription))
                }
            }
    }
    private func openFile(_ url: URL) {
        documentInteractionController.delegate = self
        documentInteractionController.url = url
        documentInteractionController.uti = url.typeIdentifier ?? "public.data, public.content"
        documentInteractionController.name = url.localizedName ?? url.lastPathComponent
        documentInteractionController.presentPreview(animated: true)
    }
    private func exportPurchaseOrder() {
        let documentFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let mymindFolder = documentFolder.appendingPathComponent("MyMind")
        print(mymindFolder.path)
        if !FileManager.default.fileExists(atPath: mymindFolder.path) {
            do {
                try FileManager.default.createDirectory(at: mymindFolder, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("create folder fail")
            }
        }
        let url = mymindFolder.appendingPathComponent("\(purchaseOrder?.number ?? "")-\(purchaseID)").appendingPathExtension("xls")
        if FileManager.default.fileExists(atPath: url.path) {
            openFile(url)
        } else {
            startAnimatingActivityIndicator()
            loader.exportPurchaseOrder(for: ExportInfo(ids: [purchaseID], type: .purchase, remark: nil))
                .ensure { [weak self] in
                    self?.stopAnimatinActivityIndicator()
                }
                .done { result in
                   print(url.path)
                    do {
                        try result.write(to: url)
                        self.openFile(url)
                   } catch let error {
                        print(error.localizedDescription)
                    }
                }
                .catch { error in
                    if let apiError = error as? APIError {
                        _ = ErrorHandler.shared.handle(apiError)
                    } else {
                        _ = ErrorHandler.shared.handle(APIError.serviceError(error.localizedDescription))
                    }
                }
        }
    }
    private func generateContentViewControllers(with purchaseOrder: PurchaseOrder) {
        let purchaseOrderInfoViewController = PurchaseOrderInfoViewController.loadFormNib()
        purchaseOrderInfoViewController.purchaseOrder = purchaseOrder
        purchaseOrderInfoViewController.didTapCheckPurchasedProductButton = { [weak self] in
            let viewController = PurchasedProductsInfoViewController()//PurchasedProductsInfoViewController(style: .plain)
            viewController.productInfos = purchaseOrder.productInfos
            self?.show(viewController, sender: nil)
        }
        contentViewControllers.append(purchaseOrderInfoViewController)

        let purchaseLogInfoViewController = PurchaseLogInfoViewController.loadFormNib()
        purchaseLogInfoViewController.logInfos = purchaseOrder.logInfos
        contentViewControllers.append(purchaseLogInfoViewController)
    }

    @objc
    private func alternativeButtonDidTapped(_ sender: UIButton) {
        if let type = purchaseOrder?.type {
            if type == .normal {
                if let viewControllers = navigationController?.viewControllers, viewControllers.count > 2 {
                    navigationController?.popToViewController(viewControllers[1], animated: true)
                }
            } else {
                navigationController?.popViewController(animated: true)
            }
        }
    }

    @objc
    private func defaultButtonDidTapped(_ sender: UIButton) {
        if let type = purchaseOrder?.type {
            if type == .normal {
                if let viewControllers = navigationController?.viewControllers, viewControllers.count > 3 {
                    navigationController?.popToViewController(viewControllers[2], animated: true)
                }
            } else {
                exportPurchaseOrder()
            }
        }
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
            return CGSize(width: view.frame.width, height: 100)
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
extension PurchaseCompletedApplyViewController: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
           guard let navVC = self.navigationController else {
               return self
           }
           return navVC
       }
}
extension URL {
    var typeIdentifier: String? {
        return (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier
    }
    var localizedName: String? {
        return (try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName
    }
}
