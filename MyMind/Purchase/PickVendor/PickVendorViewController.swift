//
//  PickVendorViewController.swift
//  MyMind
//
//  Created by Barry Chen on 2021/5/31.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
import PromiseKit

struct VendorInfo {
    let id: String
    let name: String
}

protocol VendorInfoService {
    func fetchVendorInfos(with name: String) -> Promise<[VendorInfo]>
}

struct VendorInfoAdapter: VendorInfoService {
    let service: AutoCompleteAPIService

    func fetchVendorInfos(with name: String) -> Promise<[VendorInfo]> {
        service.vendorNameAutoComplete(searchTerm: name)
            .map { list in
                let items = list.item
                return items.compactMap { autoCompleteInfo in
                    guard let id = autoCompleteInfo.id,
                          let name = autoCompleteInfo.name
                    else { return nil }
                    return VendorInfo(id: id, name: name)
                }
            }
    }
}

class PickVendorViewController: UITableViewController {
    let searchTextFieldView: AutoCompleteSearchRootView = AutoCompleteSearchRootView()

    let service: VendorInfoService
    var vendorInfos: [VendorInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchVendors()
    }

    init(service: VendorInfoService, style: UITableView.Style = .grouped) {
        self.service = service
        super.init(style: style)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configTableView() {
        tableView.rowHeight = 44
        tableView.sectionHeaderHeight = 80
    }

    private func fetchVendors() {
        guard let searchTerm = searchTextFieldView.textField.text else { return }
        service.fetchVendorInfos(with: searchTerm)
            .done({ [weak self] infos in
                guard let self = self else { return }
                self.vendorInfos = infos
                self.tableView.reloadData()
            })
            .catch { error in
                print(error.localizedDescription)
            }
    }
}

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

extension PickVendorViewController {
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        searchTextFieldView.collectionView.removeFromSuperview()
        return searchTextFieldView
    }
}

class VendorSelectionTableViewCell: UITableViewCell {
    let titleLabel: UILabel = UILabel {
        $0.font = .pingFangTCRegular(ofSize: 16)
        $0.textColor = UIColor(hex: "4c4c4c")
    }

    let arrowImageView: UIImageView = UIImageView {
        $0.image = UIImage(named: "forward_arrow")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        constructViewHierarchy()
        activateConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func config(with vendorName: String) {
        titleLabel.text = vendorName
    }

    private func constructViewHierarchy() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(arrowImageView)
    }

    private func activateConstraints() {
        activateConstraintsTitleLabel()
        activateConstraintsArrowImageView()
    }

    private func activateConstraintsTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let centerY = titleLabel.centerYAnchor
            .constraint(equalTo: contentView.centerYAnchor)
        let leading = titleLabel.leadingAnchor
            .constraint(equalTo: contentView.leadingAnchor, constant: 15)
        NSLayoutConstraint.activate([
            centerY, leading
        ])
    }

    private func activateConstraintsArrowImageView() {
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        let centerY = arrowImageView.centerYAnchor
            .constraint(equalTo: titleLabel.centerYAnchor)
        let trailing = arrowImageView.trailingAnchor
            .constraint(equalTo: contentView.trailingAnchor, constant: -20)
        let width = arrowImageView.widthAnchor
            .constraint(equalToConstant: 25)
        let height = arrowImageView.heightAnchor
            .constraint(equalTo: arrowImageView.widthAnchor)

        NSLayoutConstraint.activate([
            centerY, trailing, height, width
        ])
    }
}
