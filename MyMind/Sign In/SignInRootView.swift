//
//  SignInRootView.swift
//  MyMind
//
//  Created by Barry Chen on 2021/3/19.
//

import UIKit
import RxSwift
import NVActivityIndicatorView

class SignInRootView: NiblessView {
    let viewModel: SignInViewModel
    var hierarchyNotReady: Bool = true
    let bag: DisposeBag = DisposeBag()

    private let backgroundView: UIView = UIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .athensGray
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
        let view = GradientView(gradientStartColor: .webOrange, gradientEndColor: .webOrange)
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
//        $0.font = UIFont.pingFangTCRegular(ofSize: 16)
//        $0.textColor = UIColor(hex: "545454")
//        $0.backgroundColor = .clear
//        $0.translatesAutoresizingMaskIntoConstraints = false
//    }
    private let storeIDInputView: ValidatableInputView = ValidatableInputView {
        $0.textField.attributedPlaceholder = NSAttributedString(
            string: "請輸入商店代號",
            attributes: [.foregroundColor: UIColor.brownGrey2]
        )
        $0.textField.textColor = .emperor
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
            attributes: [.foregroundColor: UIColor.brownGrey2]
        )
        $0.textField.textColor = .emperor
        let image = UIImage(named: "id")
        let containerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 30, height: 30)))
        let imageView = UIImageView(frame: CGRect(x: 8, y: containerView.frame.midY-7, width: 14, height: 14))
        imageView.image = image
        containerView.addSubview(imageView)
        $0.textField.leftView = containerView
        $0.textField.leftViewMode = .always
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private let passwordSecureButton: UIButton = UIButton {
        $0.setImage(UIImage(named: "eye_open"), for: .normal)
        $0.setImage(UIImage(named: "eye_close"), for: .selected)
        $0.touchEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
    }

    lazy var passwordInputView: ValidatableInputView = ValidatableInputView {
        $0.textField.attributedPlaceholder = NSAttributedString(
            string: "請輸入密碼",
            attributes: [.foregroundColor: UIColor.brownGrey2]
        )
        $0.textField.textColor = .emperor
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

    private lazy var inputStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [storeIDInputView, accountInputView, passwordInputView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()

//    private let exclamationImageView: UIImageView = UIImageView {
//        $0.translatesAutoresizingMaskIntoConstraints = false
//        $0.image = UIImage(named: "exclamation_circle")
//    }
//    private let confirmTimeLabel: UILabel = UILabel {
//        $0.translatesAutoresizingMaskIntoConstraints = false
//        $0.textColor = UIColor(hex: "7f7f7f")
//        $0.text = "請檢視手機時間是否與標準時間同步。"
//        $0.font = .pingFangTCRegular(ofSize: 14)
//    }
    private let rememberAccountButton: UIButton = UIButton {
        $0.isSelected = true
        $0.setImage(UIImage(named: "unchecked"), for: .normal)
        $0.setTitle(" 記住帳號", for: .normal)
        $0.titleLabel?.font = UIFont.pingFangTCRegular(ofSize: 14)
        $0.setTitleColor(.brownGrey, for: .normal)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let captchaInputView: ValidatableInputView = ValidatableInputView {
        $0.textField.attributedPlaceholder = NSAttributedString(
            string: "請輸入驗證碼",
            attributes: [.foregroundColor: UIColor.brownGrey2]
        )
        $0.textField.textColor = .emperor
        let image = UIImage(named: "security")
        let containerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 30, height: 30)))
        let imageView = UIImageView(frame: CGRect(x: 8, y: containerView.frame.midY-7, width: 14, height: 14))
        imageView.image = image
        containerView.addSubview(imageView)
        $0.textField.keyboardType = .numberPad
        $0.textField.leftView = containerView
        $0.textField.leftViewMode = .always
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let captchaImageView: UIImageView = UIImageView {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let captchaActivityIndicatorView: NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(
            frame: .zero,
            type: .ballSpinFadeLoader,
            color: UIColor(hex: "043458"))
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    let reloadCaptchaButton: UIButton = UIButton {
        $0.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "reload")
        $0.setImage(image, for: .normal)
    }

    let signInButton: UIButton = UIButton {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("確定", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.setTitleColor(.brownGrey2, for: .disabled)
        $0.titleLabel?.font = UIFont.pingFangTCSemibold(ofSize: 16)
        $0.backgroundColor = .prussianBlue
        $0.layer.cornerRadius = 4
    }

    let resetPasswordButton: UIButton = UIButton {
        let attributedString = NSAttributedString(
            string: "忘記密碼？",
            attributes: [
                NSAttributedString.Key.font: UIFont.pingFangTCRegular(ofSize: 14),
                NSAttributedString.Key.foregroundColor: UIColor.lochmara,
                NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                NSAttributedString.Key.underlineColor: UIColor.lochmara
            ])
        $0.setAttributedTitle(attributedString, for: .normal)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let resendOTPButton: UIButton = UIButton {
        let attributedString = NSAttributedString(
            string: "重綁OTP驗證碼",
            attributes: [
                NSAttributedString.Key.font: UIFont.pingFangTCRegular(ofSize: 14),
                NSAttributedString.Key.foregroundColor: UIColor.lochmara,
                NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                NSAttributedString.Key.underlineColor: UIColor.lochmara
            ])
        $0.setAttributedTitle(attributedString, for: .normal)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    // MARK: - Methods
    init(frame: CGRect = .zero, viewModel: SignInViewModel) {
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
        if !viewModel.otpEnabled {
            contentView.addSubview(captchaInputView)
            contentView.addSubview(captchaImageView)
            contentView.addSubview(captchaActivityIndicatorView)
            contentView.addSubview(reloadCaptchaButton)
        } else {
//            contentView.addSubview(timeLabel)
//            contentView.addSubview(exclamationImageView)
//            contentView.addSubview(confirmTimeLabel)
            contentView.addSubview(resendOTPButton)
        }
        contentView.addSubview(inputStackView)
        contentView.addSubview(rememberAccountButton)
        contentView.addSubview(signInButton)
        contentView.addSubview(resetPasswordButton)
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
        if !viewModel.otpEnabled {
            activateConstraintsCaptchaInputView()
            activateConstraintsCaptchaImageView()
            activateConstraintsCaptchaActivityIndicatorView()
            activateConstraintsReloadCaptchaButton()
        } else {
//            activateConstraintsTimeLabel()
//            activateConstraintsExclamationImageView()
//            activateConstraintsConfirmTimeLabel()
            activateConstraintsResendOTPButton()
        }
        activateConstraintsStackView()
        activateConstraintsInputView()
        activateConstraintsRememberAccountButton()
        activateConstraintsSignInButton()
        activateConstraintsResetPasswordButton()
    }

    private func bindToViewModel() {
        if !viewModel.otpEnabled {
            Observable.combineLatest(
                storeIDInputView.textField.rx.text.orEmpty,
                accountInputView.textField.rx.text.orEmpty,
                passwordInputView.textField.rx.text.orEmpty,
                captchaInputView.textField.rx.text.orEmpty
            ) { storeID, account, password, captcha in
                (storeID, account, password, captcha)
            }
            .subscribe(onNext: { [unowned self] in
                self.viewModel.signInInfo.storeID = $0.0
                self.viewModel.signInInfo.account = $0.1
                self.viewModel.signInInfo.password = $0.2
                self.viewModel.signInInfo.captchaValue = $0.3
            })
            .disposed(by: bag)
            reloadCaptchaButton.addTarget(viewModel, action: #selector(viewModel.captcha), for: .touchUpInside)
        } else {
            Observable.combineLatest(
                storeIDInputView.textField.rx.text.orEmpty,
                accountInputView.textField.rx.text.orEmpty,
                passwordInputView.textField.rx.text.orEmpty
            ) { storeID, account, password in
                (storeID, account, password)
            }
            .subscribe(onNext: { [unowned self] in
                self.viewModel.signInInfo.storeID = $0.0
                self.viewModel.signInInfo.account = $0.1
                self.viewModel.signInInfo.password = $0.2
            })
            .disposed(by: bag)
//            resendOTPButton.addTarget(viewModel, action: #selector(view), for: <#T##UIControl.Event#>)
        }

        rememberAccountButton.rx.tap
            .map { [unowned self] in
                !self.rememberAccountButton.isSelected
            }
            .bind(to: viewModel.shouldRememberAccount)
            .disposed(by: bag)

        passwordSecureButton.rx.tap
            .map { [unowned self] in
                !self.passwordSecureButton.isSelected
            }
            .bind(to: viewModel.isSecureTextEntry)
            .disposed(by: bag)

        storeIDInputView.textField.rx.controlEvent(.editingDidEnd)
            .subscribe(onNext: { [unowned self] _ in
                _ = viewModel.validateSignInInfo()
            })
            .disposed(by: bag)
        
        accountInputView.textField.rx.controlEvent(.editingDidEnd)
            .subscribe(onNext: { [unowned self] _ in
                _ = viewModel.validateSignInInfo()
            })
            .disposed(by: bag)
        
        passwordInputView.textField.rx.controlEvent(.editingDidEnd)
            .subscribe(onNext: { [unowned self] _ in
                _ = viewModel.validateSignInInfo()
            })
            .disposed(by: bag)
        
//        signInButton.addTarget(viewModel, action: #selector(viewModel.signIn), for: .touchUpInside)
    }

    func resetScrollViewContentInsets() {
        let scrollViewBounds = scrollView.bounds
        let contentViewHeight: CGFloat = 516

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
extension SignInRootView {
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
            .constraint(equalTo: backgroundView.topAnchor, constant: -1)
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
            .constraint(equalTo: backgroundView.topAnchor, constant: 20)
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
            .constraint(equalTo: backgroundDescriptionLabel.bottomAnchor, constant: 15)
        let bottom = scrollView.bottomAnchor
            .constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -26)
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
    
    private func activateConstraintsStackView() {
        let top = inputStackView.topAnchor
            .constraint(equalTo: titleGradientView.bottomAnchor, constant: 16)
        let leading = inputStackView.leadingAnchor
            .constraint(equalTo: contentView.leadingAnchor, constant: 20)
        let trailing = inputStackView.trailingAnchor
            .constraint(equalTo: contentView.trailingAnchor, constant: -20)

        NSLayoutConstraint.activate([
            top, leading, trailing
        ])
    }

    private func activateConstraintsInputView() {
        storeIDInputView.heightAnchor
            .constraint(equalToConstant: 56).isActive = true
        accountInputView.heightAnchor
            .constraint(equalToConstant: 56).isActive = true
        passwordInputView.heightAnchor
            .constraint(equalToConstant: 56).isActive = true
    }
//    private func activateConstraintsExclamationImageView() {
//        let top = exclamationImageView.topAnchor
//            .constraint(equalTo: rememberAccountButton.bottomAnchor, constant: 10)
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

    private func activateConstraintsRememberAccountButton() {
        let top = rememberAccountButton.topAnchor
            .constraint(equalTo: inputStackView.bottomAnchor, constant: 6)
        let leading = rememberAccountButton.leadingAnchor
            .constraint(equalTo: inputStackView.leadingAnchor, constant: -4)
        let width = rememberAccountButton.widthAnchor
            .constraint(equalToConstant: 90)
        let height = rememberAccountButton.heightAnchor
            .constraint(equalToConstant: 20)

        NSLayoutConstraint.activate([
            top, leading, width, height
        ])
    }

    private func activateConstraintsResetPasswordButton() {
        if !viewModel.otpEnabled {
            let top = resetPasswordButton.topAnchor
                .constraint(equalTo: inputStackView.bottomAnchor, constant: 8)
            let trailing = resetPasswordButton.trailingAnchor
                .constraint(equalTo: inputStackView.trailingAnchor)
            let height = resetPasswordButton.heightAnchor
                .constraint(equalToConstant: 20)

            NSLayoutConstraint.activate([
                top, trailing, height
            ])
        } else {
            let top = resetPasswordButton.topAnchor
                .constraint(equalTo: signInButton.bottomAnchor, constant: 16)
            let leading = resetPasswordButton.leadingAnchor
                .constraint(equalTo: inputStackView.leadingAnchor)
            let height = resetPasswordButton.heightAnchor
                .constraint(equalToConstant: 20)

            NSLayoutConstraint.activate([
                top, leading, height
            ])
        }
    }

    private func activateConstraintsResendOTPButton() {
        let top = resendOTPButton.topAnchor
            .constraint(equalTo: resetPasswordButton.topAnchor)
        let trailing = resendOTPButton.trailingAnchor
            .constraint(equalTo: inputStackView.trailingAnchor)
        let height = resendOTPButton.heightAnchor
            .constraint(equalToConstant: 20)

        NSLayoutConstraint.activate([
            top, trailing, height//leading, height
        ])
    }

    private func activateConstraintsCaptchaInputView() {
        let top = captchaInputView.topAnchor
            .constraint(equalTo: rememberAccountButton.bottomAnchor, constant: 20)
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

    private func activateConstraintsSignInButton() {
        let top = signInButton.topAnchor
            .constraint(equalTo: (!viewModel.otpEnabled) ? captchaInputView.bottomAnchor : rememberAccountButton.bottomAnchor, constant: 26)
        let leading = signInButton.leadingAnchor
            .constraint(equalTo: inputStackView.leadingAnchor)
        let trailing = signInButton.trailingAnchor
            .constraint(equalTo: inputStackView.trailingAnchor)
        let height = signInButton.heightAnchor
            .constraint(equalToConstant: 46)
        let bottom = contentView.bottomAnchor
            .constraint(equalTo: signInButton.bottomAnchor, constant: 60)

        NSLayoutConstraint.activate([
            top, leading, trailing, height, bottom
        ])
    }
}
// MARK: - Behaviors
extension SignInRootView {
    private func bindViewModelToViews() {
        bindViewModelToRememberAccountButton()
        bindViewModelToSignInButton()
        bindViewModelToReloadCaptchaButton()
        bindViewModelToCaptchaImageView()
        bindViewModelToCaptchaActivityIndicator()
        bindViewModelToPasswordSecureButton()
        bindViewModelToTextFields()
//        bindViewModelToTimeLabel()
    }

    private func bindViewModelToRememberAccountButton() {
        viewModel.shouldRememberAccount
            .asDriver()
            .do(onNext: { [unowned self] flag in
                viewModel.lastSignInInfoDataStore
                    .saveShouldRememberLastSignAccountFlag(flag)
                    .cauterize()
            })
            .drive(onNext: { [unowned self] in
                switch $0 {
                case true:
                    self.rememberAccountButton.isSelected = true
                    self.rememberAccountButton.isEnabled = false
                    UIView.transition(
                        with: self.rememberAccountButton,
                        duration: 0.3,
                        options: .transitionCrossDissolve) {
                        self.rememberAccountButton.setImage(UIImage(named: "checked"), for: .normal)
                    } completion: { [weak self] _ in
                        self?.rememberAccountButton.isEnabled = true
                    }
                case false:
                    self.rememberAccountButton.isSelected = false
                    self.rememberAccountButton.setImage(UIImage(named: "unchecked"), for: .normal)
                }
            })
            .disposed(by: bag)
    }

    private func bindViewModelToSignInButton() {
        viewModel.signInButtonEnabled
            .asDriver(onErrorJustReturn: true)
            .do(onNext: { [unowned self] in
                let backgroundColor: UIColor = $0 ? .prussianBlue : .veryLightPink
                self.signInButton.backgroundColor = backgroundColor
            })
            .drive(signInButton.rx.isEnabled)
            .disposed(by: bag)
    }

    private func bindViewModelToReloadCaptchaButton() {
        viewModel.reloadButtonEnabled
            .asDriver(onErrorJustReturn: true)
            .drive(reloadCaptchaButton.rx.isEnabled)
            .disposed(by: bag)
    }

    private func bindViewModelToCaptchaImageView() {
        viewModel.captchaSession
            .subscribe(on: MainScheduler.instance)
            .do(onNext: { print($0.key) })
            .map { session -> UIImage? in
                guard let data = session.imageData else {
                    return nil
                }
                return UIImage(data: data)
            }
            .bind(to: captchaImageView.rx.image)
            .disposed(by: bag)
    }

    private func bindViewModelToCaptchaActivityIndicator() {
        viewModel.captchaActivityIndicatorAnimating
            .asDriver()
            .do(onNext:{ [unowned self] in
                let alpha: CGFloat = $0 ? 0.3 : 1
                self.captchaImageView.alpha = alpha
            })
            .drive(onNext: { [unowned self] in
                switch $0 {
                case true: captchaActivityIndicatorView.startAnimating()
                case false: captchaActivityIndicatorView.stopAnimating()
                }
            })
            .disposed(by: bag)
    }

    private func bindViewModelToPasswordSecureButton() {
        viewModel.isSecureTextEntry
            .asDriver()
            .do(onNext: { [unowned self] in
                self.passwordSecureButton.isSelected = $0
            })
            .drive(onNext: { [unowned self] in
                self.passwordInputView.textField.isSecureTextEntry = $0
            })
            .disposed(by: bag)
    }

    private func bindViewModelToTextFields() {
        viewModel.lastSignInInfo
            .asDriver(onErrorJustReturn: .empty())
            .drive(onNext: { [unowned self] signInInfo in
                self.storeIDInputView.textField.text = signInInfo.storeID
                self.storeIDInputView.textField.sendActions(for: .valueChanged)
                self.accountInputView.textField.text = signInInfo.account
                self.accountInputView.textField.sendActions(for: .valueChanged)
            })
            .disposed(by: bag)

        viewModel.storeIDValidationResult.asDriver()
            .drive(onNext:{ [unowned self] in
                switch $0 {
                case .valid: self.storeIDInputView.clearError()
                case .invalid(let message): self.storeIDInputView.showError(with: message)
                }
            })
            .disposed(by: bag)

        viewModel.accountValidationResult.asDriver()
            .drive(onNext:{ [unowned self] in
                switch $0 {
                case .valid: self.accountInputView.clearError()
                case .invalid(let message): self.accountInputView.showError(with: message)
                }
            })
            .disposed(by: bag)

        viewModel.passwordValidationResult.asDriver()
            .drive(onNext:{ [unowned self] in
                switch $0 {
                case .valid: self.passwordInputView.clearError()
                case .invalid(let message): self.passwordInputView.showError(with: message)
                }
            })
            .disposed(by: bag)

        viewModel.captchaValueValidationResult.asDriver()
            .drive(onNext:{ [unowned self] in
                switch $0 {
                case .valid: self.captchaInputView.clearError()
                case .invalid(let message): self.captchaInputView.showError(with: message)
                }
            })
            .disposed(by: bag)
    }
//    private func bindViewModelToTimeLabel() {
//        viewModel.date
//            .subscribe(on: MainScheduler.instance)
//            .do(onNext: { print($0) })
//            .map { serverTime -> String in
//                var display = serverTime.time
//                display.removeLast(3)
//                display = display.replacingOccurrences(of: "-", with: "/")
//                return display
//            }
//            .bind(to: timeLabel.rx.text)
//            .disposed(by: bag)
//    }
}
