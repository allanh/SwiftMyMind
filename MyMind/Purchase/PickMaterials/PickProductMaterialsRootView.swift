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
        $0.sortButton.setTitle("SKU編號", for: .normal)
        $0.stackView.removeArrangedSubview($0.layoutButton)
        $0.stackView.removeArrangedSubview($0.secondSeparatorView)
        $0.layoutButton.removeFromSuperview()
        $0.secondSeparatorView.removeFromSuperview()
    }

    let nextStepButton: UIButton = UIButton {
        $0.titleLabel?.font = .pingFangTCSemibold(ofSize: 16)
        $0.setTitle("下一步", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = UIColor(hex: "004477")
    }

    let viewModel: PickProductMaterialsViewModel
    private let disposeBag: DisposeBag = DisposeBag()

    private var hierarchyNotReady: Bool = true

    init(frame: CGRect = .zero, viewModel: PickProductMaterialsViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = .white
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
    }

    private func activateConstraints() {
        activateConstraintsTableView()
        activateConstraintsOptionView()
        activateConstraintsNextStepButton()
    }

    private func bindToViewModel() {
        organizeOptionView.filterButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.viewModel.view.accept(.filter)
            })
            .disposed(by: disposeBag)

        organizeOptionView.sortButton.rx.tap
            .scan(false, accumulator: { currentState, _ in
                !currentState
            })
            .bind(to: viewModel.isPickSortViewVisible)
            .disposed(by: disposeBag)

        nextStepButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.viewModel.view.accept(.suggestion)
            })
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
}
