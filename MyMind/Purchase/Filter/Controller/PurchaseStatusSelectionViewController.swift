//
//  PurchaseStatusSelectionViewController.swift
//  MyMind
//
//  Created by Barry Chen on 2021/5/11.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
import RxSwift

class PurchaseStatusSelectionViewController: NiblessViewController {

    var rootView: AutoCompleteSearchRootView {
        view as! AutoCompleteSearchRootView
    }

    lazy var dropDownView: DropDownView<PurchaseStatus, DropDownListTableViewCell> = {
        let dropDownView = DropDownView(dataSource: PurchaseStatus.allCases) { (cell: DropDownListTableViewCell, item) in
            self.configCell(cell: cell, with: item)
        } selectHandler: { item in
            self.selectItem(item: item)
        }
        return dropDownView
    }()

    let viewModel: PickPurchaseStatusViewModel
    let bag: DisposeBag = DisposeBag()

    init(viewModel: PickPurchaseStatusViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    override func loadView() {
        super.loadView()
        view = AutoCompleteSearchRootView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        rootView.titleLabel.text = viewModel.title
        configCollectionView()
        configTextField()
        configDropDownView()
        subscribeViewModel()
    }

    override func viewDidLayoutSubviews() {
        updateCollectionView()
    }

    private func subscribeViewModel() {
        viewModel.pickedStatus
            .subscribe(onNext: { [unowned self] _ in
                self.updateCollectionView()
            })
            .disposed(by: bag)
    }

    private func configDropDownView() {
        dropDownView.topInset = 5
        dropDownView.shouldReloadItemWhenSelect = true
        dropDownView.anchorView = rootView.textField
    }

    private func configCollectionView() {
        rootView.collectionView.dataSource = self
        rootView.collectionView.delegate = self
        rootView.collectionView.registerCell(SelectedQueryCollectionViewCell.self)
    }

    private func configTextField() {
        rootView.textField.delegate = self
    }

    private func configCell(cell: DropDownListTableViewCell, with item: PurchaseStatus) {
        cell.titleLabel.text = item.description
    }

    private func selectItem(item: PurchaseStatus) {
        viewModel.pickedStatus.accept(item)
        updateCollectionView()
        dropDownView.hide()
    }

    private func updateCollectionView() {
        rootView.collectionView.reloadData()
        rootView.layoutIfNeeded()
        rootView.collectionViewHeightAnchor.constant = rootView.collectionView.contentSize.height
    }

    @objc
    private func deleteButtonDidTapped(_ sender: UIButton) {
        viewModel.pickedStatus.accept(nil)
        updateCollectionView()
    }
}
// MARK: - Text field delegate
extension PurchaseStatusSelectionViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        dropDownView.show()
        return false
    }
}
// MARK: - Collection view data source
extension PurchaseStatusSelectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.pickedStatus.value != nil ? 1 : 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(SelectedQueryCollectionViewCell.self, for: indexPath) as? SelectedQueryCollectionViewCell else {
            fatalError("Wrong cell identifier or not registered yet")
        }
        cell.config(with: viewModel.pickedStatus.value?.description ?? "")
        cell.deleteButton.addTarget(self, action: #selector(deleteButtonDidTapped(_:)), for: .touchUpInside)
        return cell
    }
}
// MARK: - Collection view delegate flow layout
extension PurchaseStatusSelectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let extraSpace: CGFloat = 20 + 10 + 10 + 10
        let status = viewModel.pickedStatus.value?.description ?? ""
        let width = status.width(withConstrainedHeight: 20, font: .pingFangTCRegular(ofSize: 14))
        return CGSize(width: width+extraSpace, height: 30)
    }
}
extension PurchaseStatusSelectionViewController: PurchaseFilterChildViewController {
    func reloadData() {
        updateCollectionView()
    }
}
