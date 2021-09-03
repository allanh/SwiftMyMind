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

    lazy var dropDownView: DropDownView<AutoCompleteItemViewModel, MultiSelectableDropDownTableViewCell> = {
        let dropDownView = DropDownView(dataSource: viewModel.autoCompleteItemViewModels.value) { [unowned self] (cell: MultiSelectableDropDownTableViewCell, item) in
            self.configCellForDropDown(cell: cell, item: item)
        } selectHandler: { [unowned self] item in
            self.viewModel.pickItemViewModel(itemViewModel: item)
        }
        dropDownView.topInset = 5
        dropDownView.shouldReloadItemWhenSelect = true
        return dropDownView
    }()
    
    //MARK: - View life cycle
    override func loadView() {
        view = AutoCompleteTitleSerchView()
    }
    
    override func viewDidLoad() {
        rootView.textField.placeholder = viewModel.placeholder
        configCollectionView()
        bindToViewModel()
        subscribeToViewModel()
        dropDownView.anchorView = rootView.textField
    }
    
    override func viewDidLayoutSubviews() {
        updateCollectionView()
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
        rootView.collectionView.reloadData()
        rootView.layoutIfNeeded()
        rootView.collectionViewHeightAnchor.constant = rootView.collectionView.contentSize.height
    }
    
    private func bindToViewModel() {
        rootView.textField.rx.text.orEmpty
            .throttle(.milliseconds(200), scheduler: MainScheduler.instance)
            .bind(to: viewModel.searchTerm)
            .disposed(by: bag)
        
        rootView.textField.rx.controlEvent(.editingChanged)
            .map{_ in true }
            .bind(to: viewModel.isDropDownViewPresenting)
            .disposed(by: bag)
        
        rootView.textField.rx.controlEvent(.editingDidEnd)
            .map { false }
            .bind(to: viewModel.isDropDownViewPresenting)
            .disposed(by: bag)
    }
    
    private func subscribeToViewModel() {
        viewModel.pickedItemViewModels
            .subscribe(onNext: { [unowned self] _ in
                self.updateCollectionView()
            })
            .disposed(by: bag)
        
        viewModel.isDropDownViewPresenting
            .subscribe(onNext: { [unowned self] shouldShow in
                switch shouldShow {
                case true:  self.dropDownView.show()
                case false: self.dropDownView.hide()
                }
            })
            .disposed(by: bag)
        
        viewModel.autoCompleteItemViewModels
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] items in
                dropDownView.dataSource = items
            })
            .disposed(by: bag)
        }
    
    private func configCellForDropDown(cell: MultiSelectableDropDownTableViewCell, item:AutoCompleteItemViewModel) {
        let isSelected = viewModel.pickedItemViewModels.value.contains(item)
        cell.checkBoxButton.isSelected = isSelected
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
