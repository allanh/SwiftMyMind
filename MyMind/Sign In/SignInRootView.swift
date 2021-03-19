//
//  SignInRootView.swift
//  MyMind
//
//  Created by Barry Chen on 2021/3/19.
//

import UIKit

class SignInRootView: UIView {

    private let bannerImageView: UIImageView = UIImageView {
        let image = UIImage(named: "my_mind")
        $0.image = image
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private let titleGradientView: GradientView = {
        let view = GradientView(gradientStartColor: UIColor(hex: "f26523"), gradientEndColor: UIColor(hex: "fa9e49"))
        view.layer.cornerRadius = 100
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = UILabel {
        $0.font = UIFont.pingFangTCSemibold(ofSize: 16)
        $0.textColor = .white
        $0.backgroundColor = .clear
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let companyIDInputView: ValidatableInputView = ValidatableInputView {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let accountInputView: ValidatableInputView = ValidatableInputView {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let passwordInputView: ValidatableInputView = ValidatableInputView {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    lazy var inputStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [companyIDInputView, accountInputView, passwordInputView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        return stackView
    }()

    let captchaInputView: ValidatableInputView = ValidatableInputView {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let captchaImageView: UIImageView = UIImageView {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let reloadCaptchaButton: UIButton = UIButton {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let signInButton: UIButton = UIButton {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("登入", for: .normal)
        $0.titleLabel?.font = UIFont.pingFangTCSemibold(ofSize: 16)
        $0.backgroundColor = UIColor(hex: "ff7d2c")
    }

    let resetPasswordButton: UIButton = UIButton {
        $0.setTitle("忘記密碼?", for: .normal)
        let attributedString = NSAttributedString(
            string: "忘記密碼?",
            attributes: [
                NSAttributedString.Key.font: UIFont.pingFangTCRegular(ofSize: 14),
                NSAttributedString.Key.foregroundColor: UIColor(hex: "ff7d2c"),
                NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single
            ])
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        constructViewHeirachy()
        activateConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func constructViewHeirachy() {
        addSubview(bannerImageView)
        addSubview(titleGradientView)
        titleGradientView.addSubview(titleLabel)
        addSubview(inputStackView)
        addSubview(captchaInputView)
        addSubview(captchaImageView)
        addSubview(reloadCaptchaButton)
        addSubview(signInButton)
        addSubview(resetPasswordButton)
    }

    func activateConstraints() {
        activateConstraintsBannerImageView()
        activateConstraintsGradientLabel()
        activateConstraintsTitleLabel()
        activateConstriantsInputView()
        activateConstraintsCaptchaInputView()
        activateConstraintsCaptchaImageView()
        activateConstraintsReloadCaptchaButton()
        activateConstraintsSignInButton()
        activateConstraintsResetPasswordButton()
    }
}
// MARK: - Layout
extension SignInRootView {
    func activateConstraintsBannerImageView() {
        let top = bannerImageView.topAnchor.constraint(equalTo: topAnchor, constant: 30)
        let centerX = bannerImageView.centerXAnchor.constraint(equalTo: centerXAnchor)
        let width = bannerImageView.widthAnchor.constraint(equalToConstant: 173)
        let height = bannerImageView.heightAnchor.constraint(equalToConstant: 72)

        NSLayoutConstraint.activate([
            top, centerX, width, height
        ])
    }

    func activateConstraintsGradientLabel() {
        let top = titleGradientView.topAnchor.constraint(equalTo: bannerImageView.bottomAnchor, constant: 30)
        let leading = titleGradientView.leadingAnchor.constraint(equalTo: leadingAnchor)
        let width = titleGradientView.widthAnchor.constraint(equalToConstant: 126)
        let height = titleGradientView.heightAnchor.constraint(equalToConstant: 30)

        NSLayoutConstraint.activate([
            top, leading, width, height
        ])
    }

    func activateConstraintsTitleLabel() {
        let centerY = titleLabel.centerYAnchor.constraint(equalTo: titleGradientView.centerYAnchor)
        let trailing = titleLabel.trailingAnchor.constraint(equalTo: titleGradientView.trailingAnchor, constant: -12)

        NSLayoutConstraint.activate([
            centerY, trailing
        ])
    }

    func activateConstraintsStackView() {
        let centerY = inputStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        let leading = inputStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50)
        let trailing = inputStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50)

        NSLayoutConstraint.activate([
            centerY, leading, trailing
        ])
    }

    func activateConstriantsInputView() {
        companyIDInputView.heightAnchor.constraint(equalToConstant: 52).isActive = true
    }

    func activateConstraintsCaptchaInputView() {
        let top = captchaInputView.topAnchor.constraint(equalTo: inputStackView.bottomAnchor, constant: 30)
        let leading = captchaInputView.leadingAnchor.constraint(equalTo: inputStackView.leadingAnchor)
        let trailing = captchaInputView.trailingAnchor.constraint(equalTo: captchaImageView.leadingAnchor, constant: -15)
        let height = captchaInputView.heightAnchor.constraint(equalToConstant: 52)

        NSLayoutConstraint.activate([
            top, leading, trailing, height
        ])
    }

    func activateConstraintsCaptchaImageView() {
        let top = captchaImageView.topAnchor.constraint(equalTo: captchaInputView.topAnchor)
        let width = captchaImageView.widthAnchor.constraint(equalToConstant: 115)
        let height = captchaImageView.heightAnchor.constraint(equalToConstant: 32)
        let trailing = captchaImageView.trailingAnchor.constraint(equalTo: reloadCaptchaButton.leadingAnchor)

        NSLayoutConstraint.activate([
            top, width, height, trailing
        ])
    }

    func activateConstraintsReloadCaptchaButton() {
        let trailing = reloadCaptchaButton.trailingAnchor.constraint(equalTo: inputStackView.trailingAnchor)
        let centerY = reloadCaptchaButton.centerYAnchor.constraint(equalTo: captchaImageView.centerYAnchor)
        let width = reloadCaptchaButton.widthAnchor.constraint(equalToConstant: 20)
        let height = reloadCaptchaButton.heightAnchor.constraint(equalTo: reloadCaptchaButton.heightAnchor)

        NSLayoutConstraint.activate([
            trailing, centerY, width, height
        ])
    }

    func activateConstraintsSignInButton() {
        let top = signInButton.topAnchor.constraint(equalTo: captchaInputView.bottomAnchor)
        let leading = signInButton.leadingAnchor.constraint(equalTo: inputStackView.leadingAnchor)
        let trailing = signInButton.trailingAnchor.constraint(equalTo: inputStackView.trailingAnchor)
        let height = signInButton.heightAnchor.constraint(equalToConstant: 40)

        NSLayoutConstraint.activate([
            top, leading, trailing, height
        ])
    }

    func activateConstraintsResetPasswordButton() {
        let top = resetPasswordButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 20)
        let leading = resetPasswordButton.leadingAnchor.constraint(equalTo: inputStackView.leadingAnchor)
        let width = resetPasswordButton.widthAnchor.constraint(equalToConstant: 64)
        let height = resetPasswordButton.heightAnchor.constraint(equalToConstant: 24)

        NSLayoutConstraint.activate([
            top, leading, width, height
        ])
    }
}
