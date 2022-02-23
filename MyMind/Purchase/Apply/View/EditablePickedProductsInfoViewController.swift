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
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
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
    private let seperator: UIView = UIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor(hex: "797979")
    }
    private let summaryLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .tundora
        $0.font = .pingFangTCSemibold(ofSize: 16)
    }
    private let costTitleLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .brownGrey
        $0.font = .pingFangTCSemibold(ofSize: 14)
        $0.textAlignment = .right
        $0.text = "未稅 $"
    }
    private let costLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .brownGrey
        $0.font = .pingFangTCSemibold(ofSize: 14)
        $0.textAlignment = .right
        $0.text = "cost"
    }
    private let taxTitleLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .brownGrey
        $0.font = .pingFangTCSemibold(ofSize: 14)
        $0.textAlignment = .right
        $0.text = "稅額 $"
    }
    private let taxLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .brownGrey
        $0.font = .pingFangTCSemibold(ofSize: 14)
        $0.textAlignment = .right
        $0.text = "tax"
    }
   private let totalTitleLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .azure
        $0.font = .pingFangTCSemibold(ofSize: 14)
        $0.textAlignment = .right
        $0.text = "合計(含稅) $"
    }
    private let totalLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .azure
        $0.font = .pingFangTCSemibold(ofSize: 14)
        $0.textAlignment = .right
        $0.text = "total"
    }

//    let closeButton: UIButton = UIButton {
//        $0.backgroundColor = UIColor(hex: "004477")
//        $0.setTitleColor(.white, for: .normal)
//        $0.setTitle("關閉", for: .normal)
//        $0.titleLabel?.font = .pingFangTCSemibold(ofSize: 16)
//    }

    var contentViewControllers: [PurchaseProductSuggestionViewController] = []

    lazy var collectionViewDiffableDatsSource: UICollectionViewDiffableDataSource<Section, PurchaseProductSuggestionViewController> = {
        makeDataSource()
    }()

    let viewModel: EditablePickedProductsInfoViewModel

    let bag: DisposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        addCustomBackNavigationItem()
        title = "採購SKU資訊"
        navigationItem.backButtonTitle = ""
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
        view.addSubview(seperator)
        view.addSubview(summaryLabel)
        view.addSubview(costTitleLabel)
        view.addSubview(costLabel)
        view.addSubview(taxTitleLabel)
        view.addSubview(taxLabel)
        view.addSubview(totalTitleLabel)
        view.addSubview(totalLabel)
    }

    private func activateConstraints() {
        activateConstraintsCollecitonView()
        activateConstraintsSeperator()
        activateConstraintsSummaryLabel()
        activateConstraintsCostTitleLabel()
        activateConstraintsCostLabel()
        activateConstraintsTaxTitleLabel()
        activateConstraintsTaxLabel()
        activateConstraintsTotalTitleLabel()
        activateConstraintsTotalLabel()
    }

    private func wireToViewModel() {
//        closeButton.rx.tap
//            .subscribe(onNext: { [unowned self] _ in
//                self.viewModel.backToApply()
//            })
//            .disposed(by: bag)
    }

    private func subscribeViewModel() {
        viewModel.view
            .subscribe(onNext: handleNavigation(with:))
            .disposed(by: bag)
        
        viewModel.pickedProductMaterialViewModels
            .map({ "共 \($0.count) 件SKU" })
            .bind(to: summaryLabel.rx.text)
            .disposed(by: bag)
        
        viewModel.pickedProductMaterialViewModels
            .subscribe(onNext: handleItemUpdated(with:))
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
    
    private func handleItemUpdated(with items: [SuggestionProductMaterialViewModel]) {
        let formatter: NumberFormatter = NumberFormatter {
            $0.numberStyle = .currency
            $0.currencySymbol = ""
        }

        let totalCost = items
            .map {
                $0.purchaseCost.value
            }.reduce(0) { (sum, num) -> Double in
                return sum+num
            }
        let tax = totalCost * 0.05
        costLabel.text = formatter.string(from: NSNumber(value: totalCost))
        taxLabel.text = formatter.string(from: NSNumber(value: tax))
        totalLabel.text = formatter.string(from: NSNumber(value: totalCost+tax))
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
        let trailing = collectionView.trailingAnchor
            .constraint(equalTo: view.trailingAnchor)

        NSLayoutConstraint.activate([
            top, leading, trailing
        ])
    }
    private func activateConstraintsSeperator() {
        let top = seperator.topAnchor.constraint(equalTo: collectionView.bottomAnchor)
        let leading = seperator.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let trailing = seperator.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let height = seperator.heightAnchor.constraint(equalToConstant: 1)
        NSLayoutConstraint.activate([
            top, leading, trailing, height
        ])
    }
    private func activateConstraintsSummaryLabel() {
        let top = summaryLabel.topAnchor.constraint(equalTo: seperator.bottomAnchor, constant: 8)
        let leading = summaryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        let centerY = summaryLabel.centerYAnchor.constraint(equalTo: costTitleLabel.centerYAnchor)
        NSLayoutConstraint.activate([
            top, leading, centerY
        ])
    }
    private func activateConstraintsCostTitleLabel() {
        let trailing = costTitleLabel.trailingAnchor.constraint(equalTo: taxTitleLabel.trailingAnchor)
        let leading = costTitleLabel.leadingAnchor.constraint(equalTo: taxTitleLabel.leadingAnchor)
        let centerY = costTitleLabel.centerYAnchor.constraint(equalTo: costLabel.centerYAnchor)
        NSLayoutConstraint.activate([
            trailing, leading, centerY
        ])
    }
    private func activateConstraintsCostLabel() {
        let trailing = costLabel.trailingAnchor.constraint(equalTo: taxLabel.trailingAnchor)
        let leading = costLabel.leadingAnchor.constraint(equalTo: taxLabel.leadingAnchor)
        let bottom = costLabel.bottomAnchor.constraint(equalTo: taxLabel.topAnchor, constant: -8)
        NSLayoutConstraint.activate([
            trailing, leading, bottom
        ])
    }
    private func activateConstraintsTaxTitleLabel() {
        let trailing = taxTitleLabel.trailingAnchor.constraint(equalTo: totalTitleLabel.trailingAnchor)
        let leading = taxTitleLabel.leadingAnchor.constraint(equalTo: totalTitleLabel.leadingAnchor)
        let centerY = taxTitleLabel.centerYAnchor.constraint(equalTo: taxLabel.centerYAnchor)
        NSLayoutConstraint.activate([
            trailing, leading, centerY
        ])
    }
    private func activateConstraintsTaxLabel() {
        let trailing = taxLabel.trailingAnchor.constraint(equalTo: totalLabel.trailingAnchor)
        let leading = taxLabel.leadingAnchor.constraint(equalTo: totalLabel.leadingAnchor)
        let bottom = taxLabel.bottomAnchor.constraint(equalTo: totalLabel.topAnchor, constant: -8)
        NSLayoutConstraint.activate([
            trailing, leading, bottom
        ])
    }
    private func activateConstraintsTotalTitleLabel() {
        let centerY = totalTitleLabel.centerYAnchor.constraint(equalTo: totalLabel.centerYAnchor)
        NSLayoutConstraint.activate([
            centerY
        ])
    }
    private func activateConstraintsTotalLabel() {
        let trailing = totalLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        let leading = totalLabel.leadingAnchor.constraint(equalTo: totalTitleLabel.trailingAnchor, constant: 8)
        let bottom = totalLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        NSLayoutConstraint.activate([
            trailing, leading, bottom
        ])
    }

//    private func activateConstraintsCloseButton() {
//        closeButton.translatesAutoresizingMaskIntoConstraints = false
//        let leading = closeButton.leadingAnchor
//            .constraint(equalTo: view.leadingAnchor)
//        let trailing = closeButton.trailingAnchor
//            .constraint(equalTo: view.trailingAnchor)
//        let bottom = closeButton.bottomAnchor
//            .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
//        let height = closeButton.heightAnchor
//            .constraint(equalToConstant: 50)
//
//        NSLayoutConstraint.activate([
//            leading, trailing, bottom, height
//        ])
//    }
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
