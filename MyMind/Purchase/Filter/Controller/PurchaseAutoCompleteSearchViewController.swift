//
//  PurchaseAutoCompleteSearchViewController.swift
//  MyMind
//
//  Created by Barry Chen on 2021/5/6.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
import PromiseKit
import RxSwift

class PurchaseAutoCompleteSearchViewController: NiblessViewController {
    lazy var currentSearchResult: [AutoCompleteInfo] = []

    private var rootView: AutoCompleteSearchRootView {
        return view as! AutoCompleteSearchRootView
    }

    lazy var dropDownView: DropDownView<AutoCompleteInfo, MultiSelectableDropDownTableViewCell> = {
        let dropDownView = DropDownView(dataSource: self.currentQueryList) { (cell: MultiSelectableDropDownTableViewCell, item) in
            self.configCell(cell: cell, with: item)
        } selectHandler: { item in
            self.selectItem(item: item)
        }
        dropDownView.topInset = 5
        dropDownView.shouldReloadItemWhenSelect = true
        return dropDownView
    }()

    let purchaseQueryType: PurchaseQueryType
    let purchaseQueryRepository: PurchaseQueryRepository

    var currentQueryList: [AutoCompleteInfo] = []
    private let bag: DisposeBag = DisposeBag()

    init(purchaseQueryType: PurchaseQueryType,
         purchaseQueryRepository: PurchaseQueryRepository) {
        self.purchaseQueryType = purchaseQueryType
        self.purchaseQueryRepository = purchaseQueryRepository
        super.init()
    }

    override func loadView() {
        super.loadView()
        view = AutoCompleteSearchRootView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configCollectionView()
        configTextField()
        dropDownView.anchorView = rootView.textField
        rootView.titleLabel.text = purchaseQueryType.description
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCollectionView()
    }

    private func configCollectionView() {
        rootView.collectionView.dataSource = self
        rootView.collectionView.delegate = self
        rootView.collectionView.registerCell(SelectedQueryCollectionViewCell.self)
    }

    private func configCell(cell: MultiSelectableDropDownTableViewCell, with item: AutoCompleteInfo) {
        cell.checkBoxButton.isSelected = item.isSelect
        switch purchaseQueryType {
        case .purchaseNumber:
            cell.titleLabel.text = item.number
        case .vendorID:
            cell.titleLabel.text = item.name
        case .applicant:
            cell.titleLabel.text = item.name
        case .productNumbers:
            cell.titleLabel.text = item.number
        default: return
        }
    }

    private func selectItem(item: AutoCompleteInfo) {
        switch purchaseQueryType {
        case .purchaseNumber:
            purchaseQueryRepository.updateAutoCompleteQueryInfo(
                for: purchaseQueryType,
                with: item
            )
        case .vendorID:
            purchaseQueryRepository.updateAutoCompleteQueryInfo(
                for: purchaseQueryType,
                with: item
            )
        case .applicant:
            purchaseQueryRepository.updateAutoCompleteQueryInfo(
                for: purchaseQueryType,
                with: item
            )
        case .productNumbers:
            purchaseQueryRepository.updateAutoCompleteQueryInfo(
                for: purchaseQueryType,
                with: item
            )
        default: break
        }
        updateCollectionView()
    }

    private func getDropDownDataSource(with searchTerm: String) -> [AutoCompleteInfo] {
        let source = purchaseQueryRepository.autoCompleteSource[purchaseQueryType] ?? []
        switch purchaseQueryType {
        case .purchaseNumber:
            switch searchTerm.isEmpty {
            case true: return source
            case false: return source.filter { $0.number?.contains(searchTerm) ?? false }
            }
        case .vendorID:
            switch searchTerm.isEmpty {
            case true: return source
            case false: return source.filter { $0.name?.contains(searchTerm) ?? false }
            }
        case .applicant:
            switch searchTerm.isEmpty {
            case true: return source
            case false: return source.filter { $0.name?.contains(searchTerm) ?? false }
            }
        case .productNumbers:
            switch searchTerm.isEmpty {
            case true: return source
            case false: return source.filter { $0.name?.contains(searchTerm) ?? false }
            }
        default: return []
        }
    }

    private func configTextField() {
        rootView.textField.rx.controlEvent(.editingDidBegin)
            .subscribe(onNext: { [unowned self] _ in
                self.dropDownView.dataSource = getDropDownDataSource(with: "")
                self.dropDownView.show()
            })
            .disposed(by: bag)

        rootView.textField.rx.text.orEmpty
            .throttle(.milliseconds(200), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                self.dropDownView.dataSource = getDropDownDataSource(with: $0)
            })
            .disposed(by: bag)
    }

    private func updateCollectionView() {
        rootView.collectionView.reloadData()
        rootView.layoutIfNeeded()
        rootView.collectionViewHeightAnchor.constant = rootView.collectionView.contentSize.height
    }

    @objc
    private func deleteButtonDidTapped(_ sender: UIButton) {
        guard
            let pointInCollectionView = sender.superview?.convert(sender.frame.origin, to: rootView.collectionView),
            let index = rootView.collectionView.indexPathForItem(at: pointInCollectionView)?.item else {
            return
        }
        purchaseQueryRepository.removeAutoCompleteQueryInfo(for: purchaseQueryType, at: index)
        updateCollectionView()
    }
}
// MARK: - Collection view data source
extension PurchaseAutoCompleteSearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch purchaseQueryType {
        case .purchaseNumber:
            return purchaseQueryRepository.currentQueryInfo.purchaseNumbers.count
        case .applicant:
            return purchaseQueryRepository.currentQueryInfo.employeeIDs.count
        case .vendorID:
            return purchaseQueryRepository.currentQueryInfo.vendorIDs.count
        case .productNumbers:
            return purchaseQueryRepository.currentQueryInfo.productNumbers.count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(SelectedQueryCollectionViewCell.self, for: indexPath) as? SelectedQueryCollectionViewCell else {
            fatalError("Wrong cell identifier or not registered yet")
        }
        switch purchaseQueryType {
        case .purchaseNumber:
            let number = purchaseQueryRepository.currentQueryInfo.purchaseNumbers[indexPath.item].number ?? ""
            cell.config(with: number)
        case .vendorID:
            let name = purchaseQueryRepository.currentQueryInfo.vendorIDs[indexPath.item].name ?? ""
            cell.config(with: name)
        case .applicant:
            let name = purchaseQueryRepository.currentQueryInfo.employeeIDs[indexPath.item].name ?? ""
            cell.config(with: name)
        case .productNumbers:
            let number = purchaseQueryRepository.currentQueryInfo.productNumbers[indexPath.item].name ?? ""
            cell.config(with: number)
        default: break
        }
        cell.deleteButton.addTarget(self, action: #selector(deleteButtonDidTapped(_:)), for: .touchUpInside)
        return cell
    }
}
// MARK: - Collection view delegate flow layout
extension PurchaseAutoCompleteSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let extraSpace: CGFloat = 20 + 10 + 10 + 10
        switch purchaseQueryType {
        case .purchaseNumber:
            let nubmers = purchaseQueryRepository.currentQueryInfo.purchaseNumbers
            let width = nubmers[indexPath.item].number?.width(withConstrainedHeight: 20, font: .pingFangTCRegular(ofSize: 14)) ?? 0
            return CGSize(width: width+extraSpace, height: 30)
        case .applicant:
            let nubmers = purchaseQueryRepository.currentQueryInfo.employeeIDs
            let width = nubmers[indexPath.item].name?.width(withConstrainedHeight: 20, font: .pingFangTCRegular(ofSize: 14)) ?? 0
            return CGSize(width: width+extraSpace, height: 30)
        case .vendorID:
            let nubmers = purchaseQueryRepository.currentQueryInfo.vendorIDs
            let width = nubmers[indexPath.item].name?.width(withConstrainedHeight: 20, font: .pingFangTCRegular(ofSize: 14)) ?? 0
            return CGSize(width: width+extraSpace, height: 30)
        case .productNumbers:
            let nubmers = purchaseQueryRepository.currentQueryInfo.productNumbers
            let width = nubmers[indexPath.item].number?.width(withConstrainedHeight: 20, font: .pingFangTCRegular(ofSize: 14)) ?? 0
            return CGSize(width: width+extraSpace, height: 30)
        default:
            return .zero
        }
    }
}
extension PurchaseAutoCompleteSearchViewController: PurchaseFilterChildViewController {
    func reloadData() {
        updateCollectionView()
    }
}
