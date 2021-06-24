//
//  EditablePickedProductsInfoViewController.swift
//  MyMind
//
//  Created by Barry Chen on 2021/6/16.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
import RxSwift

class EditablePickedProductsInfoViewController: NiblessViewController {
    enum Section {
        case main
    }
    // MARK: - Properties
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let screenWidth = UIScreen.main.bounds.width
        let horizontalInset: CGFloat = 20
        layout.sectionInset = UIEdgeInsets(top: 15, left: horizontalInset, bottom: 15, right: horizontalInset)
        layout.itemSize = CGSize(width: screenWidth-horizontalInset*2, height: 495)
        let collecitonView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collecitonView.backgroundColor = .white
        return collecitonView
    }()

    let closeButton: UIButton = UIButton {
        $0.backgroundColor = UIColor(hex: "004477")
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("關閉", for: .normal)
        $0.titleLabel?.font = .pingFangTCSemibold(ofSize: 16)
    }

    var contentViewControllers: [PurchaseProductSuggestionViewController] = []

    lazy var collectionViewDiffableDatsSource: UICollectionViewDiffableDataSource<Section, PurchaseProductSuggestionViewController> = {
        makeDataSource()
    }()

    let viewModel: EditablePickedProductsInfoViewModel

    let bag: DisposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        title = "採購SKU資訊"
        wireToViewModel()
        subscribeViewModel()
        addTapToResignKeyboardGesture()
        constructViewHierarchy()
        activateConstraints()
        generateChildViewControllers()
        configCollectionView()
        updateCollectionViewWithCurrentContentViewControllers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardObservers()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }

    init(viewModel: EditablePickedProductsInfoViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    private func constructViewHierarchy() {
        view.addSubview(collectionView)
        view.addSubview(closeButton)
    }

    private func activateConstraints() {
        activateConstraintsCollecitonView()
        activateConstraintsCloseButton()
    }

    private func wireToViewModel() {
        closeButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.viewModel.backToApply()
            })
            .disposed(by: bag)
    }

    private func subscribeViewModel() {
        viewModel.view
            .subscribe(onNext: handleNavigation(with:))
            .disposed(by: bag)
    }

    private func configCollectionView() {
        collectionView.registerCell(ContainerCollectionViewCell.self)
    }

    private func makeDataSource() -> UICollectionViewDiffableDataSource<Section, PurchaseProductSuggestionViewController> {

        UICollectionViewDiffableDataSource<Section, PurchaseProductSuggestionViewController>.init(collectionView: collectionView) { [weak self] collectionView, indexPath, viewController in
            guard let self = self else { return nil }
            guard let cell = collectionView.dequeueReusableCell(ContainerCollectionViewCell.self, for: indexPath) as? ContainerCollectionViewCell else {
                fatalError("Creat cell failed")
            }
            cell.hostedView = viewController.view

            viewController.deleteButton.addTarget(self, action: #selector(self.deleteButtonDidTapped(_:)), for: .touchUpInside)
            viewController.suggestedQuantityButton.addTarget(self, action: #selector(self.suggestedQuantityButtonDidTapped(_:)), for: .touchUpInside)
            return cell
        }
    }

    private func updateCollectionViewWithCurrentContentViewControllers() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, PurchaseProductSuggestionViewController>()
        snapshot.appendSections([.main])
        snapshot.appendItems(contentViewControllers)
        collectionViewDiffableDatsSource.apply(snapshot)
    }

    private func generateChildViewControllers() {
        for viewModel in viewModel.pickedProductMaterialViewModels.value {
            let viewController = PurchaseProductSuggestionViewController.loadFormNib()
            viewController.viewModel = viewModel
            contentViewControllers.append(viewController)
        }
    }

    private func removeChildViewController(at index: Int) {
        contentViewControllers.remove(at: index)
    }

    private func handleNavigation(with view: EditablePickedProductsInfoViewModel.View) {
        switch view {
        case .purchaseApply:
            navigationController?.popViewController(animated: true)
        case .suggestionInfo(let info):
            let viewController = ProductMaterialSuggestionInfoTableViewController(viewModel: info.productSuggestionInfoViewModel)
            viewController.title = "建議採購資訊"
            show(viewController, sender: nil)
        }
    }

    @objc
    private func deleteButtonDidTapped(_ sender: UIButton) {
        guard
            let point = sender.superview?.convert(sender.frame.origin, to: collectionView),
            let indexPath = collectionView.indexPathForItem(at: point)
        else { return }

        viewModel.removeSuggestionProductMaterialViewModel(at: indexPath.item)
        removeChildViewController(at: indexPath.item)
        updateCollectionViewWithCurrentContentViewControllers()
    }

    @objc
    private func suggestedQuantityButtonDidTapped(_ sender: UIButton) {
        guard
            let point = sender.superview?.convert(sender.frame.origin, to: collectionView),
            let indexPath = collectionView.indexPathForItem(at: point)
        else { return }
        viewModel.showSuggestionInfo(index: indexPath.item)
    }
}
// MARK: - Layouts
extension EditablePickedProductsInfoViewController {
    private func activateConstraintsCollecitonView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let top = collectionView.topAnchor
            .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let leading = collectionView.leadingAnchor
            .constraint(equalTo: view.leadingAnchor)
        let bottom = collectionView.bottomAnchor
            .constraint(equalTo: closeButton.topAnchor)
        let trailing = collectionView.trailingAnchor
            .constraint(equalTo: view.trailingAnchor)

        NSLayoutConstraint.activate([
            top, leading, bottom, trailing
        ])
    }

    private func activateConstraintsCloseButton() {
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        let leading = closeButton.leadingAnchor
            .constraint(equalTo: view.leadingAnchor)
        let trailing = closeButton.trailingAnchor
            .constraint(equalTo: view.trailingAnchor)
        let bottom = closeButton.bottomAnchor
            .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        let height = closeButton.heightAnchor
            .constraint(equalToConstant: 50)

        NSLayoutConstraint.activate([
            leading, trailing, bottom, height
        ])
    }
}
// MARK: - Keyboard handle
extension EditablePickedProductsInfoViewController {
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
