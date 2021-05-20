//
//  PickProductMaterialsViewController.swift
//  MyMind
//
//  Created by Chen Yi-Wei on 2021/5/19.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
import RxSwift

class PickProductMaterialsViewController: NiblessViewController {

    var rootView: PickProductMaterialsRootView {
        view as! PickProductMaterialsRootView
    }

    lazy var pickSortTypeView: PickSortTypeView<ProductMaterialQueryInfo.SortType, SingleLabelTableViewCell> = {
        let pickSortView = PickSortTypeView<ProductMaterialQueryInfo.SortType, SingleLabelTableViewCell>.init(
            dataSource: ProductMaterialQueryInfo.SortType.allCases) { [unowned self] item, cell in
            cell.titleLabel.text = item.description
            let isSelected = self.viewModel.currentQueryInfo.sortType == item
            let textColor = isSelected ? UIColor(hex: "004477") : UIColor(hex: "4c4c4c")
            cell.titleLabel.textColor = textColor
        } cellSelectHandler: { [unowned self] item in
            self.viewModel.currentQueryInfo.sortType = item
        }
        return pickSortView
    }()

    let viewModel: PickProductMaterialsViewModel
    let bag: DisposeBag = DisposeBag()

    // MARK: - View Life Cycle
    override func loadView() {
        super.loadView()
        view = PickProductMaterialsRootView(viewModel: viewModel)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configPickSortView()
        configTableView()
        observerViewModel()
        viewModel.refreshFetchProductMaterials(with: viewModel.currentQueryInfo)
    }
    // MARK: - Methods
    init(viewModel: PickProductMaterialsViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    private func configPickSortView() {
        rootView.addSubview(pickSortTypeView)
        pickSortTypeView.translatesAutoresizingMaskIntoConstraints = false
        let top = pickSortTypeView.topAnchor
            .constraint(equalTo: rootView.topAnchor)
        let leading = pickSortTypeView.leadingAnchor
            .constraint(equalTo: rootView.leadingAnchor)
        let trailing = pickSortTypeView.trailingAnchor
            .constraint(equalTo: rootView.trailingAnchor)
        let bottom = pickSortTypeView.bottomAnchor
            .constraint(equalTo: rootView.organizeOptionView.topAnchor)

        NSLayoutConstraint.activate([
            top, leading, trailing, bottom
        ])
    }

    private func configTableView() {
        rootView.tableView.delegate = self
        rootView.tableView.dataSource = self
        rootView.tableView.registerCell(PickProductMaterialTableViewCell.self)
    }

    private func observerViewModel() {
        viewModel.currentProductMaterials
            .subscribe(on: MainScheduler.instance)
            .skip(1)
            .subscribe(onNext: { [unowned self] _ in
                self.rootView.tableView.reloadData()
            })
            .disposed(by: bag)

        viewModel.view
            .subscribe(onNext: { [unowned self] view in
                self.handleNavigation(with: view)
            })
            .disposed(by: bag)

        viewModel.isPickSortViewVisible
            .subscribe(onNext: { [unowned self] isVisible in
                switch isVisible {
                case true: self.pickSortTypeView.show()
                case false: self.pickSortTypeView.hide()
                }
            })
            .disposed(by: bag)
    }

    private func handleNavigation(with view: PickMaterialView) {

    }

    @objc
    private func didTapCheckBoxButton(_ sender: UIButton) {
        guard
            let pointInTableView = sender.superview?.convert(sender.frame.origin, to: rootView.tableView),
            let indexPath = rootView.tableView.indexPathForRow(at: pointInTableView)
        else {
            return
        }
        rootView.tableView.deselectRow(at: indexPath, animated: true)
        viewModel.selectMaterial(at: indexPath.row)
        sender.isSelected.toggle()
    }
}
// MARK: - Scroll view delegate
extension PickProductMaterialsViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrolledHeight = scrollView.contentOffset.y + scrollView.frame.height
        let scrolledPercentage = scrolledHeight / scrollView.contentSize.height
        let threshold: CGFloat = 0.7
        if scrolledPercentage > threshold {
            viewModel.fetchMoreProductMaterials(with: &viewModel.currentQueryInfo)
        }
    }
}
// MARK: - Table view data source
extension PickProductMaterialsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.currentProductMaterials.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeReusableCell(PickProductMaterialTableViewCell.self, for: indexPath) as? PickProductMaterialTableViewCell else {
            print("----Wrong cell identifier or not register cell yet---")
            return UITableViewCell()
        }
        let material = viewModel.currentProductMaterials.value[indexPath.row]
        cell.config(with: material)
        let isSelected = viewModel.pickedMaterialIDs.contains(material.id)
        cell.checkBoxButton.isSelected = isSelected
        cell.checkBoxButton.addTarget(self, action: #selector(didTapCheckBoxButton(_:)), for: .touchUpInside)
        return cell
    }
}
// MARK: - Table view delegate
extension PickProductMaterialsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.selectMaterial(at: indexPath.row)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
