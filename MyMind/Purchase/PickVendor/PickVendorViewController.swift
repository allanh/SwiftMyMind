//
//  PickVendorViewController.swift
//  MyMind
//
//  Created by Barry Chen on 2021/5/31.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
import PromiseKit
import RxSwift

final class PickVendorViewController: UITableViewController {
    // MARK: - Properties
    let searchTextFieldView: AutoCompleteSearchRootView = AutoCompleteSearchRootView {
        $0.backgroundColor = .white
        $0.titleLabel.text = "搜尋供應商"
    }

    let loader: VendorInfoLoader
    var vendorInfos: [VendorInfo] = []
    let bag: DisposeBag = DisposeBag()

    // MARK: - View life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        subscribeTextField()
    }
    // MARK: - Methods
    init(loader: VendorInfoLoader, style: UITableView.Style = .plain) {
        self.loader = loader
        super.init(style: style)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configTableView() {
        tableView.rowHeight = 44
        tableView.sectionHeaderHeight = 115
        tableView.registerCell(VendorSelectionTableViewCell.self)
        tableView.separatorInset = .init(top: 0, left: 20, bottom: 0, right: 20)
    }

    private func fetchVendors(with searchTerm: String) {
        loader.loadVendorInfos(with: searchTerm)
            .done({ [weak self] infos in
                guard let self = self else { return }
                self.vendorInfos = infos
                self.tableView.reloadData()
            })
            .catch { error in
                print(error.localizedDescription)
            }
    }

    private func subscribeTextField() {
        searchTextFieldView.textField.rx.text.orEmpty
            .throttle(.milliseconds(200), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] text in
                self.fetchVendors(with: text)
            })
            .disposed(by: bag)
    }
}
// MARK: - Table view data source
extension PickVendorViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vendorInfos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeReusableCell(VendorSelectionTableViewCell.self, for: indexPath) as? VendorSelectionTableViewCell else {
            return UITableViewCell()
        }
        let vendor = vendorInfos[indexPath.row]
        cell.config(with: vendor.name)
        return cell
    }
}
// MARK: - Table view delegate
extension PickVendorViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vendor = vendorInfos[indexPath.row]
        let service = MyMindPurchaseAPIService.shared
        let viewModel = PickProductMaterialsViewModel(vendorInfo: vendor, loader: service)
        let viewController = PickProductMaterialsViewController(viewModel: viewModel)
        show(viewController, sender: nil)
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        searchTextFieldView.collectionView.removeFromSuperview()
        return searchTextFieldView
    }
}
