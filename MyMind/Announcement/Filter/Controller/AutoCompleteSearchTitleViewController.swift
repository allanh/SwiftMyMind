//
//  AutoCompleteSearchTitleViewController.swift
//  MyMind
//
//  Created by Chijung Chan on 2021/9/2.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
import RxSwift

class AutoCompleteSearchTitleViewController: NiblessViewController {
    let viewModel: AutoCompleteTitleSearchModel
    let bag: DisposeBag = DisposeBag()
    var rootView: AutoCompleteTitleSerchView {
        view as! AutoCompleteTitleSerchView
    }
    // dropdownview
//    lazy var dropDownView: DropDownView<AutoCompleteItemsViewModel, MultiSelectableDropDownTableViewCell> {
//        let dropDownView = DropDownView(dataSource: viewModel.autoCompleteItemViewModels) { [unowned self] (cell: MultiSelectableDropDownTableViewCell, item) in
//            self.configCellForDropDown(cell: cell, item: item)
//        } selectHamder: {
//
//        }
//
//        ret
    
    
    
    //MARK: - View life cycle
    override func loadView() {
        view = AutoCompleteTitleSerchView()
    }
    
    override func viewDidLoad() {
        rootView.textField.placeholder = viewModel.placeholder
        configCollectionView()
        bindToViewModel()
        subscribeToViewModel()
        
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    //MARK: - Methods
    init(viewModel:  AutoCompleteTitleSearchModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    private func configCollectionView() {
        rootView.collectionView.registerCell(SelectedQueryCollectionViewCell.self)
        rootView.collectionView.delegate = self
        rootView.collectionView.dataSource = self
    }
    
    private func updateCollectionView() {
        
    }
    
    private func bindToViewModel() {
        
    }
    
    private func subscribeToViewModel() {
        
    }
    
    private func configCellForDropDown() {
        
    }
    
    @objc
    private func didTapDeletedButtonCell(_ sender: UIButton) {
        guard let point = sender.superview?.convert(sender.frame.origin, to: rootView.collectionView),
              let indexPath = rootView.collectionView.indexPathForItem(at: point)
        else { return }
        let item = viewModel.pickedItemViewModels.value[indexPath.item]
        viewModel.pickItemViewModel(itemViewModel: item)
    }
}
extension AutoCompleteSearchTitleViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(SelectedQueryCollectionViewCell.self, for: indexPath) as? SelectedQueryCollectionViewCell else {
            fatalError("Wrong cell identifier or not registered yet")
        }
        let item = viewModel.pickedItemViewModels.value[indexPath.item]
        cell.config(with: item.representTitle)
        cell.deleteButton.addTarget(self, action: #selector(didTapDeletedButtonCell), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.pickedItemViewModels.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let extraSpace: CGFloat = 20 + 10 + 10 + 10
        let item = viewModel.pickedItemViewModels.value[indexPath.item]
        let width = item.representTitle.width(withConstrainedHeight: 25, font: .pingFangTCRegular(ofSize: 14))
        return CGSize(width: width+extraSpace, height: 30)
    }
}
