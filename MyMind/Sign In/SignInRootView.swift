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
        $0.text = "管理後台"
        $0.textColor = .white
        $0.backgroundColor = .clear
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let companyIDInputView: ValidatableInputView = ValidatableInputView {
        $0.textField.placeholder = "企業編碼-5~8碼"
        let image = UIImage(named: "company")
        let containerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 30, height: 30)))
        let imageView = UIImageView(frame: CGRect(x: 8, y: containerView.frame.midY-7, width: 14, height: 14))
        imageView.image = image
        containerView.addSubview(imageView)
        $0.textField.leftView = containerView
        $0.textField.leftViewMode = .always
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let accountInputView: ValidatableInputView = ValidatableInputView {
        $0.textField.placeholder = "使用者帳號-3~20碼"
        let image = UIImage(named: "id")
        let containerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 30, height: 30)))
        let imageView = UIImageView(frame: CGRect(x: 8, y: containerView.frame.midY-7, width: 14, height: 14))
        imageView.image = image
        containerView.addSubview(imageView)
        $0.textField.leftView = containerView
        $0.textField.leftViewMode = .always
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let passwordInputView: ValidatableInputView = ValidatableInputView {
        $0.textField.placeholder = "密碼-6~20碼，英文字母需區分大小寫"
        let image = UIImage(named: "lock")
        let containerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 30, height: 30)))
        let imageView = UIImageView(frame: CGRect(x: 8, y: containerView.frame.midY-7, width: 14, height: 14))
        imageView.image = image
        containerView.addSubview(imageView)
        $0.textField.leftView = containerView
        $0.textField.leftViewMode = .always
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    lazy var inputStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [companyIDInputView, accountInputView, passwordInputView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()

    let captchaInputView: ValidatableInputView = ValidatableInputView {
        $0.textField.placeholder = "驗證碼-6碼"
        let image = UIImage(named: "security")
        let containerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 30, height: 30)))
        let imageView = UIImageView(frame: CGRect(x: 8, y: containerView.frame.midY-7, width: 14, height: 14))
        imageView.image = image
        containerView.addSubview(imageView)
        $0.textField.leftView = containerView
        $0.textField.leftViewMode = .always
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let captchaImageView: UIImageView = UIImageView {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let reloadCaptchaButton: UIButton = UIButton {
        $0.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "reload")
        $0.setImage(image, for: .normal)
    }

    let signInButton: UIButton = UIButton {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("登入", for: .normal)
        $0.titleLabel?.font = UIFont.pingFangTCSemibold(ofSize: 16)
        $0.backgroundColor = UIColor(hex: "ff7d2c")
        $0.layer.cornerRadius = 4
    }

    let resetPasswordButton: UIButton = UIButton {
        let attributedString = NSAttributedString(
            string: "忘記密碼?",
            attributes: [
                NSAttributedString.Key.font: UIFont.pingFangTCRegular(ofSize: 14),
                NSAttributedString.Key.foregroundColor: UIColor(hex: "ff7d2c"),
                NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                NSAttributedString.Key.underlineColor: UIColor(hex: "ff7d2c")
            ])
        $0.setAttributedTitle(attributedString, for: .normal)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        constructViewHeirachy()
        activateConstraints()
        backgroundColor = .white
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
        activateConstraintsStackView()
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
        let centerY = bannerImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -250)
        let centerX = bannerImageView.centerXAnchor.constraint(equalTo: centerXAnchor)
        let width = bannerImageView.widthAnchor.constraint(equalToConstant: 173)
        let height = bannerImageView.heightAnchor.constraint(equalToConstant: 72)

        NSLayoutConstraint.activate([
            centerY, centerX, width, height
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
//        let top = inputStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50)
        let centerY = inputStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        let leading = inputStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50)
        let trailing = inputStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50)

        NSLayoutConstraint.activate([
            centerY, leading, trailing
        ])
    }

    func activateConstriantsInputView() {
        companyIDInputView.heightAnchor.constraint(equalToConstant: 52).isActive = true
        accountInputView.heightAnchor.constraint(equalToConstant: 52).isActive = true
        passwordInputView.heightAnchor.constraint(equalToConstant: 52).isActive = true
    }

    func activateConstraintsCaptchaInputView() {
        let top = captchaInputView.topAnchor.constraint(equalTo: inputStackView.bottomAnchor)
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
