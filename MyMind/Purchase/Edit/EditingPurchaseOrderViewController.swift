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
        collecitonView.backgroundColor = .white
        return collecitonView
    }()

    let saveButton: UIButton = UIButton {
        $0.backgroundColor = UIColor(hex: "004477")
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("儲存", for: .normal)
        $0.titleLabel?.font = .pingFangTCSemibold(ofSize: 16)
    }
    // MARK: - View life cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "編輯採購申請"
        view.backgroundColor = .white
        addTapToResignKeyboardGesture()
        constructViewHierarchy()
        activateConstraints()
        configCollectionView()
        subscribeViewModel()
        viewModel.loadPurchaseOrderThenMakeChildViewModels()
        saveButton.addTarget(self, action: #selector(saveButtonDidTapped(_:)), for: .touchUpInside)
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
        view.addSubview(saveButton)
    }

    private func activateConstraints() {
        activateConstraintsCollecitonView()
        activateConstraintsSaveButton()
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
        let purchaseApplyInfoViewController = PurchaseApplyInfoViewController.loadFormNib()
        purchaseApplyInfoViewController.viewModel = purchaseApplyInfoViewModel
        contentViewControllers.append(purchaseApplyInfoViewController)

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
            .constraint(equalTo: saveButton.topAnchor)
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
