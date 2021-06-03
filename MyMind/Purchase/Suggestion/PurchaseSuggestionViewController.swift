//
//  PurchaseSuggestionViewController.swift
//  MyMind
//
//  Created by Chen Yi-Wei on 2021/6/2.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
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

    override func viewDidLoad() {
        super.viewDidLoad()
        constructViewHierarchy()
        activateConstraints()
    }

    func constructViewHierarchy() {
        view.addSubview(collectionView)
        view.addSubview(nextStepButton)
    }

    func activateConstraints() {
        activateConstraintsCollecitonView()
        activateConstraintsNextStepButton()
    }
}
// MARK: - Collection view data source
extension PurchaseSuggestionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(ContainerCollectionViewCell.self, for: indexPath) as? ContainerCollectionViewCell else {
            print("Wrong cell identifier or not register yet")
            return UICollectionViewCell()
        }
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
