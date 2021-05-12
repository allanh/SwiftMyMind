//
//  PurchaseQueryDateSelectionViewController.swift
//  MyMind
//
//  Created by Barry Chen on 2021/5/11.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class PurchaseQueryDateSelectionViewController: NiblessViewController {
    // MARK: - Properties
    let purchaseQueryRepository: PurchaseQueryRepository
    let purchaseQueryType: PurchaseQueryType

    // MARK: UI
    private let titleLabel: UILabel = UILabel {
        $0.font = .pingFangTCSemibold(ofSize: 18)
        $0.textColor = UIColor(hex: "4c4c4c")
    }

    let firstTextField: UITextField = UITextField {
        $0.clearButtonMode = .whileEditing
        $0.font = .pingFangTCRegular(ofSize: 14)
        $0.textColor = UIColor(hex: "4c4c4c")
        $0.setLeftPaddingPoints(10)
        $0.layer.cornerRadius = 4
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.separator.cgColor
        $0.tintColor = .clear
        $0.clearButtonMode = .always
    }

    let secondTextField: UITextField = UITextField {
        $0.clearButtonMode = .whileEditing
        $0.font = .pingFangTCRegular(ofSize: 14)
        $0.textColor = UIColor(hex: "4c4c4c")
        $0.setLeftPaddingPoints(10)
        $0.layer.cornerRadius = 4
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.separator.cgColor
        $0.tintColor = .clear
        $0.clearButtonMode = .always
    }

    private let datePicker: UIDatePicker = UIDatePicker {
        $0.datePickerMode = .date
        if #available(iOS 14.0, *) {
            $0.preferredDatePickerStyle = .wheels
        }
    }

    private let dateFormatter: DateFormatter = DateFormatter {
        $0.dateFormat = "yyyy-MM-dd"
    }
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = purchaseQueryType.description
        constructViewHierarchy()
        activateConstraints()
        configTextFields()
    }

    // MARK: - Methods
    init(
        purchaseQueryRepository: PurchaseQueryRepository,
        purchaseQueryType: PurchaseQueryType
    ) {
        self.purchaseQueryType = purchaseQueryType
        self.purchaseQueryRepository = purchaseQueryRepository
        super.init()
    }

    func constructViewHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(firstTextField)
        view.addSubview(secondTextField)
    }

    func activateConstraints() {
        activateConstraintsTitleLabel()
        activateConstraintsFirstTextField()
        activateConstraintsSecondTextField()
    }

    func configTextFields() {
        firstTextField.delegate = self
        secondTextField.delegate = self
        firstTextField.inputView = datePicker
        secondTextField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(datePickerDidPickDate(_:)), for: .valueChanged)
    }

    @objc
    private func datePickerDidPickDate(_ sender: UIDatePicker) {
        let date = sender.date
        updateDate(with: date)
        updateTextFieldContent(with: date)
    }

    private func updateDate(with date: Date?) {
        switch purchaseQueryType {
        case .expectPutInStoragePeriod:
            if firstTextField.isFirstResponder {
                purchaseQueryRepository.updateExpectStorageStartDate(date: date)
            } else {
                purchaseQueryRepository.updateExpectStorageEndDate(date: date)
            }
        case .createdPeriod:
            if firstTextField.isFirstResponder {
                purchaseQueryRepository.updateCreatDateStart(date: date)
            } else {
                purchaseQueryRepository.updateCreatDateEnd(date: date)
            }
        default: return
        }
    }

    private func updateTextFieldContent(with date: Date) {
        let dateInString = dateFormatter.string(from: date)
        if firstTextField.isFirstResponder {
            firstTextField.text = dateInString
        } else {
            secondTextField.text = dateInString
        }
    }
}
// MARK: - Text field delegate
extension PurchaseQueryDateSelectionViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        updateDate(with: nil)
        textField.text = ""
        return false
    }
}
// MARK: - Layouts
extension PurchaseQueryDateSelectionViewController {
    private func activateConstraintsTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let top = titleLabel.topAnchor
            .constraint(equalTo: view.topAnchor, constant: 15)
        let leading = titleLabel.leadingAnchor
            .constraint(equalTo: view.leadingAnchor, constant: 20)

        NSLayoutConstraint.activate([
            top, leading
        ])
    }

    private func activateConstraintsFirstTextField() {
        firstTextField.translatesAutoresizingMaskIntoConstraints = false
        let top = firstTextField.topAnchor
            .constraint(equalTo: titleLabel.bottomAnchor, constant: 15)
        let leading = firstTextField.leadingAnchor
            .constraint(equalTo: view.leadingAnchor, constant: 20)
        let trailing = firstTextField.trailingAnchor
            .constraint(equalTo: view.trailingAnchor, constant: -20)
        let height = firstTextField.heightAnchor
            .constraint(equalToConstant: 40)

        NSLayoutConstraint.activate([
            top, leading, trailing, height
        ])
    }

    private func activateConstraintsSecondTextField() {
        secondTextField.translatesAutoresizingMaskIntoConstraints = false
        let top = secondTextField.topAnchor
            .constraint(equalTo: firstTextField.bottomAnchor, constant: 10)
        let leading = secondTextField.leadingAnchor
            .constraint(equalTo: firstTextField.leadingAnchor)
        let trailing = secondTextField.trailingAnchor
            .constraint(equalTo: firstTextField.trailingAnchor)
        let height = secondTextField.heightAnchor
            .constraint(equalTo: firstTextField.heightAnchor)
        let bottom = secondTextField.bottomAnchor
            .constraint(equalTo: view.bottomAnchor, constant: -10)

        NSLayoutConstraint.activate([
            top, leading, trailing, height, bottom
        ])
    }
}
