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
    @IBOutlet weak var suggestedQuantityButton: UIButton!
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
        configureRootView()
        configTextFields()
        configWithSuggestionInfo()
        bindInputToViewModel()
        subscribeViewModel()
        // Do any additional setup after loading the view.
    }

    private func configureRootView() {
        view.layer.cornerRadius = 4
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.separator.cgColor
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
            $0?.textColor = .veryDarkGray
            $0?.setLeftPaddingPoints(10)
            $0?.layer.cornerRadius = 4
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = UIColor.separator.cgColor
            $0?.delegate = self
        })

        purchaseCostPerItemTextField.text = String(viewModel.purchaseCost.value)
        purchaseCostPerItemTextField.text = String(viewModel.purchaseCostPerItem.value)
    }

    private func bindInputToViewModel() {
        purchaseCostPerItemTextField.rx.controlEvent(.editingChanged)
            .map({ [unowned self] in
                self.purchaseCostPerItemTextField.text ?? ""
            })
            .bind(to: viewModel.purchaseCostPerItemInput)
            .disposed(by: bag)

        purchaseQuantityTextField.rx.controlEvent(.editingChanged)
            .map({ [unowned self] in
                self.purchaseQuantityTextField.text ?? ""
            })
            .filter({ $0.count < 7 })
            .bind(to: viewModel.purchaseQuantityInput)
            .disposed(by: bag)

        totalPurchaseCostTextField.rx.controlEvent(.editingChanged)
            .map({ [unowned self] in
                self.totalPurchaseCostTextField.text ?? ""
            })
            .bind(to: viewModel.purchaseCostInput)
            .disposed(by: bag)
        
    }

    private func subscribeViewModel() {
        viewModel.purchaseQuantity
            .map({ String($0) })
            .bind(to: purchaseQuantityTextField.rx.text)
            .disposed(by: bag)

        viewModel.purchaseCost
            .filter({ [unowned self] _ in
                !totalPurchaseCostTextField.isFirstResponder
            })
            .map({ String(format: "%.2f", $0) })
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
        
        viewModel.purchaseMovingCost
            .map { cost in
                let formatter: NumberFormatter = NumberFormatter {
                    $0.numberStyle = .currency
                    $0.currencySymbol = ""
                }
                let value = Double(cost) ?? Double(0)
                let string = formatter.string(from: value as NSNumber) ?? ""
                return "移動平均成本 \(string)"
            }
            .bind(to: purchaseCostPerItemErrorLabel.rx.text)
            .disposed(by: bag)
    }

    private func showErrorMessage(for textField: UITextField, message: String) {
        textField.layer.borderColor = UIColor.systemRed.cgColor
        switch textField {
        case purchaseCostPerItemTextField:
            purchaseCostPerItemErrorLabel.text = message
//            purchaseCostPerItemErrorLabel.isHidden = false
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
//        case purchaseCostPerItemTextField:
//            purchaseCostPerItemErrorLabel.isHidden = true
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
        let currentText = textField.text ?? ""
        guard let replaceRange = Range(range, in: currentText) else {
            print("Can't find range in text field")
            return true
        }
        let newText = currentText.replacingCharacters(in: replaceRange, with: string)

        switch textField {
        case purchaseQuantityTextField:
            return newText.count < 7
        default:

            let invalidCharacters = CharacterSet(charactersIn: "1234567890.").inverted
            guard string.rangeOfCharacter(from: invalidCharacters) == nil else {
                return false
            }

            if newText.isEmpty {
                textField.text = "0"
                textField.sendActions(for: .editingChanged)
                return false
            }

            if currentText.count == 1, currentText == "0", string != "." {
                textField.text = string
                textField.sendActions(for: .editingChanged)
                return false
            }

            if Double(newText) ?? 0 >= 1 {
                let regex = "^(?!(0))(?:(?:[0-9]){1,9}[.][0-9]{0,2}|(?:[0-9]){1,9})$"
                let regexRange = newText.range(of: regex, options: .regularExpression)

                if regexRange == nil {
                    return false
                }
            } else {
                let regex = "^(?:(?:[0]{1})[.][0-9]{0,2}|(?:[0-9]){1,9})$"
                let regexRange = newText.range(of: regex, options: .regularExpression)

                if regexRange == nil {
                    return false
                }
            }

            return true
        }
    }
}
