//
//  PurchaseApplyInfoViewController.swift
//  MyMind
//
//  Created by Barry Chen on 2021/6/10.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
import RxSwift

final class PurchaseApplyInfoViewController: UIViewController {

    @IBOutlet private weak var purchaseIDLabel: UILabel!
    @IBOutlet private weak var vendorNameLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var expectStorageDateTextField: CustomClearButtonPositionTextField!
    @IBOutlet private weak var expectStorageDateErrorLabel: UILabel!
    @IBOutlet private weak var warehouseTextField: CustomClearButtonPositionTextField!
    @IBOutlet private weak var warehouseErrorLabel: UILabel!
    @IBOutlet private weak var recipientNameLabel: UILabel!
    @IBOutlet private weak var recipientPhoneLabel: UILabel!
    @IBOutlet private weak var recipientAddressLabel: UILabel!
    @IBOutlet private weak var checkPurchasedProductsButton: UIButton!

    lazy var dropDownView: DropDownView<Warehouse, DropDownListTableViewCell> = {
        let dropDownView = DropDownView(dataSource: []) { (cell: DropDownListTableViewCell, item) in
            self.configDropDownCell(cell: cell, with: item)
        } selectHandler: { item in
            self.selectedWarehouse(item)
            self.dropDownView.hide()
        }
        return dropDownView
    }()

    private let datePicker: UIDatePicker = UIDatePicker {
        $0.datePickerMode = .date
        if #available(iOS 14.0, *) {
            $0.preferredDatePickerStyle = .wheels
        }
    }

    private let dateFormatter: DateFormatter = DateFormatter {
        $0.dateFormat = "yyyy-MM-dd"
    }

    var viewModel: PurchaseApplyInfoViewModel!
    let bag: DisposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        bindToViewModel()
        subscribeViewModel()
        viewModel.loadWarehouseList()

        configureRootView()
        configureDropDownView()
        configureTextFields()
        configureStatusLabel()
        configureContentWithViewModel()
    }

    private func configureRootView() {
        view.layer.cornerRadius = 4
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.separator.cgColor
    }

    private func bindToViewModel() {
        datePicker.rx.date
            .skip(1)
            .bind(to: viewModel.expectedStorageDate)
            .disposed(by: bag)

        checkPurchasedProductsButton.rx.tap
            .map({ () })
            .bind(to: viewModel.showSuggestionInfo)
            .disposed(by: bag)
    }

    private func subscribeViewModel() {
        viewModel.purchaseID
            .compactMap({ $0 })
            .bind(to: purchaseIDLabel.rx.text)
            .disposed(by: bag)
        
        viewModel.suggestionProductMaterialViewModels
            .map({ "共 \($0.count) 件SKU" })
            .bind(to: checkPurchasedProductsButton.rx.title())
            .disposed(by: bag)

        viewModel.expectedStorageDate
            .map { [unowned self] date -> String in
                guard let date = date else { return "" }
                return dateFormatter.string(from: date)
            }
            .bind(to: expectStorageDateTextField.rx.text)
            .disposed(by: bag)

        viewModel.warehouseList
            .subscribe(onNext: { [unowned self] warehouseList in
                self.dropDownView.dataSource = warehouseList
            })
            .disposed(by: bag)

        viewModel.pickedWarehouse
            .map({ $0?.name })
            .bind(to: warehouseTextField.rx.text)
            .disposed(by: bag)

        viewModel.recipientName
            .bind(to: recipientNameLabel.rx.text)
            .disposed(by: bag)

        viewModel.recipientPhone
            .bind(to: recipientPhoneLabel.rx.text)
            .disposed(by: bag)

        viewModel.recipientAddress
            .bind(to: recipientAddressLabel.rx.text)
            .disposed(by: bag)

        viewModel.expectedStorageDateValidationStatus
            .skip(1)
            .subscribe(onNext: { [unowned self] status in
                self.updateExpectStorageDateTextFieldLayout(validationStatus: status)
            })
            .disposed(by: bag)

        viewModel.pickedWarehouseValidationStatus
            .skip(1)
            .subscribe(onNext: { [unowned self] status in
                self.updateWarehoseTextFieldLayout(validationStatus: status)
            })
            .disposed(by: bag)
    }

    private func configureContentWithViewModel() {
        vendorNameLabel.text = viewModel.venderName
    }

    private func configureDropDownView() {
        dropDownView.topInset = 5
        dropDownView.anchorView = warehouseTextField
    }

    private func configureStatusLabel() {
        statusLabel.layer.borderWidth = 1
        statusLabel.layer.borderColor = UIColor.init(hex: "ff8500").cgColor
        statusLabel.layer.cornerRadius = 4

        statusLabel.textColor = UIColor.init(hex: "ff8500")
    }

    private func configureTextFields() {
        [expectStorageDateTextField, warehouseTextField].forEach {
            guard let textField = $0 else { return }
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor.separator.cgColor
            textField.layer.cornerRadius = 4
            textField.setLeftPaddingPoints(10)
            textField.font = .pingFangTCRegular(ofSize: 14)
            textField.textColor = UIColor(hex: "4c4c4c")
            textField.delegate = self
            let imageName: String = textField == expectStorageDateTextField ? "calendar_icon" : "search"

            configRightIconForTextField(textField, imageName: imageName)
        }

        expectStorageDateTextField.inputView = datePicker
    }

    private func configRightIconForTextField(_ textField: UITextField, imageName: String) {
        let containerView = UIView()
        containerView.frame = CGRect(origin: .zero, size: .init(width: 35, height: 25))
        let iconImageView = UIImageView(image: UIImage(named: imageName))
        iconImageView.frame = CGRect(origin: .zero, size: .init(width: 25, height: 25))
        containerView.addSubview(iconImageView)
        textField.rightView = containerView
        textField.rightViewMode = .always
    }

    private func showSuggestionInfoViewController() {
        #warning("need implement show `SuggestionInfoViewController` logic")
    }

    private func configDropDownCell(cell: DropDownListTableViewCell, with item: Warehouse) {
        cell.titleLabel.text = item.name
    }

    private func selectedWarehouse(_ warehouse: Warehouse) {
        viewModel.pickedWarehouse.accept(warehouse)
    }

    private func updateExpectStorageDateTextFieldLayout(validationStatus: ValidationResult) {
        switch validationStatus {
        case .valid:
            expectStorageDateTextField.layer.borderColor = UIColor.init(hex: "cccccc").cgColor
            expectStorageDateErrorLabel.isHidden = true
        case .invalid(let message):
            expectStorageDateTextField.layer.borderColor = UIColor.systemRed.cgColor
            expectStorageDateErrorLabel.text = message
            expectStorageDateErrorLabel.isHidden = false
        }
    }

    private func updateWarehoseTextFieldLayout(validationStatus: ValidationResult) {
        switch validationStatus {
        case .valid:
            warehouseTextField.layer.borderColor = UIColor.init(hex: "cccccc").cgColor
            warehouseErrorLabel.isHidden = true
        case .invalid(let message):
            warehouseTextField.layer.borderColor = UIColor.systemRed.cgColor
            warehouseErrorLabel.text = message
            warehouseErrorLabel.isHidden = false
        }
    }
}
// MARK: - Text field delegate
extension PurchaseApplyInfoViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == expectStorageDateTextField {
            return true
        } else {
            dropDownView.show()
            return false
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
