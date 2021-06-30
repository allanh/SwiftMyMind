//
//  PurchaseSuggestionViewController.swift
//  MyMind
//
//  Created by Chen Yi-Wei on 2021/6/2.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay
import PromiseKit

class PurchaseSuggestionViewController: NiblessViewController {

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionHeadersPinToVisibleBounds = true
        let screenWidth = UIScreen.main.bounds.width
        layout.headerReferenceSize = CGSize(width: screenWidth, height: 120)
        let horizontalInset: CGFloat = 20
        layout.sectionInset = UIEdgeInsets(top: 15, left: horizontalInset, bottom: 15, right: horizontalInset)
        layout.itemSize = CGSize(width: screenWidth-horizontalInset*2, height: 495)
        let collecitonView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collecitonView.backgroundColor = .white
        return collecitonView
    }()

    let nextStepButton: UIButton = UIButton {
        $0.backgroundColor = UIColor(hex: "004477")
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("下一步", for: .normal)
        $0.titleLabel?.font = .pingFangTCSemibold(ofSize: 16)
    }

    var contentViewControllers: [PurchaseProductSuggestionViewController] = []

    let viewModel: PurchaseSuggestionViewModel

    let bag: DisposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "採購建議"
        view.backgroundColor = .white
        addTapToResignKeyboardGesture()
        constructViewHierarchy()
        activateConstraints()
        configCollectionView()
        viewModel.loadSuggstionProductMaterialViewModels()

        wireToViewModel()
        subscribeViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        addKeyboardObservers()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        removeObservers()
    }

    init(viewModel: PurchaseSuggestionViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    private func configCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerCell(ContainerCollectionViewCell.self)
        collectionView.register(StageProgressCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: StageProgressCollectionReusableView.self))
    }

    private func wireToViewModel() {
        nextStepButton.addTarget(viewModel, action: #selector(PurchaseSuggestionViewModel.performNextStep), for: .touchUpInside)
    }

    private func subscribeViewModel() {
        viewModel.didReceiveContent
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] viewModels in
                self.generateChildViewController(childViewModels: viewModels)
                self.collectionView.reloadData()
            })
            .disposed(by: bag)

        viewModel.view
            .subscribe(onNext: { [unowned self] view in
                self.handleNavigation(view: view)
            })
            .disposed(by: bag)
    }

    private func generateChildViewController(childViewModels: [SuggestionProductMaterialViewModel]) {
        for viewModel in childViewModels {
            let viewController = PurchaseProductSuggestionViewController.loadFormNib()
            viewController.viewModel = viewModel
            contentViewControllers.append(viewController)
        }
    }

    private func removeChildViewController(at index: Int) {
        contentViewControllers.remove(at: index)
    }

    func constructViewHierarchy() {
        view.addSubview(collectionView)
        view.addSubview(nextStepButton)
    }

    func activateConstraints() {
        activateConstraintsCollecitonView()
        activateConstraintsNextStepButton()
    }

    private func handleNavigation(view: PurchaseSuggestionViewModel.View) {
        switch view {
        case .suggestionInfo(let info):
            let viewController = ProductMaterialSuggestionInfoTableViewController(viewModel: info.productSuggestionInfoViewModel)
            viewController.title = "建議採購資訊"
            show(viewController, sender: nil)
        case .purchaseApply:
            let service = MyMindPurchaseAPIService.shared
            
            let purchaseInfoViewModel = PurchaseApplyInfoViewModel(suggestionProductMaterialViewModels: viewModel.suggestionProductMaterialViewModels, warehouseLoader: service)

            let pickReviewerViewModel = PickPurchaseReviewerViewModel(loader: service)
            let purchaseApplyViewModel = PurchaseApplyViewModel(
                userSessionDataStore: KeychainUserSessionDataStore(),
                purchaseInfoViewModel: purchaseInfoViewModel,
                pickReviewerViewModel: pickReviewerViewModel,
                service: service)

            let viewController = PurchaseApplyViewController(viewModel: purchaseApplyViewModel)
            show(viewController, sender: nil)
            break
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
        collectionView.reloadData()
    }

    @objc
    private func suggestedQuantityButtonDidTapped(_ sender: UIButton) {
        guard
            let point = sender.superview?.convert(sender.frame.origin, to: collectionView),
            let indexPath = collectionView.indexPathForItem(at: point)
        else { return }
        viewModel.showSuggestionInfo(for: indexPath.item)
    }
}
// MARK: - Collection view data source
extension PurchaseSuggestionViewController: UICollectionViewDataSource {
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

        viewController.deleteButton.addTarget(self, action: #selector(deleteButtonDidTapped(_:)), for: .touchUpInside)
        viewController.suggestedQuantityButton.addTarget(self, action: #selector(suggestedQuantityButtonDidTapped(_:)), for: .touchUpInside)
        return cell
    }
}
// MARK: - Collection view delegate flow layout
extension PurchaseSuggestionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: StageProgressCollectionReusableView.self), for: indexPath)
        view.backgroundColor = .white
        (view as? StageProgressCollectionReusableView)?.configProgressView(numberOfStage: 3, stageTitleList: ["採購建議", "採購申請", "送出審核"], currentStageIndex: 0)
        return view
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 125)
    }
}

// MARK: - Layouts
extension PurchaseSuggestionViewController {
    private func activateConstraintsCollecitonView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let top = collectionView.topAnchor
            .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let leading = collectionView.leadingAnchor
            .constraint(equalTo: view.leadingAnchor)
        let bottom = collectionView.bottomAnchor
            .constraint(equalTo: nextStepButton.topAnchor)
        let trailing = collectionView.trailingAnchor
            .constraint(equalTo: view.trailingAnchor)

        NSLayoutConstraint.activate([
            top, leading, bottom, trailing
        ])
    }

    private func activateConstraintsNextStepButton() {
        nextStepButton.translatesAutoresizingMaskIntoConstraints = false
        let leading = nextStepButton.leadingAnchor
            .constraint(equalTo: view.leadingAnchor)
        let trailing = nextStepButton.trailingAnchor
            .constraint(equalTo: view.trailingAnchor)
        let bottom = nextStepButton.bottomAnchor
            .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        let height = nextStepButton.heightAnchor
            .constraint(equalToConstant: 50)

        NSLayoutConstraint.activate([
            leading, trailing, bottom, height
        ])
    }
}
// MARK: - Keyboard handle
extension PurchaseSuggestionViewController {
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
