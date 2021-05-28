//
//  PurchaseQueryDateSelectionViewController.swift
//  MyMind
//
//  Created by Barry Chen on 2021/5/11.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
import RxSwift

class PurchaseQueryDateSelectionViewController: NiblessViewController {
    // MARK: UI
    private let titleLabel: UILabel = UILabel {
        $0.font = .pingFangTCSemibold(ofSize: 18)
        $0.textColor = UIColor(hex: "4c4c4c")
    }

    let firstTextField: CustomClearButtonPositionTextField = CustomClearButtonPositionTextField {
        $0.clearButtonMode = .whileEditing
        $0.font = .pingFangTCRegular(ofSize: 14)
        $0.textColor = UIColor(hex: "4c4c4c")
        $0.setLeftPaddingPoints(10)
        $0.layer.cornerRadius = 4
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.separator.cgColor
        $0.tintColor = .clear
        $0.clearButtonMode = .always
        let containerView = UIView()
        containerView.frame = CGRect(origin: .zero, size: .init(width: 35, height: 25))
        let iconImageView = UIImageView(image: UIImage(named: "calendar_icon"))
        iconImageView.frame = CGRect(origin: .zero, size: .init(width: 25, height: 25))
        containerView.addSubview(iconImageView)
        $0.rightView = containerView
        $0.rightViewMode = .unlessEditing
    }

    let secondTextField: CustomClearButtonPositionTextField = CustomClearButtonPositionTextField {
        $0.clearButtonMode = .whileEditing
        $0.font = .pingFangTCRegular(ofSize: 14)
        $0.textColor = UIColor(hex: "4c4c4c")
        $0.setLeftPaddingPoints(10)
        $0.layer.cornerRadius = 4
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.separator.cgColor
        $0.tintColor = .clear
        $0.clearButtonMode = .always
        let containerView = UIView()
        containerView.frame = CGRect(origin: .zero, size: .init(width: 35, height: 25))
        let iconImageView = UIImageView(image: UIImage(named: "calendar_icon"))
        iconImageView.frame = CGRect(origin: .zero, size: .init(width: 25, height: 25))
        containerView.addSubview(iconImageView)
        $0.rightView = containerView
        $0.rightViewMode = .unlessEditing
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

    let viewModel: PickDatesViewModel
    let bag: DisposeBag = DisposeBag()
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = viewModel.title
        constructViewHierarchy()
        activateConstraints()
        configTextFields()
        bindToViewModel()
        subscribeViewModel()
    }

    // MARK: - Methods
    init(viewModel: PickDatesViewModel) {
        self.viewModel = viewModel
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
    }

    private func bindToViewModel() {
        datePicker.rx.date
            .skip(1)
            .subscribe(onNext: { [unowned self] date in
                self.updateDate(date)
            })
            .disposed(by: bag)
    }

    private func subscribeViewModel() {
        viewModel.startDate
            .map { [unowned self] date in
                if let startDate = date {
                    return self.dateFormatter.string(from: startDate)
                } else {
                    return ""
                }
            }
            .bind(to: firstTextField.rx.text)
            .disposed(by: bag)

        viewModel.endDate
            .map { [unowned self] date in
                if let endDate = date {
                    return self.dateFormatter.string(from: endDate)
                } else {
                    return ""
                }
            }
            .bind(to: secondTextField.rx.text)
            .disposed(by: bag)
    }

    private func updateDate(_ date: Date?) {
        if firstTextField.isFirstResponder {
            viewModel.startDate.accept(date)
        } else {
            viewModel.endDate.accept(date)
        }
    }
}
// MARK: - Text field delegate
extension PurchaseQueryDateSelectionViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        updateDate(nil)
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
extension PurchaseQueryDateSelectionViewController: PurchaseFilterChildViewController {
    func reloadData() {
        firstTextField.text = ""
        secondTextField.text = ""
    }
}
