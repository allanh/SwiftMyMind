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
        $0.backgroundColor = UIColor(hex: "004477")
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("儲存", for: .normal)
        $0.titleLabel?.font = .pingFangTCSemibold(ofSize: 16)
    }

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

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
        viewModel.applyPurchase()
    }

    private func navigation(with view: PurchaseApplyViewModel.View) {
        switch view {
        case .finish(let purchaseID):
            break
        case .suggestion(let viewModels):
            break
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
        case 0: return CGSize(width: width, height: 575)
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
