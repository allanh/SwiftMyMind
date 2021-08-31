//
//  AnnouncementTypeSelectionViewController.swift
//  MyMind
//
//  Created by Chijung Chan on 2021/8/30.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
import RxSwift

class AnnouncementTypeSelectionViewController: NiblessViewController {
    // MARK: - View
    var rootView: AutoCompleteSearchRootView {
        view as! AutoCompleteSearchRootView
    }
    
    lazy var dropDownView: DropDownView<AnnouncementType, DropDownListTableViewCell> = {
        let dropDownView = DropDownView(dataSource: AnnouncementType.allCases) { (cell: DropDownListTableViewCell, item) in
            self.configCell(cell: cell, with: item)
        } selectHandler: { item in
            self.selectItem(item: item)
        }
        return dropDownView
    }()
    
    let viewModel: PickAnnouncementTypeViewModel
    let bag: DisposeBag = DisposeBag()
    
    init(viewModel: PickAnnouncementTypeViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    // MARK: - Life cycle
    override func loadView() {
        super.loadView()
        view = AutoCompleteSearchRootView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rootView.titleLabel.text = viewModel.title
        rootView.textField.placeholder = viewModel.placeholder
        subscribeViewModel()
        configDropDownView()
        configTextField()
        configCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        updateCollectionView()
    }
    
    // MARK: - Methods
    private func subscribeViewModel() {
        viewModel.pickedType
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
    
    private func configCell(cell: DropDownListTableViewCell,  with item: AnnouncementType) {
        cell.titleLabel.text = item.description
    }
    
    private func selectItem(item: AnnouncementType) {
        viewModel.pickedType.accept(item)
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
        viewModel.pickedType.accept(nil)
        updateCollectionView()
    }
    
}
// MARK: CollectionView Delegate, Datasource, layout
extension AnnouncementTypeSelectionViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.pickedType.value != nil ? 1 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(SelectedQueryCollectionViewCell.self, for: indexPath) as? SelectedQueryCollectionViewCell else { fatalError("Wrong cell indentifier or not registered") }
        cell.config(with: viewModel.pickedType.value?.description ?? "123")
        cell.deleteButton.addTarget(self, action: #selector(deleteButtonDidTapped(_:)), for: .touchUpInside)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let extraSpace: CGFloat = 20 + 10 + 10 + 10
        let type = viewModel.pickedType.value?.description ?? ""
        let width = type.width(withConstrainedHeight: 20, font: .pingFangTCRegular(ofSize: 14))
        return CGSize(width: width+extraSpace, height: 30)
    }
}

// MARK: TextField Delegate
extension AnnouncementTypeSelectionViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        dropDownView.show()
        return false
    }
    
}
