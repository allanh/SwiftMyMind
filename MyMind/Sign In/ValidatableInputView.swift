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

    private let indicatorImageView: UIImageView = UIImageView {
        $0.translatesAutoresizingMaskIntoConstraints = false
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
        addSubview(indicatorImageView)
        addSubview(errorMessageLabel)
    }

    func activateConstraints() {
        activateConstraintsTextField()
        activateConstraintsIndicatorImageView()
        activateConstraintsErrorMessageLabel(true)
    }

    func showError(with message: String, indicator: UIImage? = nil) {
        textField.layer.borderColor = UIColor(hex: "f5222d").cgColor
        errorMessageLabel.text = message
        errorMessageLabel.isHidden = false
        indicatorImageView.image = indicator
        indicatorImageView.isHidden = (indicator == nil) ? true : false
        errorMessageLabel.removeConstraints(errorMessageLabel.constraints)
        activateConstraintsErrorMessageLabel(indicator != nil)
    }

    func clearError() {
        textField.layer.borderColor = UIColor(hex: "cccccc").cgColor
        errorMessageLabel.isHidden = true
        indicatorImageView.isHidden = true
    }
}
// MARK: - Layout
extension ValidatableInputView {
    private func activateConstraintsTextField() {
        let top = textField.topAnchor.constraint(equalTo: topAnchor)
        let leading = textField.leadingAnchor.constraint(equalTo: leadingAnchor)
        let trailing = textField.trailingAnchor.constraint(equalTo: trailingAnchor)
        let height = textField.heightAnchor.constraint(equalToConstant: 40)

        NSLayoutConstraint.activate([
            top, leading, trailing, height
        ])
    }
    
    private func activateConstraintsIndicatorImageView() {
        let top = indicatorImageView.topAnchor.constraint(equalTo: textField.bottomAnchor)
        let leading = indicatorImageView.leadingAnchor.constraint(equalTo: leadingAnchor)
        let width = indicatorImageView.widthAnchor.constraint(equalToConstant: 16)
        let height = indicatorImageView.heightAnchor.constraint(equalToConstant: 16)

        NSLayoutConstraint.activate([
            top, leading, width, height
        ])
    }
    
    private func activateConstraintsErrorMessageLabel(_ hasIndicator: Bool) {
        if hasIndicator {
            let centerY = errorMessageLabel.centerYAnchor.constraint(equalTo: indicatorImageView.centerYAnchor)
            let leading = errorMessageLabel.leadingAnchor.constraint(equalTo: indicatorImageView.trailingAnchor, constant: 4)
            let trailing = errorMessageLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
            let bottom = errorMessageLabel.bottomAnchor.constraint(equalTo: bottomAnchor)

            NSLayoutConstraint.activate([
                centerY, leading, trailing, bottom
            ])
        } else {
            let top = errorMessageLabel.topAnchor.constraint(equalTo: textField.bottomAnchor)
            let leading = errorMessageLabel.leadingAnchor.constraint(equalTo: leadingAnchor)
            let trailing = errorMessageLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
            let bottom = errorMessageLabel.bottomAnchor.constraint(equalTo: bottomAnchor)

            NSLayoutConstraint.activate([
                top, leading, trailing, bottom
            ])
        }
    }
}
