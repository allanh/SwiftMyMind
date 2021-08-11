//
//  EditingPurchaseOrderViewController.swift
//  MyMind
//
//  Created by Barry Chen on 2021/6/28.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
import RxSwift

protocol EditingPurchaseOrderViewControllerDelegate: AnyObject {
    func didFinished(_ success: Bool)
}
final class EditingPurchaseOrderViewController: NiblessViewController {

    weak var delegate: EditingPurchaseOrderViewControllerDelegate?
    let reviewing: Bool
    let viewModel: EditingPurchaseOrderViewModel

    let bag: DisposeBag = DisposeBag()

    var contentViewControllers: [UIViewController] = []

    // MARK: UI
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let screenWidth = UIScreen.main.bounds.width
        let horizontalInset: CGFloat = 20
        layout.sectionInset = UIEdgeInsets(top: 15, left: horizontalInset, bottom: 15, right: horizontalInset)
        let collecitonView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collecitonView.backgroundColor = .systemBackground
        return collecitonView
    }()

    let defaultButton: UIButton = UIButton {
        $0.backgroundColor = UIColor(hex: "004477")
        $0.setTitleColor(.white, for: .normal)
//        $0.setTitle("撒回", for: .normal)
        $0.titleLabel?.font = .pingFangTCSemibold(ofSize: 16)
    }
    let alternativeButton: UIButton = UIButton {
        $0.backgroundColor = .white
        $0.setTitleColor(UIColor(hex: "004477"), for: .normal)
//        $0.setTitle("返回", for: .normal)
        $0.titleLabel?.font = .pingFangTCSemibold(ofSize: 16)
        let topBorder = UIView(frame: CGRect(x: 0, y: 0, width: $0.frame.width, height: 1))
        topBorder.translatesAutoresizingMaskIntoConstraints = false
        topBorder.backgroundColor = UIColor(hex: "004477")
        $0.addSubview(topBorder)
        topBorder.topAnchor.constraint(equalTo: $0.topAnchor).isActive = true
        topBorder.leadingAnchor.constraint(equalTo: $0.leadingAnchor).isActive = true
        topBorder.heightAnchor.constraint(equalToConstant: 1).isActive = true
        topBorder.widthAnchor.constraint(equalTo: $0.widthAnchor).isActive = true    }
//    let agreeButton: UIButton = UIButton {
//        $0.backgroundColor = UIColor(hex: "004477")
//        $0.setTitleColor(.white, for: .normal)
//        $0.setTitle("通過審核", for: .normal)
//        $0.titleLabel?.font = .pingFangTCSemibold(ofSize: 16)
//    }
//    let disagreeButton: UIButton = UIButton {
//        $0.backgroundColor = .white
//        $0.setTitleColor(UIColor(hex: "004477"), for: .normal)
//        $0.setTitle("審核退回", for: .normal)
//        $0.titleLabel?.font = .pingFangTCSemibold(ofSize: 16)
//        let topBorder = UIView(frame: CGRect(x: 0, y: 0, width: $0.frame.width, height: 1))
//        topBorder.translatesAutoresizingMaskIntoConstraints = false
//        topBorder.backgroundColor = UIColor(hex: "004477")
//        $0.addSubview(topBorder)
//        topBorder.topAnchor.constraint(equalTo: $0.topAnchor).isActive = true
//        topBorder.leadingAnchor.constraint(equalTo: $0.leadingAnchor).isActive = true
//        topBorder.heightAnchor.constraint(equalToConstant: 1).isActive = true
//        topBorder.widthAnchor.constraint(equalTo: $0.widthAnchor).isActive = true
//    }
    // MARK: - View life cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.backButtonTitle = ""
        title = reviewing ? "審核採購申請" :"編輯採購申請"
        view.backgroundColor = .systemBackground
        addTapToResignKeyboardGesture()
        constructViewHierarchy()
        activateConstraints()
        configCollectionView()
        subscribeViewModel()
        viewModel.loadPurchaseOrderThenMakeChildViewModels()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardObservers()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        removeObservers()
    }
    // MARK: - Methods
    init(viewModel: EditingPurchaseOrderViewModel, reviewing: Bool, delegate: EditingPurchaseOrderViewControllerDelegate? = nil) {
        self.viewModel = viewModel
        self.reviewing = reviewing
        self.delegate = delegate
        super.init()
    }

    private func subscribeViewModel() {
        viewModel.didFinishMakeChildViewModels = { [weak self] in
            self?.generateContentViewControllers()
            self?.collectionView.reloadData()
        }

        viewModel.isNetworkProcessing
            .skip(1)
            .bind(to: rx.isActivityIndicatorAnimating)
            .disposed(by: bag)

        viewModel.view
            .subscribe(onNext: navigation(with:))
            .disposed(by: bag)
    }

    private func constructViewHierarchy() {
        view.addSubview(collectionView)
        if viewModel.status != .approved {
            view.addSubview(defaultButton)
            view.addSubview(alternativeButton)
        }
    }

    private func activateConstraints() {
        activateConstraintsCollecitonView()
        if viewModel.status != .approved {
            activateConstraintsDefaultButton()
            activateConstraintsAlternativeButton()
        }
    }

    private func configCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerCell(ContainerCollectionViewCell.self)
    }

    private func generateContentViewControllers() {
        guard let purchaseApplyInfoViewModel = viewModel.purchaseApplyInfoViewModel,
              let pickPurchaseReviewerViewModel = viewModel.pickPurchaseReviewerViewModel
        else {
            return
        }
        if reviewing || !viewModel.editable {
            let purchaseReviewingApplyInfoViewController = PurchaseReviewingApplyInfoViewController.loadFormNib()
            purchaseReviewingApplyInfoViewController.viewModel = purchaseApplyInfoViewModel
            contentViewControllers.append(purchaseReviewingApplyInfoViewController)
        } else {
            let purchaseApplyInfoViewController = PurchaseApplyInfoViewController.loadFormNib()
            purchaseApplyInfoViewController.viewModel = purchaseApplyInfoViewModel
            contentViewControllers.append(purchaseApplyInfoViewController)
        }
        let pickPurchaseReviewerViewController = PickPurchaseReviewerViewController.loadFormNib()
        pickPurchaseReviewerViewController.viewModel = pickPurchaseReviewerViewModel
        contentViewControllers.append(pickPurchaseReviewerViewController)
        if reviewing {
            // approve, return
            defaultButton.setTitle("通過審核", for: .normal)
            alternativeButton.setTitle("審核退回", for: .normal)
            defaultButton.addTarget(self, action: #selector(agreeButtonDidTapped(_:)), for: .touchUpInside)
            alternativeButton.addTarget(self, action: #selector(disagreeButtonDidTapped(_:)), for: .touchUpInside)
        } else {
            if viewModel.editable {
                // save, void
                defaultButton.setTitle("儲存", for: .normal)
                alternativeButton.setTitle("作廢此單", for: .normal)
                defaultButton.addTarget(self, action: #selector(saveButtonDidTapped(_:)), for: .touchUpInside)
                alternativeButton.addTarget(self, action: #selector(invalidButtonDidTapped(_:)), for: .touchUpInside)
            } else {
                if purchaseApplyInfoViewModel.purchaseStatus.value == .approved {
                    defaultButton.isHidden = true
                    alternativeButton.isHidden = true
                } else {
                    // revoke, cancel
                    defaultButton.setTitle("撤回", for: .normal)
                    alternativeButton.setTitle("取消", for: .normal)
                    defaultButton.addTarget(self, action: #selector(revokeButtonDidTapped(_:)), for: .touchUpInside)
                    alternativeButton.addTarget(self, action: #selector(cancelButtonDidTapped(_:)), for: .touchUpInside)
                }
            }
        }
    }

    private func navigation(with view: EditingPurchaseOrderViewModel.View) {
        switch view {
        case .purhcaseList:
            navigationController?.popViewController(animated: true)
            delegate?.didFinished(true)
        case .purchasedProducts(let viewModels):
            let viewModel = EditablePickedProductsInfoViewModel(pickedProductMaterialViewModels: viewModels)
            let viewController = EditablePickedProductsInfoViewController(viewModel: viewModel)
            show(viewController, sender: nil)
            break
        case .purchasedProductInfos(let infos):
            let viewController = PurchasedProductsInfoViewController(style: .plain)
            viewController.productInfos = infos
            show(viewController, sender: nil)
        case .error(let error):
            if let apiError = error as? APIError {
                _ = ErrorHandler.shared.handle(apiError)
            } else {
                ToastView.showIn(self, message: error.localizedDescription)
            }
        }
    }

    @objc
    private func saveButtonDidTapped(_ sender: UIButton) {
        let expectStorageDate = viewModel.purchaseApplyInfoViewModel?.expectedStorageDate.value ?? Date()
        let days = Calendar.current.dateComponents([.day], from: Date(), to: expectStorageDate).day ?? 0
        if days < 3 {
            let alertController = UIAlertController(title: "確定申請?", message: "預計入庫日距離今日小於 3 天，請確定是否送出申請。", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel) { action in
            }
            let confirmAction = UIAlertAction(title: "確定", style: .default) { [weak self] action in
                self?.viewModel.sendEditedRequest()
            }
            alertController.addAction(cancelAction)
            alertController.addAction(confirmAction)
            present(alertController, animated: true, completion: nil)
        } else {
            viewModel.sendEditedRequest()
        }
    }
    @objc
    private func cancelButtonDidTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    @objc
    private func revokeButtonDidTapped(_ sender: UIButton) {
        if let contentView = navigationController?.view {
            let alertView = CustomAlertView(frame: contentView.bounds, title: "確定撤回嗎？", descriptions: "撤回後，需要重新審核，是否確認撤回？")
            alertView.confirmButton.addAction { [weak self] in
                guard let self = self else { return }
                alertView.removeFromSuperview()
                self.viewModel.sendRevokeRequest()
            }
            alertView.cancelButton.addAction {
                alertView.removeFromSuperview()
            }
            contentView.addSubview(alertView)
        }
    }
    @objc
    private func invalidButtonDidTapped(_ sender: UIButton) {
        if let contentView = navigationController?.view {
            let alertView = CustomAlertView(frame: contentView.bounds, title: "確定作廢嗎？", descriptions: "作廢後，需要重新申請，是否確認作廢？")
            alertView.confirmButton.addAction { [weak self] in
                guard let self = self else { return }
                alertView.removeFromSuperview()
                self.viewModel.sendInvalidRequest()
            }
            alertView.cancelButton.addAction {
                alertView.removeFromSuperview()
            }
            contentView.addSubview(alertView)
        }
    }

    @objc
    private func agreeButtonDidTapped(_ sender: UIButton) {
        viewModel.sendEditedRequest()
    }
    @objc
    private func disagreeButtonDidTapped(_ sender: UIButton) {
        if let contentView = navigationController?.view {
            let alertView = CustomAlertView(frame: contentView.bounds, title: "確定退回嗎？", descriptions: "退回後，需要重新審核，是否確認退回？")
            alertView.confirmButton.addAction { [weak self] in
                guard let self = self else { return }
                alertView.removeFromSuperview()
                self.viewModel.sendReturnRequest()
            }
            alertView.cancelButton.addAction {
                alertView.removeFromSuperview()
            }
            contentView.addSubview(alertView)
        }
    }
}
// MARK: - Collection view data source
extension EditingPurchaseOrderViewController: UICollectionViewDataSource {
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
extension EditingPurchaseOrderViewController: UICollectionViewDelegateFlowLayout {
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
extension EditingPurchaseOrderViewController {
    private func activateConstraintsCollecitonView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let top = collectionView.topAnchor
            .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let leading = collectionView.leadingAnchor
            .constraint(equalTo: view.leadingAnchor)
        let bottom = collectionView.bottomAnchor
            .constraint(equalTo: (viewModel.status == .approved) ? view.bottomAnchor : defaultButton.topAnchor)
        let trailing = collectionView.trailingAnchor
            .constraint(equalTo: view.trailingAnchor)

        NSLayoutConstraint.activate([
            top, leading, bottom, trailing
        ])
    }

    private func activateConstraintsDefaultButton() {
        defaultButton.translatesAutoresizingMaskIntoConstraints = false
        let width = defaultButton.widthAnchor
            .constraint(equalTo: view.widthAnchor, multiplier: 0.5)
        let trailing = defaultButton.trailingAnchor
            .constraint(equalTo: view.trailingAnchor)
        let bottom = defaultButton.bottomAnchor
            .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        let height = defaultButton.heightAnchor
            .constraint(equalToConstant: 50)

        NSLayoutConstraint.activate([
            width, trailing, bottom, height
        ])
    }
    private func activateConstraintsAlternativeButton() {
        alternativeButton.translatesAutoresizingMaskIntoConstraints = false
        let leading = alternativeButton.leadingAnchor
            .constraint(equalTo: view.leadingAnchor)
        let width = alternativeButton.widthAnchor
            .constraint(equalTo: view.widthAnchor, multiplier: 0.5)
        let bottom = alternativeButton.bottomAnchor
            .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        let height = alternativeButton.heightAnchor
            .constraint(equalToConstant: 50)

        NSLayoutConstraint.activate([
            leading, width, bottom, height
        ])
    }
}
// MARK: - Keyboard handle
extension EditingPurchaseOrderViewController {
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
                collectionView.contentInset.bottom = .zero
            } else {
                var insets = collectionView.contentInset
                insets.bottom = convertedKeyboardEndFrame.height
                collectionView.contentInset = insets
            }
        }
    }
}
