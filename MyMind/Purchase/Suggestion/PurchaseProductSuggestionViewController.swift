//
//  PurchaseProductSuggestionViewController.swift
//  MyMind
//
//  Created by Chen Yi-Wei on 2021/6/2.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher

class PurchaseProductSuggestionViewController: UIViewController {

    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var numberLabel: UILabel!
    @IBOutlet private weak var originalNumberLabel: UILabel!
    @IBOutlet private weak var suggestedQuantityButton: UIButton!
    @IBOutlet private weak var suggestedQuantityLabel: UILabel!
    @IBOutlet private weak var purchaseCostPerItemTextField: CustomClearButtonPositionTextField!
    @IBOutlet private weak var purchaseCostPerItemErrorLabel: UILabel!
    @IBOutlet private weak var purchaseQuantityTextField: CustomClearButtonPositionTextField!
    @IBOutlet private weak var purchaseQuantityErrorLabel: UILabel!
    @IBOutlet private weak var unitLabel: UILabel!
    @IBOutlet private weak var boxCounterLabel: UILabel!
    @IBOutlet private weak var totalPurchaseCostTextField: CustomClearButtonPositionTextField!
    @IBOutlet private weak var totalPurchaseCostErrorLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!

    var viewModel: SuggestionProductMaterialViewModel!

    let bag: DisposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        configTextFields()
        configWithSuggestionInfo()
        bindInputToViewModel()
        subscribeViewModel()
        // Do any additional setup after loading the view.
    }

    private func configWithSuggestionInfo() {
        if let url = viewModel.imageURL {
            productImageView.kf.setImage(with: url)
        }
        nameLabel.text = viewModel.name
        numberLabel.text = viewModel.number
        originalNumberLabel.text = viewModel.number
        suggestedQuantityLabel.text = viewModel.purchaseSuggestionQuantity
        unitLabel.text = viewModel.stockUnitName
    }

    private func configTextFields() {
        let textFields = [purchaseCostPerItemTextField, purchaseQuantityTextField, totalPurchaseCostTextField]
        textFields.forEach({
            $0?.font = .pingFangTCRegular(ofSize: 14)
            $0?.textColor = UIColor(hex: "4c4c4c")
            $0?.setLeftPaddingPoints(10)
            $0?.layer.cornerRadius = 4
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = UIColor.separator.cgColor
            $0?.delegate = self
        })
    }

    private func bindInputToViewModel() {
        purchaseCostPerItemTextField.rx.text
            .orEmpty
            .skip(1)
            .bind(to: viewModel.purchaseCostPerItemInput)
            .disposed(by: bag)

        purchaseQuantityTextField.rx.text
            .orEmpty
            .skip(1)
            .filter({ $0.count < 7 })
            .debug()
            .bind(to: viewModel.purchaseQuantityInput)
            .disposed(by: bag)

        totalPurchaseCostTextField.rx.text
            .orEmpty
            .skip(1)
            .bind(to: viewModel.purchaseCostInput)
            .disposed(by: bag)
    }

    private func subscribeViewModel() {
        viewModel.purchaseCostPerItem
            .map({ String($0) })
            .bind(to: purchaseCostPerItemTextField.rx.text)
            .disposed(by: bag)

        viewModel.purchaseQuantity
            .map({ String($0) })
            .bind(to: purchaseQuantityTextField.rx.text)
            .disposed(by: bag)

        viewModel.purchaseCost
            .map({ String($0) })
            .bind(to: totalPurchaseCostTextField.rx.text)
            .disposed(by: bag)

        viewModel.totalBox
            .map({ [unowned self] in
                    "=(\(String($0)) \(self.viewModel.boxStockUnitName))"
            })
            .bind(to: boxCounterLabel.rx.text)
            .disposed(by: bag)

        viewModel.validationStatusForpurchaseCostPerItem
            .skip(1)
            .subscribe(onNext: { [unowned self] validationStatus in
                switch validationStatus {
                case .valid: self.cleanErrorMessage(for: purchaseCostPerItemTextField)
                case .invalid(let message): self.showErrorMessage(for: purchaseCostPerItemTextField, message: message)
                }
            })
            .disposed(by: bag)

        viewModel.validationStatusForPurchaseQuantity
            .skip(1)
            .subscribe(onNext: { [unowned self] validationStatus in
                switch validationStatus {
                case .valid: self.cleanErrorMessage(for: purchaseQuantityTextField)
                case .invalid(let message): self.showErrorMessage(for: purchaseQuantityTextField, message: message)
                }
            })
            .disposed(by: bag)

        viewModel.validationStatusForPurchaseCost
            .skip(1)
            .subscribe(onNext: { [unowned self] validationStatus in
                switch validationStatus {
                case .valid: self.cleanErrorMessage(for: totalPurchaseCostTextField)
                case .invalid(let message): self.showErrorMessage(for: totalPurchaseCostTextField, message: message)
                }
            })
            .disposed(by: bag)
    }

    private func showErrorMessage(for textField: UITextField, message: String) {
        textField.layer.borderColor = UIColor.systemRed.cgColor
        switch textField {
        case purchaseCostPerItemTextField:
            purchaseCostPerItemErrorLabel.text = message
            purchaseCostPerItemErrorLabel.isHidden = false
        case purchaseQuantityTextField:
            purchaseQuantityErrorLabel.text = message
            purchaseQuantityErrorLabel.isHidden = false
        case totalPurchaseCostTextField:
            totalPurchaseCostErrorLabel.text = message
            totalPurchaseCostErrorLabel.isHidden = false
        default: break
        }
    }

    private func cleanErrorMessage(for textField: UITextField) {
        textField.layer.borderColor = UIColor.separator.cgColor
        switch textField {
        case purchaseCostPerItemTextField:
            purchaseCostPerItemErrorLabel.isHidden = true
        case purchaseQuantityTextField:
            purchaseQuantityErrorLabel.isHidden = true
        case totalPurchaseCostTextField:
            totalPurchaseCostErrorLabel.isHidden = true
        default: break
        }
    }
}
// MARK: - Text field delegate
extension PurchaseProductSuggestionViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textField = purchaseQuantityTextField else { return true }
        let currentText = textField.text ?? ""
        guard let replaceRange = Range(range, in: currentText) else {
            print("Can't find range in text field")
            return true
        }
        let newText = currentText.replacingCharacters(in: replaceRange, with: string)
        return newText.count < 7
    }
}
