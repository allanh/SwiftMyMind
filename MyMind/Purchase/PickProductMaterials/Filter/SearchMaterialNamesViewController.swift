//
//  SearchMaterialNamesViewController.swift
//  MyMind
//
//  Created by Barry Chen on 2021/5/26.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
import RxSwift

class SearchMaterialNameViewController: NiblessViewController {
    let viewModel: SearchMaterialNameViewModel
    let bag: DisposeBag = DisposeBag()

    var rootView: AutoCompleteSearchRootView {
        view as! AutoCompleteSearchRootView
    }

    override func loadView() {
        super.loadView()
        view = AutoCompleteSearchRootView()
    }

    init(viewModel: SearchMaterialNameViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configCollectionView()
        bindToViewModel()
        subscribeViewModel()
        rootView.titleLabel.text = viewModel.title
        rootView.textField.placeholder = viewModel.placeholder
    }

    private func configCollectionView() {
        rootView.collectionView.registerCell(SelectedQueryCollectionViewCell.self)
        rootView.collectionView.dataSource = self
        rootView.collectionView.delegate = self
    }

    private func updateCollectionView() {
        DispatchQueue.main.async {
            self.rootView.collectionView.reloadData()
            self.rootView.layoutIfNeeded()
            self.rootView.collectionViewHeightAnchor.constant = self.rootView.collectionView.contentSize.height
        }
    }

    private func bindToViewModel() {
        rootView.textField.rx.text.orEmpty
            .bind(to: viewModel.searchTerm)
            .disposed(by: bag)

        rootView.textField.rx.controlEvent(.editingDidEnd)
            .subscribe(onNext: { [unowned self] _ in
                viewModel.addSearchTerm()
            })
            .disposed(by: bag)
    }

    private func subscribeViewModel() {
        viewModel.addedSearchTerms
            .subscribe(onNext: { [unowned self] _ in
                self.updateCollectionView()
            })
            .disposed(by: bag)    }
    @objc
    private func didTapDeleteButtonInCell(_ sender: UIButton) {
        guard let point = sender.superview?.convert(sender.frame.origin, to: rootView.collectionView),
              let indexPath = rootView.collectionView.indexPathForItem(at: point)
        else { return }
        viewModel.removeSearchTerm(at: indexPath.item)
    }
}
extension SearchMaterialNameViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.addedSearchTerms.value.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(SelectedQueryCollectionViewCell.self, for: indexPath) as? SelectedQueryCollectionViewCell else {
            fatalError("Wrong cell identifier or not registered yet")
        }
        let item = viewModel.addedSearchTerms.value[indexPath.item]
        cell.config(with: item)
        cell.deleteButton.addTarget(self, action: #selector(didTapDeleteButtonInCell(_:)), for: .touchUpInside)
        return cell
    }
}
extension SearchMaterialNameViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let extraSpace: CGFloat = 20 + 10 + 10 + 10
        let item = viewModel.addedSearchTerms.value[indexPath.item]
        let width = item.width(withConstrainedHeight: 25, font: .pingFangTCRegular(ofSize: 14))
        return CGSize(width: width+extraSpace, height: 30)
    }
}
