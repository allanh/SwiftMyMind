//
//  ResendOTPRootView.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/19.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
import RxSwift
import NVActivityIndicatorView

class ResendOTPRootView: NiblessView {
    var hierarchyNotReady: Bool = true
    let bag: DisposeBag = DisposeBag()
    let viewModel: ResendOTPViewModel

    private let scrollView: UIScrollView = UIScrollView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.showsVerticalScrollIndicator = false
    }
    private let contentView: UIView = UIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
    }

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

    private let resendOTPTitleLabel: UILabel = UILabel {
        $0.font = UIFont.pingFangTCSemibold(ofSize: 16)
        $0.text = "補發APP QR Code"
        $0.textColor = UIColor(hex: "306ab2")
        $0.backgroundColor = .clear
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private let resendOTPDescriptionLabel: UILabel = UILabel {
        $0.font = UIFont.pingFangTCRegular(ofSize: 14)
        $0.text = "1.請輸入以下資料，我們將重新發送【Mymind買賣-登入驗證APP綁定通知信】\n2.請安裝Mymind OTP APP，掃描信中驗證QR Code，即可產生APP驗證碼。"
        $0.numberOfLines = 0
        $0.textColor = UIColor(hex: "306ab2")
        $0.backgroundColor = .clear
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private let storeIDInputView: ValidatableInputView = ValidatableInputView {
        $0.textField.attributedPlaceholder = NSAttributedString(
            string: "企業編碼-5~8碼",
            attributes: [.foregroundColor: UIColor(hex: "b4b4b4")]
        )
        $0.textField.textColor = UIColor(hex: "545454")
        let containerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 10, height: 30)))
        $0.textField.leftView = containerView
        $0.textField.leftViewMode = .always
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private let accountInputView: ValidatableInputView = ValidatableInputView {
        $0.textField.attributedPlaceholder = NSAttributedString(
            string: "使用者帳號-3~20碼",
            attributes: [.foregroundColor: UIColor(hex: "b4b4b4")]
        )
        $0.textField.textColor = UIColor(hex: "545454")
        let containerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 10, height: 30)))
        $0.textField.leftView = containerView
        $0.textField.leftViewMode = .always
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private let passwordSecureButton: UIButton = UIButton {
        $0.setImage(UIImage(named: "eye_open"), for: .normal)
        $0.setImage(UIImage(named: "eye_close"), for: .selected)
        $0.touchEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
    }

    private lazy var passwordInputView: ValidatableInputView = ValidatableInputView {
        $0.textField.attributedPlaceholder = NSAttributedString(
            string: "輸入密碼",
            attributes: [.foregroundColor: UIColor(hex: "b4b4b4")]
        )
        $0.textField.textColor = UIColor(hex: "545454")
        let image = UIImage(named: "lock")
        let leftContainerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 30, height: 30)))
        let imageView = UIImageView(frame: CGRect(x: 8, y: leftContainerView.frame.midY-7, width: 14, height: 14))
        imageView.image = image
        leftContainerView.addSubview(imageView)
        $0.textField.leftView = leftContainerView
        $0.textField.leftViewMode = .always

        let rightContainerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 30, height: 30)))
        self.passwordSecureButton.frame = CGRect(x: 8, y: rightContainerView.frame.midY-7, width: 14, height: 14)
        rightContainerView.addSubview(self.passwordSecureButton)
        $0.textField.rightView = rightContainerView
        $0.textField.rightViewMode = .always
        $0.textField.isSecureTextEntry = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private let emailInputView: ValidatableInputView = ValidatableInputView {
        $0.textField.attributedPlaceholder = NSAttributedString(
            string: "輸入 Email",
            attributes: [.foregroundColor: UIColor(hex: "b4b4b4")]
        )
        $0.textField.textColor = UIColor(hex: "545454")
        let containerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 10, height: 30)))
        $0.textField.leftView = containerView
        $0.textField.leftViewMode = .always
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private lazy var inputStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [storeIDInputView, accountInputView, passwordInputView, emailInputView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    private let confirmButton: UIButton = UIButton {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("確定", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.setTitleColor(UIColor(hex: "b4b4b4"), for: .disabled)
        $0.titleLabel?.font = UIFont.pingFangTCSemibold(ofSize: 16)
        $0.backgroundColor = UIColor(hex: "ff7d2c")
        $0.layer.cornerRadius = 4
    }

    // MARK: - Methods
    init(frame: CGRect = .zero,
         viewModel: ResendOTPViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        bindToViewModel()
        bindViewModelToViews()
    }
    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard hierarchyNotReady else {
          return
        }
        constructViewHierarchy()
        activateConstraints()
        backgroundColor = .white
        hierarchyNotReady = false
    }

    private func constructViewHierarchy() {
        scrollView.addSubview(contentView)
        contentView.addSubview(bannerImageView)
        contentView.addSubview(titleGradientView)
        titleGradientView.addSubview(titleLabel)
        contentView.addSubview(resendOTPTitleLabel)
        contentView.addSubview(resendOTPDescriptionLabel)
        contentView.addSubview(inputStackView)
        contentView.addSubview(confirmButton)
        addSubview(scrollView)
    }

    private func activateConstraints() {
        activateConstraintsScrollView()
        activateConstraintsContentView()
        activateConstraintsBannerImageView()
        activateConstraintsGradientView()
        activateConstraintsTitleLabel()
        activateConstraintsResendOTPTitleLabel()
        activateConstraintsResendOTPDescriptionLabel()
        activateConstraintsStackView()
        activateConstraintsInputView()
        activateConstraintsConfirmButton()
    }

    private func bindToViewModel() {
        Observable.combineLatest(
            storeIDInputView.textField.rx.text.orEmpty,
            accountInputView.textField.rx.text.orEmpty,
            passwordInputView.textField.rx.text.orEmpty,
            emailInputView.textField.rx.text.orEmpty
        ) { storeID, account, password, email in
            (storeID, account, password, email)
        }
        .subscribe(onNext: { [unowned self] in
            self.viewModel.resendOTPInfo.storeID = $0.0
            self.viewModel.resendOTPInfo.account = $0.1
            self.viewModel.resendOTPInfo.password = $0.2
            self.viewModel.resendOTPInfo.email = $0.3
        })
        .disposed(by: bag)
        passwordSecureButton.rx.tap
            .map { [unowned self] in
                !self.passwordSecureButton.isSelected
            }
            .bind(to: viewModel.isSecureTextEntry)
            .disposed(by: bag)

        confirmButton.addTarget(viewModel, action: #selector(ResendOTPViewModel.confirmSendEmail), for: .touchUpInside)
    }
    func resetScrollViewContentInsets() {
        let scrollViewBounds = scrollView.bounds
        let contentViewHeight: CGFloat = 515

        var insets = UIEdgeInsets.zero
        insets.top = scrollViewBounds.height / 2.0
        insets.top -= contentViewHeight / 2.0

        insets.bottom = scrollViewBounds.height / 2.0
        insets.bottom -= contentViewHeight / 2.0

        scrollView.contentInset = insets
    }

    func moveContent(forKeyboardFrame keyboardFrame: CGRect) {
        var insets = scrollView.contentInset
        insets.bottom = keyboardFrame.height
        scrollView.contentInset = insets
    }
}
// MARK: - Layout
extension ResendOTPRootView {
    private func activateConstraintsScrollView() {
        let top = scrollView.topAnchor
            .constraint(equalTo: safeAreaLayoutGuide.topAnchor)
        let bottom = scrollView.bottomAnchor
            .constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        let leading = scrollView.leadingAnchor
            .constraint(equalTo: leadingAnchor)
        let trailing = scrollView.trailingAnchor
            .constraint(equalTo: trailingAnchor)

        NSLayoutConstraint.activate([
            top, bottom, leading, trailing
        ])
    }

    private func activateConstraintsContentView() {
        let width = contentView.widthAnchor
            .constraint(equalTo: scrollView.widthAnchor)
        let top = contentView.topAnchor
            .constraint(equalTo: scrollView.topAnchor)
        let bottom = contentView.bottomAnchor
            .constraint(equalTo: scrollView.bottomAnchor)
        let leading = contentView.leadingAnchor
            .constraint(equalTo: scrollView.leadingAnchor)
        let trailing = contentView.trailingAnchor
            .constraint(equalTo: scrollView.trailingAnchor)

        NSLayoutConstraint.activate([
            width, top, bottom, leading, trailing
        ])
    }

    private func activateConstraintsBannerImageView() {
        let top = bannerImageView.topAnchor
            .constraint(equalTo: contentView.topAnchor)
        let centerX = bannerImageView.centerXAnchor
            .constraint(equalTo: contentView.centerXAnchor)
        let width = bannerImageView.widthAnchor
            .constraint(equalToConstant: 173)
        let height = bannerImageView.heightAnchor
            .constraint(equalToConstant: 72)

        NSLayoutConstraint.activate([
            top, centerX, width, height
        ])
    }

    private func activateConstraintsGradientView() {
        let top = titleGradientView.topAnchor
            .constraint(equalTo: bannerImageView.bottomAnchor, constant: 30)
        let leading = titleGradientView.leadingAnchor
            .constraint(equalTo: contentView.leadingAnchor)
        let width = titleGradientView.widthAnchor
            .constraint(equalToConstant: 126)
        let height = titleGradientView.heightAnchor
            .constraint(equalToConstant: 30)

        NSLayoutConstraint.activate([
            top, leading, width, height
        ])
    }

    private func activateConstraintsTitleLabel() {
        let centerY = titleLabel.centerYAnchor
            .constraint(equalTo: titleGradientView.centerYAnchor)
        let trailing = titleLabel.trailingAnchor
            .constraint(equalTo: titleGradientView.trailingAnchor, constant: -12)

        NSLayoutConstraint.activate([
            centerY, trailing
        ])
    }

    private func activateConstraintsResendOTPTitleLabel() {
        let top = resendOTPTitleLabel.topAnchor
            .constraint(equalTo: titleGradientView.bottomAnchor, constant: 30)
        let leading = resendOTPTitleLabel.leadingAnchor
            .constraint(equalTo: contentView.leadingAnchor, constant: 50)
        let height = resendOTPTitleLabel.heightAnchor
            .constraint(equalToConstant: 20)

        NSLayoutConstraint.activate([
            top, leading, height
        ])
    }

    private func activateConstraintsResendOTPDescriptionLabel() {
        let top = resendOTPDescriptionLabel.topAnchor
            .constraint(equalTo: resendOTPTitleLabel.bottomAnchor, constant: 15)
        let leading = resendOTPDescriptionLabel.leadingAnchor
            .constraint(equalTo: resendOTPTitleLabel.leadingAnchor)
        let trailing = resendOTPDescriptionLabel.trailingAnchor
            .constraint(equalTo: contentView.trailingAnchor, constant: -50)

        NSLayoutConstraint.activate([
            top, leading, trailing
        ])
    }

    private func activateConstraintsInputView() {
        storeIDInputView.heightAnchor
            .constraint(equalToConstant: 52).isActive = true
        accountInputView.heightAnchor
            .constraint(equalToConstant: 52).isActive = true
        passwordInputView.heightAnchor
            .constraint(equalToConstant: 52).isActive = true
        emailInputView.heightAnchor
            .constraint(equalToConstant: 52).isActive = true
    }

    private func activateConstraintsStackView() {
        let top = inputStackView.topAnchor
            .constraint(equalTo: resendOTPDescriptionLabel.bottomAnchor, constant: 20)
        let leading = inputStackView.leadingAnchor
            .constraint(equalTo: contentView.leadingAnchor, constant: 50)
        let trailing = inputStackView.trailingAnchor
            .constraint(equalTo: contentView.trailingAnchor, constant: -50)

        NSLayoutConstraint.activate([
            top, leading, trailing
        ])
    }

    private func activateConstraintsConfirmButton() {
        let top = confirmButton.topAnchor
            .constraint(equalTo: inputStackView.bottomAnchor)
        let leading = confirmButton.leadingAnchor
            .constraint(equalTo: inputStackView.leadingAnchor)
        let trailing = confirmButton.trailingAnchor
            .constraint(equalTo: inputStackView.trailingAnchor)
        let height = confirmButton.heightAnchor
            .constraint(equalToConstant: 40)
        let bottom = contentView.bottomAnchor
            .constraint(equalTo: confirmButton.bottomAnchor, constant: 30)

        NSLayoutConstraint.activate([
            top, leading, trailing, height, bottom
        ])
    }
}

extension ResendOTPRootView {
    func bindViewModelToViews() {
        bindViewModelToInputViews()
        bindViewModelToConfirmButton()
    }

    func bindViewModelToInputViews() {
        viewModel.storeIDValidationResult
            .asDriver()
            .drive(onNext: { [unowned self] in
                switch $0 {
                case .valid:
                    self.storeIDInputView.clearError()
                case .invalid(let message):
                    self.storeIDInputView.showError(with: message)
                }
            })
            .disposed(by: bag)

        viewModel.accountValidationResult
            .asDriver()
            .drive(onNext: { [unowned self] in
                switch $0 {
                case .valid:
                    self.accountInputView.clearError()
                case .invalid(let message):
                    self.accountInputView.showError(with: message)
                }
            })
            .disposed(by: bag)

        viewModel.passwordValidationResult
            .asDriver()
            .drive (onNext: { [unowned self] in
                switch $0 {
                case .valid:
                    self.passwordInputView.clearError()
                case .invalid(let message):
                    self.passwordInputView.showError(with: message)
                }
            })
            .disposed(by: bag)

        viewModel.emailValidationResult
            .asDriver()
            .drive(onNext: { [unowned self] in
                switch $0 {
                case .valid:
                    self.emailInputView.clearError()
                case .invalid(let message):
                    self.emailInputView.showError(with: message)
                }
            })
            .disposed(by: bag)

    }

    private func bindViewModelToConfirmButton() {
        viewModel.confirmButtonEnabled
            .asDriver()
            .drive(confirmButton.rx.isEnabled)
            .disposed(by: bag)
    }
}
