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

    private let resendOTPTitleLabel: UILabel = UILabel {
        $0.font = UIFont.pingFangTCSemibold(ofSize: 16)
        $0.text = "重綁OTP驗證碼"
        $0.textColor = UIColor(hex: "545454")
        $0.backgroundColor = .clear
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private let bullet1Label: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.pingFangTCRegular(ofSize: 12)
        $0.textColor = UIColor(hex: "545454")
        $0.backgroundColor = .clear
        $0.text = "1."
    }
    private let description1Label: UILabel = UILabel {
        $0.font = UIFont.pingFangTCRegular(ofSize: 12)
        $0.text = "填寫資料並按下確定後，您將收到系統發送的通知信，而原綁定驗證碼將立即失效，無法使用"
        $0.numberOfLines = 0
        $0.textColor = UIColor(hex: "545454")
        $0.backgroundColor = .clear
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private let bullet2Label: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.pingFangTCRegular(ofSize: 12)
        $0.textColor = UIColor(hex: "545454")
        $0.backgroundColor = .clear
        $0.text = "2."
    }
    private let description2Label: UILabel = UILabel {
        $0.font = UIFont.pingFangTCRegular(ofSize: 12)
        $0.text = "請掃描信中QR Code，並綁定新的OTP驗證碼"
        $0.numberOfLines = 0
        $0.textColor = UIColor(hex: "545454")
        $0.backgroundColor = .clear
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private let storeIDInputView: ValidatableInputView = ValidatableInputView {
        $0.textField.attributedPlaceholder = NSAttributedString(
            string: "請輸入商店代號",
            attributes: [.foregroundColor: UIColor.brownGrey2]
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
            attributes: [.foregroundColor: UIColor.brownGrey2]
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
    private let passwordSecureButton: UIButton = UIButton {
        $0.setImage(UIImage(named: "eye_open"), for: .normal)
        $0.setImage(UIImage(named: "eye_close"), for: .selected)
        $0.touchEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
    }

    private lazy var passwordInputView: ValidatableInputView = ValidatableInputView {
        $0.textField.attributedPlaceholder = NSAttributedString(
            string: "請輸入密碼",
            attributes: [.foregroundColor: UIColor.brownGrey2]
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

//    private let emailInputView: ValidatableInputView = ValidatableInputView {
//        $0.textField.attributedPlaceholder = NSAttributedString(
//            string: "輸入 Email",
//            attributes: [.foregroundColor: UIColor(hex: "b4b4b4")]
//        )
//        $0.textField.textColor = UIColor(hex: "545454")
//        let containerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 10, height: 30)))
//        $0.textField.leftView = containerView
//        $0.textField.leftViewMode = .always
//        $0.translatesAutoresizingMaskIntoConstraints = false
//    }

    private lazy var inputStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [storeIDInputView, accountInputView, passwordInputView])
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
        $0.backgroundColor = .prussianBlue
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
        backgroundView.addSubview(backgroundImageView)
        backgroundView.addSubview(backgroundTitleLabel)
        backgroundView.addSubview(backgroundDescriptionLabel)
        addSubview(backgroundView)
        scrollView.addSubview(contentView)
        contentView.addSubview(bannerImageView)
        contentView.addSubview(titleGradientView)
        titleGradientView.addSubview(titleLabel)
        contentView.addSubview(resendOTPTitleLabel)
        contentView.addSubview(bullet1Label)
        contentView.addSubview(description1Label)
        contentView.addSubview(bullet2Label)
        contentView.addSubview(description2Label)
        contentView.addSubview(inputStackView)
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
        activateConstraintsResendOTPTitleLabel()
        activateConstraintsBullet1Label()
        activateConstraintsDescription1Label()
        activateConstraintsBullet2Label()
        activateConstraintsDescription2Label()
        activateConstraintsStackView()
        activateConstraintsInputView()
        activateConstraintsConfirmButton()
    }

    private func bindToViewModel() {
        Observable.combineLatest(
            storeIDInputView.textField.rx.text.orEmpty,
            accountInputView.textField.rx.text.orEmpty,
            passwordInputView.textField.rx.text.orEmpty
        ) { storeID, account, password in
            (storeID, account, password)
        }
        .subscribe(onNext: { [unowned self] in
            self.viewModel.resendOTPInfo.storeID = $0.0
            self.viewModel.resendOTPInfo.account = $0.1
            self.viewModel.resendOTPInfo.password = $0.2
        })
        .disposed(by: bag)
        passwordSecureButton.rx.tap
            .map { [unowned self] in
                !self.passwordSecureButton.isSelected
            }
            .bind(to: viewModel.isSecureTextEntry)
            .disposed(by: bag)
        
        storeIDInputView.textField.rx.controlEvent(.editingDidEnd)
            .subscribe(onNext: { [unowned self] _ in
                _ = viewModel.validateInputInfo()
            })
            .disposed(by: bag)
        
        accountInputView.textField.rx.controlEvent(.editingDidEnd)
            .subscribe(onNext: { [unowned self] _ in
                _ = viewModel.validateInputInfo()
            })
            .disposed(by: bag)
        
        passwordInputView.textField.rx.controlEvent(.editingDidEnd)
            .subscribe(onNext: { [unowned self] _ in
                _ = viewModel.validateInputInfo()
            })
            .disposed(by: bag)

        confirmButton.addTarget(viewModel, action: #selector(ResendOTPViewModel.confirmSendEmail), for: .touchUpInside)
    }
    func resetScrollViewContentInsets() {
        let scrollViewBounds = scrollView.bounds
        let contentViewHeight: CGFloat = 508

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
            .constraint(equalTo: backgroundDescriptionLabel.bottomAnchor, constant: 15)
        let bottom = scrollView.bottomAnchor
            .constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -9)
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

    private func activateConstraintsResendOTPTitleLabel() {
        let top = resendOTPTitleLabel.topAnchor
            .constraint(equalTo: titleGradientView.bottomAnchor, constant: 16)
        let leading = resendOTPTitleLabel.leadingAnchor
            .constraint(equalTo: contentView.leadingAnchor, constant: 20)
        let height = resendOTPTitleLabel.heightAnchor
            .constraint(equalToConstant: 20)

        NSLayoutConstraint.activate([
            top, leading, height
        ])
    }
    private func activateConstraintsBullet1Label() {
        let top = bullet1Label.topAnchor
            .constraint(equalTo: resendOTPTitleLabel.bottomAnchor, constant: 8)
        let leading = bullet1Label.leadingAnchor
            .constraint(equalTo: resendOTPTitleLabel.leadingAnchor)
        let width = bullet1Label.widthAnchor
            .constraint(equalToConstant: 12)

        NSLayoutConstraint.activate([
            top, leading, width
        ])
    }
    private func activateConstraintsDescription1Label() {
        let firstBaseLine = description1Label.firstBaselineAnchor
            .constraint(equalTo: bullet1Label.firstBaselineAnchor)
        let leading = description1Label.leadingAnchor
            .constraint(equalTo: bullet1Label.trailingAnchor, constant: 2)
        let trailing = description1Label.trailingAnchor
            .constraint(equalTo: contentView.trailingAnchor, constant: -20)

        NSLayoutConstraint.activate([
            firstBaseLine, leading, trailing
        ])
    }
    private func activateConstraintsBullet2Label() {
        let top = bullet2Label.topAnchor
            .constraint(equalTo: description1Label.bottomAnchor, constant: 4)
        let leading = bullet2Label.leadingAnchor
            .constraint(equalTo: bullet1Label.leadingAnchor)
        let width = bullet2Label.widthAnchor
            .constraint(equalToConstant: 12)

        NSLayoutConstraint.activate([
            top, leading, width
        ])
    }
    private func activateConstraintsDescription2Label() {
        let firstBaseLine = description2Label.firstBaselineAnchor
            .constraint(equalTo: bullet2Label.firstBaselineAnchor)
        let leading = description2Label.leadingAnchor
            .constraint(equalTo: bullet2Label.trailingAnchor, constant: 2)
        let trailing = description2Label.trailingAnchor
            .constraint(equalTo: contentView.trailingAnchor, constant: -20)

        NSLayoutConstraint.activate([
            firstBaseLine, leading, trailing
        ])
    }

//    private func activateConstraintsResendOTPDescriptionLabel() {
//        let top = resendOTPDescriptionLabel.topAnchor
//            .constraint(equalTo: resendOTPTitleLabel.bottomAnchor, constant: 15)
//        let leading = resendOTPDescriptionLabel.leadingAnchor
//            .constraint(equalTo: resendOTPTitleLabel.leadingAnchor)
//        let trailing = resendOTPDescriptionLabel.trailingAnchor
//            .constraint(equalTo: contentView.trailingAnchor, constant: -50)
//
//        NSLayoutConstraint.activate([
//            top, leading, trailing
//        ])
//    }

    private func activateConstraintsInputView() {
        storeIDInputView.heightAnchor
            .constraint(equalToConstant: 52).isActive = true
        accountInputView.heightAnchor
            .constraint(equalToConstant: 52).isActive = true
        passwordInputView.heightAnchor
            .constraint(equalToConstant: 52).isActive = true
    }

    private func activateConstraintsStackView() {
        let top = inputStackView.topAnchor
            .constraint(equalTo: description2Label.bottomAnchor, constant: 20)
        let leading = inputStackView.leadingAnchor
            .constraint(equalTo: contentView.leadingAnchor, constant: 20)
        let trailing = inputStackView.trailingAnchor
            .constraint(equalTo: contentView.trailingAnchor, constant: -20)

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
        bindViewModelToPasswordSecureButton()
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

    private func bindViewModelToConfirmButton() {
        viewModel.confirmButtonEnabled
            .asDriver()
            .drive(confirmButton.rx.isEnabled)
            .disposed(by: bag)
    }
}
