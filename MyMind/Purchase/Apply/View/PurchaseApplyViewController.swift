//
//  PurchaseApplyViewController.swift
//  MyMind
//
//  Created by Barry Chen on 2021/6/10.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
import RxSwift

final class PurchaseApplyViewController: NiblessViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    // MARK: - Properties
    let viewModel: PurchaseApplyViewModel

    let bag: DisposeBag = DisposeBag()

    var contentViewControllers: [UIViewController] = []

    // MARK: UI
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionHeadersPinToVisibleBounds = true
        let screenWidth = UIScreen.main.bounds.width
        layout.headerReferenceSize = CGSize(width: screenWidth, height: 120)
        let horizontalInset: CGFloat = 20
        layout.sectionInset = UIEdgeInsets(top: 15, left: horizontalInset, bottom: 15, right: horizontalInset)
        let collecitonView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collecitonView.backgroundColor = .white
        return collecitonView
    }()

    let saveButton: UIButton = UIButton {
        $0.backgroundColor = .prussianBlue
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("儲存", for: .normal)
        $0.titleLabel?.font = .pingFangTCSemibold(ofSize: 16)
    }

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        addCustomBackNavigationItem()
        title = "採購申請"
        navigationItem.backButtonTitle = ""
        view.backgroundColor = .white
        subscribeViewModel()
        configSaveButton()
        addTapToResignKeyboardGesture()
        constructViewHierarchy()
        activateConstraints()
        configCollectionView()
        generateContentViewControllers()
        collectionView.reloadData()
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
    init(viewModel: PurchaseApplyViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    private func constructViewHierarchy() {
        view.addSubview(collectionView)
        view.addSubview(saveButton)
    }

    private func activateConstraints() {
        activateConstraintsCollecitonView()
        activateConstraintsSaveButton()
    }

    private func configSaveButton() {
        saveButton.addTarget(self, action: #selector(saveButtonDidTapped(_:)), for: .touchUpInside)
    }

    private func subscribeViewModel() {
        viewModel.isNetworkProcessing
            .skip(1)
            .bind(to: rx.isActivityIndicatorAnimating)
            .disposed(by: bag)

        viewModel.view
            .subscribe(onNext: navigation(with:))
            .disposed(by: bag)
    }

    private func configCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerCell(ContainerCollectionViewCell.self)
        collectionView.register(StageProgressCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: StageProgressCollectionReusableView.self))
    }

    private func generateContentViewControllers() {
        let purchaseApplyInfoViewController = PurchaseApplyInfoViewController.loadFormNib()
        purchaseApplyInfoViewController.viewModel = viewModel.purchaseInfoViewModel
        contentViewControllers.append(purchaseApplyInfoViewController)

        let pickPurchaseReviewerViewController = PickPurchaseReviewerViewController.loadFormNib()
        pickPurchaseReviewerViewController.viewModel = viewModel.pickReviewerViewModel
        contentViewControllers.append(pickPurchaseReviewerViewController)
    }

    @objc
    private func saveButtonDidTapped(_ sender: UIButton) {
        let expectStorageDate = viewModel.purchaseInfoViewModel.expectedStorageDate.value ?? Date()
        let days = Calendar.current.dateComponents([.day], from: Date(), to: expectStorageDate).day ?? 0
        if days < 3 {
//            let titleFont = UIFont.preferredFont(forTextStyle: .headline).withTraits(traits: .traitBold)
//            let bodyFont = UIFont.preferredFont(forTextStyle: .body)
//            let alertController = UIAlertController(title: NSAttributedString(string: "確定申請?", attributes: [.foregroundColor: UIColor(hex: "1c4373"), .font: titleFont]), message:  NSAttributedString(string: "預計入庫日距離今日小於 3 天，請確定是否送出申請。", attributes: [.foregroundColor: UIColor(hex: "7f7f7f"), .font: bodyFont]), preferredStyle: .alert)
//            let cancelAction = UIAlertAction(title: "取消", style: .cancel, color: UIColor(hex: "7f7f7f")) { action in
//            }
//            let confirmAction = UIAlertAction(title: "確定", style: .default, color: UIColor(hex: "1c4373")) { [weak self] action in
//                self?.viewModel.applyPurchase()
//           }
            let alertController = UIAlertController(title: "確定申請?", message: "預計入庫日距離今日小於 3 天，請確定是否送出申請。", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel) { action in
            }
            let confirmAction = UIAlertAction(title: "確定", style: .default) { [weak self] action in
                self?.viewModel.applyPurchase()
            }
            alertController.addAction(cancelAction)
            alertController.addAction(confirmAction)
            present(alertController, animated: true, completion: nil)
        } else {
            viewModel.applyPurchase()
        }
    }

    private func navigation(with view: PurchaseApplyViewModel.View) {
        switch view {
        case .finish(let purchaseID):
            let viewController = PurchaseCompletedApplyViewController(purchaseID: purchaseID, loader: MyMindPurchaseAPIService.shared)
            viewController.title = "完成申請"
            show(viewController, sender: nil)
        case .suggestion(let viewModels):
            let viewModel = EditablePickedProductsInfoViewModel(pickedProductMaterialViewModels: viewModels)
            let viewController = EditablePickedProductsInfoViewController(viewModel: viewModel)
            show(viewController, sender: nil)
        case .error(let error):
            if let apiError = error as? APIError {
                _ = ErrorHandler.shared.handle(apiError)
            } else {
                ToastView.showIn(self, message: error.localizedDescription)
            }
        }
    }
}
// MARK: - Collection view data source
extension PurchaseApplyViewController: UICollectionViewDataSource {
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
extension PurchaseApplyViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: StageProgressCollectionReusableView.self), for: indexPath)
        view.backgroundColor = .white
        (view as? StageProgressCollectionReusableView)?.configProgressView(numberOfStage: 3, stageTitleList: ["採購建議", "採購申請", "送出審核"], currentStageIndex: 1)
        return view
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 125)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        var horizontalInsets: CGFloat = .zero
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            horizontalInsets = flowLayout.sectionInset.left + flowLayout.sectionInset.right
        }
        let width = screenWidth - horizontalInsets

        switch indexPath.item {
        case 0: return CGSize(width: width, height: 625)
        default: return CGSize(width: width, height: 400)
        }
    }
}
// MARK: - Layouts
extension PurchaseApplyViewController {
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
extension PurchaseApplyViewController {
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
