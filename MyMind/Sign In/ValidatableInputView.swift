//
//  ValidatableInputView.swift
//  MyMind
//
//  Created by Barry Chen on 2021/3/19.
//

import UIKit

class ValidatableInputView: UIView {

    let textField: UITextField = UITextField {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 4
        $0.borderStyle = .none
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(hex: "cccccc").cgColor
        $0.font = UIFont.pingFangTCRegular(ofSize: 14)
    }

    private let errorMessageLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.pingFangTCRegular(ofSize: 12)
        $0.textColor = UIColor(hex: "f5222d")
        $0.isHidden = true
    }

    // MARK: - Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        constructViewHeirachy()
        activateConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func constructViewHeirachy() {
        addSubview(textField)
        addSubview(errorMessageLabel)
    }

    func activateConstraints() {
        activateConstraintsTextField()
        activateConstraintsErrorMessageLabel()
    }

    func showError(with message: String) {
        textField.layer.borderColor = UIColor(hex: "f5222d").cgColor
        errorMessageLabel.text = message
        errorMessageLabel.isHidden = false
    }

    func clearError() {
        textField.layer.borderColor = UIColor(hex: "cccccc").cgColor
        errorMessageLabel.isHidden = true
    }
}
// MARK: - Layout
extension ValidatableInputView {
    private func activateConstraintsTextField() {
        let top = textField.topAnchor.constraint(equalTo: topAnchor)
        let leading = textField.leadingAnchor.constraint(equalTo: leadingAnchor)
        let trailing = textField.trailingAnchor.constraint(equalTo: trailingAnchor)
        let height = textField.heightAnchor.constraint(equalToConstant: 32)

        NSLayoutConstraint.activate([
            top, leading, trailing, height
        ])
    }

    private func activateConstraintsErrorMessageLabel() {
        let top = errorMessageLabel.topAnchor.constraint(equalTo: textField.bottomAnchor)
        let leading = errorMessageLabel.leadingAnchor.constraint(equalTo: leadingAnchor)
        let trailing = errorMessageLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        let bottom = errorMessageLabel.bottomAnchor.constraint(equalTo: bottomAnchor)

        NSLayoutConstraint.activate([
            top, leading, trailing, bottom
        ])
    }
}
