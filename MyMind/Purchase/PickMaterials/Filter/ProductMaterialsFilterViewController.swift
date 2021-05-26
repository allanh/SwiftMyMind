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
    // MARK: - Properties
    private let scrollView: UIScrollView = UIScrollView {
        $0.backgroundColor = .white
        $0.showsHorizontalScrollIndicator = false
    }

    private let contentView: UIView = UIView {
        $0.backgroundColor = .white
    }

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
    }
    // MARK: - Methods
    private func makeContentViewControlellers() {
        [
            viewModel.vendorViewModel,
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
            })
            .disposed(by: bag)
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

    private func activateConstraintsForChildViews() {
        var lastChildView: UIView?
        for index in 0..<children.count {
            guard let childView = children[index].view else { return }
            childView.translatesAutoresizingMaskIntoConstraints = false
            childView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
            childView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
            if index == 0 {
                childView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
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
