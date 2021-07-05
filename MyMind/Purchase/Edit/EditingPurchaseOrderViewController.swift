//
//  EditingPurchaseOrderViewController.swift
//  MyMind
//
//  Created by Barry Chen on 2021/6/28.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
import RxSwift

final class EditingPurchaseOrderViewController: NiblessViewController {

    var reviewing: Bool = false
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

    let saveButton: UIButton = UIButton {
        $0.backgroundColor = UIColor(hex: "004477")
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("儲存", for: .normal)
        $0.titleLabel?.font = .pingFangTCSemibold(ofSize: 16)
    }
    let agreeButton: UIButton = UIButton {
        $0.backgroundColor = UIColor(hex: "004477")
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("通過審核", for: .normal)
        $0.titleLabel?.font = .pingFangTCSemibold(ofSize: 16)
    }
    let disagreeButton: UIButton = UIButton {
        $0.backgroundColor = .white
        $0.setTitleColor(UIColor(hex: "004477"), for: .normal)
        $0.setTitle("審核退回", for: .normal)
        $0.titleLabel?.font = .pingFangTCSemibold(ofSize: 16)
        let topBorder = UIView(frame: CGRect(x: 0, y: 0, width: $0.frame.width, height: 1))
        topBorder.translatesAutoresizingMaskIntoConstraints = false
        topBorder.backgroundColor = UIColor(hex: "004477")
        $0.addSubview(topBorder)
        topBorder.topAnchor.constraint(equalTo: $0.topAnchor).isActive = true
        topBorder.leadingAnchor.constraint(equalTo: $0.leadingAnchor).isActive = true
        topBorder.heightAnchor.constraint(equalToConstant: 1).isActive = true
        topBorder.widthAnchor.constraint(equalTo: $0.widthAnchor).isActive = true
    }
    // MARK: - View life cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        title = reviewing ? "審核採購申請" :"編輯採購申請"
        view.backgroundColor = .systemBackground
        addTapToResignKeyboardGesture()
        constructViewHierarchy()
        activateConstraints()
        configCollectionView()
        subscribeViewModel()
        viewModel.loadPurchaseOrderThenMakeChildViewModels()
        if reviewing {
            agreeButton.addTarget(self, action: #selector(agreeButtonDidTapped(_:)), for: .touchUpInside)
            disagreeButton.addTarget(self, action: #selector(disagreeButtonDidTapped(_:)), for: .touchUpInside)
        } else {
            saveButton.addTarget(self, action: #selector(saveButtonDidTapped(_:)), for: .touchUpInside)
        }
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
    init(viewModel: EditingPurchaseOrderViewModel) {
        self.viewModel = viewModel
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
        if reviewing {
            view.addSubview(agreeButton)
            view.addSubview(disagreeButton)
        } else {
            view.addSubview(saveButton)
        }
    }

    private func activateConstraints() {
        activateConstraintsCollecitonView()
        if reviewing {
            activateConstraintsAgreeButton()
            activateConstraintsDisagreeButton()
        } else {
            activateConstraintsSaveButton()
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
        if reviewing {
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
    }

    private func navigation(with view: EditingPurchaseOrderViewModel.View) {
        switch view {
        case .purhcaseList:
            navigationController?.popViewController(animated: true)
        case .purchasedProducts(let viewModels):
            let viewModel = EditablePickedProductsInfoViewModel(pickedProductMaterialViewModels: viewModels)
            let viewController = EditablePickedProductsInfoViewController(viewModel: viewModel)
            show(viewController, sender: nil)
            break
        }
    }

    @objc
    private func saveButtonDidTapped(_ sender: UIButton) {
        viewModel.sendEditedRequest()
    }
    @objc
    private func agreeButtonDidTapped(_ sender: UIButton) {
        viewModel.sendEditedRequest()
    }
    @objc
    private func disagreeButtonDidTapped(_ sender: UIButton) {
        if let contentView = navigationController?.view {
            let alertView = CustomAlertView(frame: contentView.bounds, title: "確定撤回嗎？", descriptions: "撤回後，需要重新審核，是否確認撤回？")
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
            .constraint(equalTo: reviewing ? agreeButton.topAnchor: saveButton.topAnchor)
        let trailing = collectionView.trailingAnchor
            .constraint(equalTo: view.trailingAnchor)

        NSLayoutConstraint.activate([
            top, leading, bottom, trailing
        ])
    }

    private func activateConstraintsSaveButton() {
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        let leading = saveButton.leadingAnchor
            .constraint(equalTo: view.leadingAnchor)
        let trailing = saveButton.trailingAnchor
            .constraint(equalTo: view.trailingAnchor)
        let bottom = saveButton.bottomAnchor
            .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        let height = saveButton.heightAnchor
            .constraint(equalToConstant: 50)

        NSLayoutConstraint.activate([
            leading, trailing, bottom, height
        ])
    }
    private func activateConstraintsAgreeButton() {
        agreeButton.translatesAutoresizingMaskIntoConstraints = false
        let width = agreeButton.widthAnchor
            .constraint(equalTo: view.widthAnchor, multiplier: 0.5)
        let trailing = agreeButton.trailingAnchor
            .constraint(equalTo: view.trailingAnchor)
        let bottom = agreeButton.bottomAnchor
            .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        let height = agreeButton.heightAnchor
            .constraint(equalToConstant: 50)

        NSLayoutConstraint.activate([
            width, trailing, bottom, height
        ])
    }
    private func activateConstraintsDisagreeButton() {
        disagreeButton.translatesAutoresizingMaskIntoConstraints = false
        let leading = disagreeButton.leadingAnchor
            .constraint(equalTo: view.leadingAnchor)
        let width = disagreeButton.widthAnchor
            .constraint(equalTo: view.widthAnchor, multiplier: 0.5)
        let bottom = disagreeButton.bottomAnchor
            .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        let height = disagreeButton.heightAnchor
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
