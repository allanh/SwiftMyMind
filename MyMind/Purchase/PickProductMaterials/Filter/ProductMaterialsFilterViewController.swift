//
//  ProductMaterialsFilterViewController.swift
//  MyMind
//
//  Created by Barry Chen on 2021/5/25.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
import RxSwift

class ProductMaterialsFilterViewController: NiblessViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    // MARK: - Properties
    private let scrollView: UIScrollView = UIScrollView {
        $0.backgroundColor = .white
        $0.showsHorizontalScrollIndicator = false
    }

    private let contentView: UIView = UIView {
        $0.backgroundColor = .white
    }
    lazy var vendorInfoView: UIView = UIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        let titleLabel: UILabel = UILabel {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.font = .pingFangTCSemibold(ofSize: 18)
            $0.textColor = .veryDarkGray
            $0.text = "供應商"
        }
        let valueLabel: UILabel = UILabel {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.font = .pingFangTCRegular(ofSize: 14)
            $0.textColor = .veryDarkGray
            $0.text = viewModel.queryInfo.vendorInfo.name
        }
        $0.addSubview(titleLabel)
        $0.addSubview(valueLabel)
        
        let titleTop = titleLabel.topAnchor
            .constraint(equalTo: $0.topAnchor, constant: 10)
        let titleLeading = titleLabel.leadingAnchor
            .constraint(equalTo: $0.leadingAnchor, constant: 20)
        let titleHeight = titleLabel.heightAnchor
            .constraint(greaterThanOrEqualToConstant: 25)

        NSLayoutConstraint.activate([
            titleTop, titleLeading, titleHeight
        ])
        let valueTop = valueLabel.topAnchor
            .constraint(equalTo: titleLabel.bottomAnchor, constant: 15)
        let valueLeading = valueLabel.leadingAnchor
            .constraint(equalTo: titleLabel.leadingAnchor)
        let valueTrailing = valueLabel.trailingAnchor
            .constraint(equalTo: $0.trailingAnchor, constant: -20)
        let valueHeight = valueLabel.heightAnchor
            .constraint(equalToConstant: 40)
        let valueBottom = valueLabel.bottomAnchor
            .constraint(equalTo: $0.bottomAnchor, constant: -5)
        NSLayoutConstraint.activate([
            valueTop, valueLeading, valueTrailing, valueHeight, valueBottom
        ])

    }
    
//    lazy var vendorInfoView: AutoCompleteSearchRootView = AutoCompleteSearchRootView {
//        $0.backgroundColor = .white
//        $0.textField.text = viewModel.queryInfo.vendorInfo.name
//        $0.textField.isUserInteractionEnabled = false
//        $0.titleLabel.text = "供應商"
//    }

    private let bottomView: FilterSideMenuBottomView = FilterSideMenuBottomView {
        $0.backgroundColor = .white
    }

    let viewModel: ProductMaterialsFilterViewModel
    private var contentViewControllers: [UIViewController] = []
    let bag: DisposeBag = DisposeBag()
    init(viewModel: ProductMaterialsFilterViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    // MARK: - View life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addTapToResignKeyboardGesture()
        constructViewHierarchy()
        activateConstraints()
        makeContentViewControlellers()
        activateConstraintsForChildViews()
        configBottomView()
        configNavigtaionBar()
        scrollView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardObservers()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }
    // MARK: - Methods
    private func configNavigtaionBar() {
        navigationItem.title = viewModel.title
        let closeButton = UIButton()
        closeButton.setImage(UIImage(named: "close"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonDidTapped(_:)), for: .touchUpInside)
        let barItem = UIBarButtonItem(customView: closeButton)
        navigationItem.setRightBarButton(barItem, animated: true)
    }

    @objc
    private func closeButtonDidTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    private func makeContentViewControlellers() {
        [
            viewModel.brandNameViewModel,
            viewModel.productNumberViewModel,
            viewModel.productNumberSetViewModel,
            viewModel.originalNumberViewModel,
        ].forEach { viewModel in
            let viewController = AutoCompleteSearchViewController(viewModel: viewModel)
            contentView.addSubview(viewController.view)
            addChild(viewController)
            viewController.didMove(toParent: self)
            contentViewControllers.append(viewController)
        }

        let viewController = SearchMaterialNameViewController(viewModel: viewModel.searchMaterialNameViewModel)
        contentView.addSubview(viewController.view)
        addChild(viewController)
        viewController.didMove(toParent: self)
        contentViewControllers.append(viewController)
    }

    private func constructViewHierarchy() {
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
        view.addSubview(bottomView)
    }

    private func activateConstraints() {
        activateConstraintsScrollView()
        activateConstraintsContentView()
        activateConstraintsBottomView()
    }
    
    private func resetSearchViewControllerContent() {
        for index in 0..<contentViewControllers.count {
            if let childView = contentViewControllers[index].view as? AutoCompleteSearchRootView {
                childView.textField.text = nil
            }
        }
    }
    private func configBottomView() {
        bottomView.confirmButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.viewModel.confirmSearch()
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: bag)
        bottomView.cancelButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.viewModel.cleanToDefaultStatus()
                self.resetSearchViewControllerContent()
            })
            .disposed(by: bag)
    }
}
// MARK: - Scroll view delegate
extension ProductMaterialsFilterViewController: UIScrollViewDelegate {
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        // adjust drop down view position when keyboard show
        if let dropDownView = UIWindow.keyWindow?.subviews.first(where: { $0.accessibilityIdentifier == "DropDownView" }) {
            dropDownView.layoutSubviews()
        }
    }
}
// MARK: - Layouts
extension ProductMaterialsFilterViewController {
    private func activateConstraintsScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        let top = scrollView.topAnchor
            .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let leading = scrollView.leadingAnchor
            .constraint(equalTo: view.leadingAnchor)
        let bottom = scrollView.bottomAnchor
            .constraint(equalTo: bottomView.topAnchor)
        let trailing = scrollView.trailingAnchor
            .constraint(equalTo: view.trailingAnchor)

        NSLayoutConstraint.activate([
            top, leading, bottom, trailing
        ])
    }

    private func activateConstraintsContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        let top = contentView.topAnchor
            .constraint(equalTo: scrollView.topAnchor)
        let leading = contentView.leadingAnchor
            .constraint(equalTo: scrollView.leadingAnchor)
        let bottom = contentView.bottomAnchor
            .constraint(equalTo: scrollView.bottomAnchor)
        let trailing = contentView.trailingAnchor
            .constraint(equalTo: scrollView.trailingAnchor)
        let width = contentView.widthAnchor
            .constraint(equalTo: scrollView.widthAnchor)

        NSLayoutConstraint.activate([
            top, leading, bottom, trailing, width
        ])
    }

    private func activateConstraintsBottomView() {
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        let leading = bottomView.leadingAnchor
            .constraint(equalTo: view.leadingAnchor)
        let bottom = bottomView.bottomAnchor
            .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        let trailing = bottomView.trailingAnchor
            .constraint(equalTo: view.trailingAnchor)
        let height = bottomView.heightAnchor
            .constraint(equalToConstant: 50)

        NSLayoutConstraint.activate([
            leading, bottom, trailing, height
        ])
    }

    private func addVendorInfoView() {
        vendorInfoView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(vendorInfoView)
        let top = vendorInfoView.topAnchor
            .constraint(equalTo: contentView.topAnchor)
        let leading = vendorInfoView.leadingAnchor
            .constraint(equalTo: contentView.leadingAnchor)
        let trailing = vendorInfoView.trailingAnchor
            .constraint(equalTo: contentView.trailingAnchor)

        NSLayoutConstraint.activate([
            top, leading, trailing
        ])
    }

    private func activateConstraintsForChildViews() {
        addVendorInfoView()
        var lastChildView: UIView?
        for index in 0..<children.count {
            guard let childView = children[index].view else { return }
            childView.translatesAutoresizingMaskIntoConstraints = false
            childView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
            childView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
            if index == 0 {
                childView.topAnchor.constraint(equalTo: vendorInfoView.bottomAnchor, constant: 15).isActive = true
            }
            if let lastView = lastChildView {
                childView.topAnchor.constraint(equalTo: lastView.bottomAnchor).isActive = true
            }
            if index == children.count - 1 {
               childView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
            }
            lastChildView = childView
        }
    }
}
// MARK: - Keyboard handle
extension ProductMaterialsFilterViewController {
    func addKeyboardObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(handleContentUnderKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(handleContentUnderKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    func removeObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }

    @objc func handleContentUnderKeyboard(notification: Notification) {
        if let userInfo = notification.userInfo,
           let keyboardEndFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let convertedKeyboardEndFrame = view.convert(keyboardEndFrame.cgRectValue, from: view.window)
            if notification.name == UIResponder.keyboardWillHideNotification {
                scrollView.contentInset.bottom = .zero
            } else {
                var insets = scrollView.contentInset
                insets.bottom = convertedKeyboardEndFrame.height + 150
                scrollView.contentInset = insets
            }
        }
    }
}
