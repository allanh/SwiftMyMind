//
//  PickProductMaterialsRootView.swift
//  MyMind
//
//  Created by Chen Yi-Wei on 2021/5/19.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
import RxSwift

class PickProductMaterialsRootView: NiblessView {
    // MARK: - Properties
    let tableView: UITableView = UITableView {
        $0.backgroundColor = .white
    }

    let organizeOptionView: OrganizeOptionView = OrganizeOptionView {
        $0.backgroundColor = .white
        $0.displayType = [.sort, .filter]
        $0.setup()
        $0.sortButton.setTitle("SKU編號", for: .normal)
    }

    let nextStepButton: UIButton = UIButton {
        $0.titleLabel?.font = .pingFangTCSemibold(ofSize: 16)
        $0.setTitle("下一步", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .prussianBlue
    }

    lazy var pickSortTypeView: PickSortTypeView<ProductMaterialQueryInfo.SortType, SingleLabelTableViewCell> = {
        let pickSortView = PickSortTypeView<ProductMaterialQueryInfo.SortType, SingleLabelTableViewCell>.init(
            dataSource: ProductMaterialQueryInfo.SortType.allCases) { [unowned self] sortType, cell in
            cell.titleLabel.text = sortType.description
            let isSelected = self.viewModel.currentQueryInfo.sortType == sortType
            let textColor = isSelected ? .prussianBlue : UIColor(hex: "4c4c4c")
            cell.titleLabel.textColor = textColor
        } cellSelectHandler: { [unowned self] sortType in
            self.viewModel.currentSortType.accept(sortType)
            self.pickSortTypeView.hide()
        }
        pickSortView.tableView.separatorStyle = .none
        return pickSortView
    }()

    let viewModel: PickProductMaterialsViewModel
    private let disposeBag: DisposeBag = DisposeBag()

    private var hierarchyNotReady: Bool = true

    init(frame: CGRect = .zero, viewModel: PickProductMaterialsViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = .white
        bindToViewModel()
        subscribeViewModel()
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard hierarchyNotReady else { return }
        constructViewHierarchy()
        activateConstraints()
        hierarchyNotReady = false
    }
    // MARK: - Methods
    private func constructViewHierarchy() {
        addSubview(tableView)
        addSubview(organizeOptionView)
        addSubview(nextStepButton)
        addSubview(pickSortTypeView)
    }

    private func activateConstraints() {
        activateConstraintsTableView()
        activateConstraintsOptionView()
        activateConstraintsNextStepButton()
        activateConstraintsPickSortTypeView()
    }

    private func bindToViewModel() {
        organizeOptionView.filterButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.viewModel.showFilter()
            })
            .disposed(by: disposeBag)

        organizeOptionView.sortButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                switch self.pickSortTypeView.isHidden {
                case true: self.pickSortTypeView.show()
                case false: self.pickSortTypeView.hide()
                }
            })
            .disposed(by: disposeBag)

        nextStepButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.viewModel.pushSuggestion()
            })
            .disposed(by: disposeBag)
    }

    private func subscribeViewModel() {
        viewModel.currentSortType
            .map { $0.description }
            .bind(to: organizeOptionView.sortButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
    }
}
// MARK: - Layouts
extension PickProductMaterialsRootView {
    private func activateConstraintsTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let top = tableView.topAnchor
            .constraint(equalTo: topAnchor)
        let leading = tableView.leadingAnchor
            .constraint(equalTo: leadingAnchor)
        let trailing = tableView.trailingAnchor
            .constraint(equalTo: trailingAnchor)
        let bottom = tableView.bottomAnchor
            .constraint(equalTo: organizeOptionView.topAnchor)
        NSLayoutConstraint.activate([
            top, leading, trailing, bottom
        ])
    }

    private func activateConstraintsOptionView() {
        organizeOptionView.translatesAutoresizingMaskIntoConstraints = false
        let leading = organizeOptionView.leadingAnchor
            .constraint(equalTo: leadingAnchor)
        let bottom = organizeOptionView.bottomAnchor
            .constraint(equalTo: nextStepButton.topAnchor)
        let trailing = organizeOptionView.trailingAnchor
            .constraint(equalTo: trailingAnchor)
        let height = organizeOptionView.heightAnchor
            .constraint(equalToConstant: 40)
        NSLayoutConstraint.activate([
            leading, bottom, trailing, height
        ])
    }

    private func activateConstraintsNextStepButton() {
        nextStepButton.translatesAutoresizingMaskIntoConstraints = false
        let leading = nextStepButton.leadingAnchor
            .constraint(equalTo: leadingAnchor)
        let bottom = nextStepButton.bottomAnchor
            .constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        let trailing = nextStepButton.trailingAnchor
            .constraint(equalTo: trailingAnchor)
        let height = nextStepButton.heightAnchor
            .constraint(equalToConstant: 50)

        NSLayoutConstraint.activate([
            leading, bottom, trailing, height
        ])
    }

    private func activateConstraintsPickSortTypeView() {
        pickSortTypeView.translatesAutoresizingMaskIntoConstraints = false
        let top = pickSortTypeView.topAnchor
            .constraint(equalTo: topAnchor)
        let leading = pickSortTypeView.leadingAnchor
            .constraint(equalTo: leadingAnchor)
        let trailing = pickSortTypeView.trailingAnchor
            .constraint(equalTo: trailingAnchor)
        let bottom = pickSortTypeView.bottomAnchor
            .constraint(equalTo: organizeOptionView.topAnchor)

        NSLayoutConstraint.activate([
            top, leading, trailing, bottom
        ])
    }
}
