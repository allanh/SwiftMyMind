//
//  ForgotPasswordRootView.swift
//  MyMind
//
//  Created by Barry Chen on 2021/3/25.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
import RxSwift
import NVActivityIndicatorView

class ForgotPasswordRootView: NiblessView {

    var hierarchyNotReady: Bool = true
    let bag: DisposeBag = DisposeBag()
    let viewModel: ForgotPasswordViewModel

    private let backgroundView: UIView = UIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor(hex: "f2f2f4")
    }
    private let backgroundImageView: UIImageView = UIImageView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "main_page_background")
    }
    private let backgroundTitleLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "最懂你的電商智慧夥伴"
        $0.textColor = .white
        $0.font = .pingFangTCSemibold(ofSize: 24)
    }
    private let backgroundDescriptionLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "致力整合網路生態鏈服務的創新公司"
        $0.textColor = .white.withAlphaComponent(0.6)
        $0.font = .pingFangTCRegular(ofSize: 14)
    }
    private let scrollView: UIScrollView = UIScrollView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.showsVerticalScrollIndicator = false
        $0.layer.cornerRadius = 10
    }

    private let contentView: UIView = UIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
    }

    private let bannerImageView: UIImageView = UIImageView {
        let image = UIImage(named: "my_mind")
        $0.image = image
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private let titleGradientView: GradientView = {
        let view = GradientView(gradientStartColor: UIColor(hex: "f5a700"), gradientEndColor: UIColor(hex: "f5a700"))
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = UILabel {
        $0.font = UIFont.pingFangTCSemibold(ofSize: 14)
        $0.text = "管理後台"
        $0.textColor = .white
        $0.backgroundColor = .clear
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
//    private let timeLabel: UILabel = UILabel {
//        $0.font = UIFont.pingFangTCRegular(ofSize: 14)
//        $0.textColor = UIColor(hex: "545454")
//        $0.backgroundColor = .clear
//        $0.translatesAutoresizingMaskIntoConstraints = false
//    }

    private let resetPasswordTitleLabel: UILabel = UILabel {
        $0.font = UIFont.pingFangTCSemibold(ofSize: 16)
        $0.text = "重設密碼"
        $0.textColor = UIColor(hex: "545454")
        $0.backgroundColor = .clear
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private let resetPasswordDescriptionLabel: UILabel = UILabel {
        $0.font = UIFont.pingFangTCRegular(ofSize: 12)
        $0.text = "輸入以下資料，我們將發送重設密碼連結"
        $0.textColor = UIColor(hex: "545454")
        $0.backgroundColor = .clear
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private let storeIDInputView: ValidatableInputView = ValidatableInputView {
        $0.textField.attributedPlaceholder = NSAttributedString(
            string: "請輸入商店代號",
            attributes: [.foregroundColor: UIColor(hex: "b4b4b4")]
        )
        $0.textField.textColor = UIColor(hex: "545454")
        let image = UIImage(named: "company")
        let containerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 30, height: 30)))
        let imageView = UIImageView(frame: CGRect(x: 8, y: containerView.frame.midY-7, width: 14, height: 14))
        imageView.image = image
        containerView.addSubview(imageView)
        $0.textField.leftView = containerView
        $0.textField.leftViewMode = .always
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private let accountInputView: ValidatableInputView = ValidatableInputView {
        $0.textField.attributedPlaceholder = NSAttributedString(
            string: "請輸入管理員帳號",
            attributes: [.foregroundColor: UIColor(hex: "b4b4b4")]
        )
        $0.textField.textColor = UIColor(hex: "545454")
        let image = UIImage(named: "id")
        let containerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 30, height: 30)))
        let imageView = UIImageView(frame: CGRect(x: 8, y: containerView.frame.midY-7, width: 14, height: 14))
        imageView.image = image
        containerView.addSubview(imageView)
        $0.textField.leftView = containerView
        $0.textField.leftViewMode = .always
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private let emailInputView: ValidatableInputView = ValidatableInputView {
        $0.textField.attributedPlaceholder = NSAttributedString(
            string: "請輸入Email",
            attributes: [.foregroundColor: UIColor(hex: "b4b4b4")]
        )
        $0.textField.textColor = UIColor(hex: "545454")
        let image = UIImage(named: "email")
        let containerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 30, height: 30)))
        let imageView = UIImageView(frame: CGRect(x: 8, y: containerView.frame.midY-7, width: 14, height: 14))
        imageView.image = image
        containerView.addSubview(imageView)
        $0.textField.leftView = containerView
        $0.textField.leftViewMode = .always
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private lazy var inputStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [storeIDInputView, accountInputView, emailInputView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()

    private let captchaInputView: ValidatableInputView = ValidatableInputView {
        $0.textField.attributedPlaceholder = NSAttributedString(
            string: "請輸入驗證碼",
            attributes: [.foregroundColor: UIColor(hex: "b4b4b4")]
        )
        $0.textField.textColor = UIColor(hex: "545454")
        let image = UIImage(named: "security")
        let containerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 30, height: 30)))
        let imageView = UIImageView(frame: CGRect(x: 8, y: containerView.frame.midY-7, width: 14, height: 14))
        imageView.image = image
        containerView.addSubview(imageView)
        $0.textField.leftView = containerView
        $0.textField.leftViewMode = .always
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private let captchaImageView: UIImageView = UIImageView {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private let captchaActivityIndicatorView: NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(
            frame: .zero,
            type: .ballSpinFadeLoader,
            color: UIColor(hex: "043458"))
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    private let reloadCaptchaButton: UIButton = UIButton {
        $0.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "reload")
        $0.setImage(image, for: .normal)
    }
    
//    private let exclamationImageView: UIImageView = UIImageView {
//        $0.translatesAutoresizingMaskIntoConstraints = false
//        $0.image = UIImage(named: "exclamation_circle")
//    }
//
//    private let confirmTimeLabel: UILabel = UILabel {
//        $0.translatesAutoresizingMaskIntoConstraints = false
//        $0.textColor = UIColor(hex: "7f7f7f")
//        $0.text = "請檢視手機時間是否與標準時間同步。"
//        $0.font = .pingFangTCRegular(ofSize: 14)
//    }

    private let confirmButton: UIButton = UIButton {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("確定", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.setTitleColor(UIColor(hex: "b4b4b4"), for: .disabled)
        $0.titleLabel?.font = UIFont.pingFangTCSemibold(ofSize: 16)
        $0.backgroundColor = UIColor(hex: "004477")
        $0.layer.cornerRadius = 4
    }

    // MARK: - Methods
    init(frame: CGRect = .zero,
         viewModel: ForgotPasswordViewModel) {
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
        backgroundView.addSubview(backgroundImageView)
        backgroundView.addSubview(backgroundTitleLabel)
        backgroundView.addSubview(backgroundDescriptionLabel)
        addSubview(backgroundView)
        scrollView.addSubview(contentView)
        contentView.addSubview(bannerImageView)
        contentView.addSubview(titleGradientView)
        titleGradientView.addSubview(titleLabel)
        contentView.addSubview(resetPasswordTitleLabel)
        contentView.addSubview(resetPasswordDescriptionLabel)
        contentView.addSubview(inputStackView)
        if !viewModel.otpEnabled {
            contentView.addSubview(captchaInputView)
            contentView.addSubview(captchaImageView)
            contentView.addSubview(captchaActivityIndicatorView)
            contentView.addSubview(reloadCaptchaButton)
        } else {
//            contentView.addSubview(timeLabel)
//            contentView.addSubview(exclamationImageView)
//            contentView.addSubview(confirmTimeLabel)
        }
        contentView.addSubview(confirmButton)
        addSubview(scrollView)
    }

    private func activateConstraints() {
        activateConstraintsBackgroundView()
        activateConstraintsBackgroundImageView()
        activateConstraintsBackgroundTitleLabel()
        activateConstraintsBackgroundDescriptionLabel()
        activateConstraintsScrollView()
        activateConstraintsContentView()
        activateConstraintsBannerImageView()
        activateConstraintsGradientView()
        activateConstraintsTitleLabel()
        activateConstraintsResetPasswordTitleLabel()
        activateConstraintsResetPasswordDescriptionLabel()
        activateConstraintsStackView()
        activateConstraintsInputView()
        if !viewModel.otpEnabled {
            activateConstraintsCaptchaInputView()
            activateConstraintsCaptchaImageView()
            activateConstraintsCaptchaActivityIndicatorView()
            activateConstraintsReloadCaptchaButton()
        } else {
//            activateConstraintsTimeLabel()
//            activateConstraintsExclamationImageView()
//            activateConstraintsConfirmTimeLabel()
        }
        activateConstraintsConfirmButton()
    }

    private func bindToViewModel() {
        if !viewModel.otpEnabled {
            Observable.combineLatest(
                storeIDInputView.textField.rx.text.orEmpty,
                accountInputView.textField.rx.text.orEmpty,
                emailInputView.textField.rx.text.orEmpty,
                captchaInputView.textField.rx.text.orEmpty
            ) { storeID, account, email, captcha in
                (storeID, account, email, captcha)
            }
            .subscribe(onNext: { [unowned self] in
                self.viewModel.forgotPasswordInfo.storeID = $0.0
                self.viewModel.forgotPasswordInfo.account = $0.1
                self.viewModel.forgotPasswordInfo.email = $0.2
                self.viewModel.forgotPasswordInfo.captchaValue = $0.3
            })
            .disposed(by: bag)
            reloadCaptchaButton.addTarget(viewModel, action: #selector(ForgotPasswordViewModel.captcha), for: .touchUpInside)
        } else {
            Observable.combineLatest(
                storeIDInputView.textField.rx.text.orEmpty,
                accountInputView.textField.rx.text.orEmpty,
                emailInputView.textField.rx.text.orEmpty
            ) { storeID, account, email in
                (storeID, account, email)
            }
            .subscribe(onNext: { [unowned self] in
                self.viewModel.forgotPasswordInfo.storeID = $0.0
                self.viewModel.forgotPasswordInfo.account = $0.1
                self.viewModel.forgotPasswordInfo.email = $0.2
            })
            .disposed(by: bag)
//            viewModel.date
//                .subscribe(on: MainScheduler.instance)
//                .do(onNext: { print($0) })
//                .map { serverTime -> String in
//                    var display = serverTime.time
//                    display.removeLast(3)
//                    display = display.replacingOccurrences(of: "-", with: "/")
//                    return display
//                }
//                .bind(to: timeLabel.rx.text)
//                .disposed(by: bag)
        }
        confirmButton.addTarget(viewModel, action: #selector(ForgotPasswordViewModel.confirmSendEmail), for: .touchUpInside)
    }

    func resetScrollViewContentInsets() {
        let scrollViewBounds = scrollView.bounds
        let contentViewHeight: CGFloat = 495

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
extension ForgotPasswordRootView {
    private func activateConstraintsBackgroundView() {
        let top = backgroundView.topAnchor
            .constraint(equalTo: safeAreaLayoutGuide.topAnchor)
        let bottom = backgroundView.bottomAnchor
            .constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        let leading = backgroundView.leadingAnchor
            .constraint(equalTo: leadingAnchor)
        let trailing = backgroundView.trailingAnchor
            .constraint(equalTo: trailingAnchor)

        NSLayoutConstraint.activate([
            top, bottom, leading, trailing
        ])
    }
    private func activateConstraintsBackgroundImageView() {
        let top = backgroundImageView.topAnchor
            .constraint(equalTo: topAnchor, constant: -1)
        let leading = backgroundImageView.leadingAnchor
            .constraint(equalTo: leadingAnchor)
        let trailing = backgroundImageView.trailingAnchor
            .constraint(equalTo: trailingAnchor)
        
        NSLayoutConstraint.activate([
            top, leading, trailing
        ])
    }
    private func activateConstraintsBackgroundTitleLabel() {
        let top = backgroundTitleLabel.topAnchor
            .constraint(equalTo: topAnchor, constant: 20)
        let height = backgroundTitleLabel.heightAnchor
            .constraint(equalToConstant: 33)
        let leading = backgroundTitleLabel.leadingAnchor
            .constraint(equalTo: leadingAnchor, constant: 25)

        NSLayoutConstraint.activate([
            top, height, leading
        ])
    }
    private func activateConstraintsBackgroundDescriptionLabel() {
        let top = backgroundDescriptionLabel.topAnchor
            .constraint(equalTo: backgroundTitleLabel.bottomAnchor, constant: 3)
        let leading = backgroundDescriptionLabel.leadingAnchor
            .constraint(equalTo: backgroundTitleLabel.leadingAnchor)

        NSLayoutConstraint.activate([
            top, leading
        ])
    }
    private func activateConstraintsScrollView() {
        let top = scrollView.topAnchor
            .constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 90)
        let bottom = scrollView.bottomAnchor
            .constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -24)
        let leading = scrollView.leadingAnchor
            .constraint(equalTo: leadingAnchor, constant: 25)
        let trailing = scrollView.trailingAnchor
            .constraint(equalTo: trailingAnchor, constant: -25)

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
            .constraint(equalTo: contentView.topAnchor, constant: 25)
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
            .constraint(equalToConstant: 100)
        let height = titleGradientView.heightAnchor
            .constraint(equalToConstant: 28)

        NSLayoutConstraint.activate([
            top, leading, width, height
        ])
    }

    private func activateConstraintsTitleLabel() {
        let centerY = titleLabel.centerYAnchor
            .constraint(equalTo: titleGradientView.centerYAnchor)
        let centerX = titleLabel.centerXAnchor
            .constraint(equalTo: titleGradientView.centerXAnchor)

        NSLayoutConstraint.activate([
            centerY, centerX
        ])
    }
    
//    private func activateConstraintsTimeLabel() {
//        let centerY = timeLabel.centerYAnchor
//            .constraint(equalTo: titleGradientView.centerYAnchor)
//        let trailing = timeLabel.trailingAnchor
//            .constraint(equalTo: contentView.trailingAnchor, constant: -20)
//
//        NSLayoutConstraint.activate([
//            centerY, trailing
//        ])
//    }

    private func activateConstraintsResetPasswordTitleLabel() {
        let top = resetPasswordTitleLabel.topAnchor
            .constraint(equalTo: titleGradientView.bottomAnchor, constant: 16)
        let leading = resetPasswordTitleLabel.leadingAnchor
            .constraint(equalTo: contentView.leadingAnchor, constant: 20)
        let height = resetPasswordTitleLabel.heightAnchor
            .constraint(equalToConstant: 20)

        NSLayoutConstraint.activate([
            top, leading, height
        ])
    }

    private func activateConstraintsResetPasswordDescriptionLabel() {
        let top = resetPasswordDescriptionLabel.topAnchor
            .constraint(equalTo: resetPasswordTitleLabel.bottomAnchor, constant: 8)
        let leading = resetPasswordDescriptionLabel.leadingAnchor
            .constraint(equalTo: resetPasswordTitleLabel.leadingAnchor)
        let height = resetPasswordDescriptionLabel.heightAnchor
            .constraint(equalToConstant: 20)

        NSLayoutConstraint.activate([
            top, leading, height
        ])
    }

    private func activateConstraintsInputView() {
        storeIDInputView.heightAnchor
            .constraint(equalToConstant: 52).isActive = true
        accountInputView.heightAnchor
            .constraint(equalToConstant: 52).isActive = true
        emailInputView.heightAnchor
            .constraint(equalToConstant: 52).isActive = true
    }

    private func activateConstraintsStackView() {
        let top = inputStackView.topAnchor
            .constraint(equalTo: resetPasswordDescriptionLabel.bottomAnchor, constant: 20)
        let leading = inputStackView.leadingAnchor
            .constraint(equalTo: contentView.leadingAnchor, constant: 20)
        let trailing = inputStackView.trailingAnchor
            .constraint(equalTo: contentView.trailingAnchor, constant: -20)

        NSLayoutConstraint.activate([
            top, leading, trailing
        ])
    }

    private func activateConstraintsCaptchaInputView() {
        let top = captchaInputView.topAnchor
            .constraint(equalTo: inputStackView.bottomAnchor)
        let leading = captchaInputView.leadingAnchor
            .constraint(equalTo: inputStackView.leadingAnchor)
        let trailing = captchaInputView.trailingAnchor
            .constraint(equalTo: captchaImageView.leadingAnchor, constant: -15)
        let height = captchaInputView.heightAnchor
            .constraint(equalToConstant: 52)

        NSLayoutConstraint.activate([
            top, leading, trailing, height
        ])
    }

    private func activateConstraintsCaptchaImageView() {
        let top = captchaImageView.topAnchor
            .constraint(equalTo: captchaInputView.topAnchor)
        let width = captchaImageView.widthAnchor
            .constraint(equalToConstant: 115)
        let height = captchaImageView.heightAnchor
            .constraint(equalToConstant: 32)
        let trailing = captchaImageView.trailingAnchor
            .constraint(equalTo: reloadCaptchaButton.leadingAnchor)

        NSLayoutConstraint.activate([
            top, width, height, trailing
        ])
    }

    private func activateConstraintsCaptchaActivityIndicatorView() {
        let centerX = captchaActivityIndicatorView.centerXAnchor
            .constraint(equalTo: captchaImageView.centerXAnchor)
        let centerY = captchaActivityIndicatorView.centerYAnchor
            .constraint(equalTo: captchaImageView.centerYAnchor)
        let width = captchaActivityIndicatorView.widthAnchor
            .constraint(equalToConstant: 25)
        let height = captchaActivityIndicatorView.heightAnchor
            .constraint(equalTo: captchaActivityIndicatorView.widthAnchor)

        NSLayoutConstraint.activate([
            centerX, centerY, width, height
        ])
    }

    private func activateConstraintsReloadCaptchaButton() {
        let trailing = reloadCaptchaButton.trailingAnchor
            .constraint(equalTo: inputStackView.trailingAnchor)
        let centerY = reloadCaptchaButton.centerYAnchor
            .constraint(equalTo: captchaImageView.centerYAnchor)
        let width = reloadCaptchaButton.widthAnchor
            .constraint(equalToConstant: 20)
        let height = reloadCaptchaButton.heightAnchor
            .constraint(equalTo: reloadCaptchaButton.heightAnchor)

        NSLayoutConstraint.activate([
            trailing, centerY, width, height
        ])
    }

//    private func activateConstraintsExclamationImageView() {
//        let top = exclamationImageView.topAnchor
//            .constraint(equalTo: inputStackView.bottomAnchor, constant: 10)
//        let leading = exclamationImageView.leadingAnchor
//            .constraint(equalTo: inputStackView.leadingAnchor)
//        let width = exclamationImageView.widthAnchor
//            .constraint(equalToConstant: 16)
//        let height = exclamationImageView.heightAnchor
//            .constraint(equalToConstant: 16)
//
//        NSLayoutConstraint.activate([
//            top, leading, width, height
//        ])
//    }
//
//    private func activateConstraintsConfirmTimeLabel() {
//        let centerY = confirmTimeLabel.centerYAnchor
//            .constraint(equalTo: exclamationImageView.centerYAnchor)
//        let leading = confirmTimeLabel.leadingAnchor
//            .constraint(equalTo: exclamationImageView.trailingAnchor, constant: 4)
//        let trailing = confirmTimeLabel.trailingAnchor
//            .constraint(equalTo: inputStackView.trailingAnchor)
//        let height = confirmTimeLabel.heightAnchor
//            .constraint(equalToConstant: 20)
//
//        NSLayoutConstraint.activate([
//            centerY, leading, trailing, height
//        ])
//    }

    private func activateConstraintsConfirmButton() {
        let top = confirmButton.topAnchor
            .constraint(equalTo: inputStackView.bottomAnchor, constant: 4)
        let leading = confirmButton.leadingAnchor
            .constraint(equalTo: inputStackView.leadingAnchor)
        let trailing = confirmButton.trailingAnchor
            .constraint(equalTo: inputStackView.trailingAnchor)
        let height = confirmButton.heightAnchor
            .constraint(equalToConstant: 46)
        let bottom = contentView.bottomAnchor
            .constraint(equalTo: confirmButton.bottomAnchor, constant: 30)

        NSLayoutConstraint.activate([
            top, leading, trailing, height, bottom
        ])
    }
}
// MARK: - Behaviors
extension ForgotPasswordRootView {
    func bindViewModelToViews() {
        bindViewModelToInputViews()
        bindViewModelToReloadButton()
        bindViewModelToConfirmButton()
        bindViewModelToCaptchaImageView()
        bindViewModelToCaptchaActivityIndicator()
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

        viewModel.captchaValueValidationResult
            .asDriver()
            .drive(onNext: { [unowned self] in
                switch $0 {
                case .valid:
                    self.captchaInputView.clearError()
                case .invalid(let message):
                    self.captchaInputView.showError(with: message)
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

    private func bindViewModelToReloadButton() {
        viewModel.reloadButtonEnabled
            .asDriver()
            .drive(reloadCaptchaButton.rx.isEnabled)
            .disposed(by: bag)
    }

    private func bindViewModelToCaptchaActivityIndicator() {
        viewModel.captchaActivityIndicatorAnimating
            .asDriver()
            .drive(captchaActivityIndicatorView.rx.isAnimating)
            .disposed(by: bag)
    }

    private func bindViewModelToCaptchaImageView() {
        viewModel.captchaSession
            .asObservable()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                guard let data = $0.imageData else {
                    return
                }
                let image = UIImage(data: data)
                self.captchaImageView.image = image
            })
            .disposed(by: bag)
    }
}
