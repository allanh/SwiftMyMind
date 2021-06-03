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

struct PurchaseServiceToSuggestionProductMaterialViewModelAdapter: SuggestionProductMaterialViewModeService {
    let service: PurchaseAPIService
    let imageDictionary: [String: URL?]

    func fetchSuggestionProductMaterialViewModels(with productIDs: [String]) -> Promise<[SuggestionProductMaterialViewModel]> {
        return Promise<[SuggestionProductMaterialViewModel]> { seal in
            service.fetchPurchaseSeggestionInfos(with: productIDs)
                .done { list in
                    let suggestionInfos = list.items
                    let viewModels = suggestionInfos.map { info -> SuggestionProductMaterialViewModel in
                        let imageURL = imageDictionary[info.number, default: nil]
                        return SuggestionProductMaterialViewModel.init(imageURL: imageURL, number: info.number, originalProductNumber: info.originalProductNumber, name: info.name, purchaseSuggestionQuantity: info.suggestedQuantity, stockUnitName: info.stockUnitName, quantityPerBox: Int(info.quantityPerBox) ?? 0, purchaseSuggestionInfo: info, purchaseCostPerItem: Float(info.cost) ?? 0)
                    }
                    seal.fulfill(viewModels)
                }
                .catch { error in
                    seal.reject(error)
                }
        }
    }
}

protocol SuggestionProductMaterialViewModeService {
    func fetchSuggestionProductMaterialViewModels(with productIDs: [String]) -> Promise<[SuggestionProductMaterialViewModel]>
}

class PurchaseSuggestionViewModel {
    enum View {
        case suggestionInfo, purchaseApply
    }
    let pickedProductIDList: [String]
    let service: SuggestionProductMaterialViewModeService

    var suggestionProductMaterialViewModels: [SuggestionProductMaterialViewModel] = []

    let didReceiveContent: PublishRelay<[SuggestionProductMaterialViewModel]> = .init()
    let didRemoveViewModelAtIndex: PublishRelay<Int> = .init()

    let view: PublishRelay<View> = .init()
    let errorMessage: PublishRelay<String> = .init()

    init(pickedProductIDList: [String],
         service: SuggestionProductMaterialViewModeService) {
        self.pickedProductIDList = pickedProductIDList
        self.service = service
    }

    func fetchSuggstionProductMaterialViewModels() {
        service.fetchSuggestionProductMaterialViewModels(with: pickedProductIDList)
            .done { [weak self] viewModels in
                guard let self = self else { return }
                self.suggestionProductMaterialViewModels = viewModels
                self.didReceiveContent.accept(viewModels)
            }
            .catch { [weak self] error in
                guard let self = self else { return }
                self.sendErrorMessage(string: error.localizedDescription)
            }
    }

    func removeSuggestionProductMaterialViewModel(at index: Int) {
        suggestionProductMaterialViewModels.remove(at: index)
        didRemoveViewModelAtIndex.accept(index)
    }

    @objc
    func performNextStep() {
        guard validateAllProductMaterailsInfo() else {
            sendErrorMessage(string: "採購資訊有誤！")
            return
        }

        view.accept(.purchaseApply)
    }

    func validateAllProductMaterailsInfo() -> Bool {
        var result: Bool = true
        suggestionProductMaterialViewModels.forEach { viewModel in
            // Emit quantity element in case user did not input anything
            viewModel.purchaseQuantity.accept(viewModel.purchaseQuantity.value)
            if viewModel.centralizedValidationStatus.value != .valid {
                result = false
            }
        }

        return result
    }

    func sendErrorMessage(string: String) {
        errorMessage.accept(string)
    }
}

class PurchaseSuggestionViewController: NiblessViewController {

    let collectionView: UICollectionView = UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.sectionHeadersPinToVisibleBounds = true
        let screenWidth = UIScreen.main.bounds.width
        layout.headerReferenceSize = CGSize(width: screenWidth, height: 120)
        let horizontalInset: CGFloat = 20
        layout.sectionInset = UIEdgeInsets(top: 15, left: horizontalInset, bottom: 15, right: horizontalInset)
        layout.itemSize = CGSize(width: screenWidth-horizontalInset*2, height: 469)
        $0.collectionViewLayout = layout
    }

    let headerView: UIView = UIView {
        $0.backgroundColor = .white
        let progressView = StageProgressView(numberOfStage: 3, stageNameList: ["採購建議", "採購申請", "送出審核"], currentStageIndex: 0)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        $0.addSubview(progressView)
        progressView.topAnchor.constraint(equalTo: $0.topAnchor).isActive = true
        progressView.bottomAnchor.constraint(equalTo: $0.bottomAnchor).isActive = true
        progressView.leadingAnchor.constraint(equalTo: $0.leadingAnchor).isActive = true
        progressView.trailingAnchor.constraint(equalTo: $0.trailingAnchor).isActive = true
    }

    let nextStepButton: UIButton = UIButton {
        $0.backgroundColor = UIColor(hex: "004477")
        $0.setTitleColor(.white, for: .normal)
    }

    var contentViewControllers: [PurchaseProductSuggestionViewController] = []

    let viewModel: PurchaseSuggestionViewModel

    let bag: DisposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        constructViewHierarchy()
        activateConstraints()
        viewModel.fetchSuggstionProductMaterialViewModels()

        wireToViewModel()
        subscribeViewModel()
    }

    init(viewModel: PurchaseSuggestionViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    private func wireToViewModel() {
        nextStepButton.addTarget(viewModel, action: #selector(PurchaseSuggestionViewModel.performNextStep), for: .touchUpInside)
    }

    private func subscribeViewModel() {
        viewModel.view
            .subscribe(onNext: { [unowned self] in
                self.handleNavigation(view: $0)
            })
            .disposed(by: bag)

        viewModel.didReceiveContent
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] viewModels in
                self.generateChildViewController(childViewModels: viewModels)
                self.collectionView.reloadData()
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
        case .suggestionInfo:
            break
        case .purchaseApply:
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
        viewController.deleteButton.addTarget(self, action: #selector(deleteButtonDidTapped(_:)), for: .touchUpInside)
        cell.hostedView = viewController.view
        return cell
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
            .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
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
            .constraint(equalTo: view.bottomAnchor)
        let height = nextStepButton.heightAnchor
            .constraint(equalToConstant: 40)

        NSLayoutConstraint.activate([
            leading, trailing, bottom, height
        ])
    }
}
