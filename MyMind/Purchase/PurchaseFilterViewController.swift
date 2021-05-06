//
//  PurchaseFilterViewController.swift
//  MyMind
//
//  Created by Barry Chen on 2021/5/6.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class PurchaseFilterViewController: NiblessViewController {

    private let topBarView: SideMenuTopBarView = SideMenuTopBarView {
        $0.backgroundColor = .white
    }

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

    private let visibleWidth: CGFloat

    init(visibleWidth: CGFloat) {
        self.visibleWidth = visibleWidth
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        constructViewHierarchy()
        activateConstraints()
    }

    private func constructViewHierarchy() {
        view.addSubview(topBarView)
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
        view.addSubview(bottomView)
    }

    private func activateConstraints() {
        activateConstraintsTopBarView()
        activateConstraintsBottomView()
        activateConstraintsScrollView()
        activateConstraintsContentView()
    }
}
// MARK: - Layouts
extension PurchaseFilterViewController {
    private func activateConstraintsTopBarView() {
        topBarView.translatesAutoresizingMaskIntoConstraints = false

        let leading = topBarView.leadingAnchor
            .constraint(equalTo: view.leadingAnchor)
        let top = topBarView.topAnchor
            .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let trailing = topBarView.trailingAnchor
            .constraint(equalTo: view.trailingAnchor, constant: -(view.frame.width-visibleWidth))
        let height = topBarView.heightAnchor
            .constraint(equalToConstant: 44)

        NSLayoutConstraint.activate([
            leading, top, trailing, height
        ])
    }

    private func activateConstraintsBottomView() {
        bottomView.translatesAutoresizingMaskIntoConstraints = false

        let leading = bottomView.leadingAnchor
            .constraint(equalTo: view.leadingAnchor)
        let bottom = bottomView.bottomAnchor
            .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        let trailing = bottomView.trailingAnchor
            .constraint(equalTo: view.trailingAnchor, constant: -(view.frame.width-visibleWidth))
        let height = bottomView.heightAnchor
            .constraint(equalToConstant: 50)

        NSLayoutConstraint.activate([
            leading, bottom, trailing, height
        ])
    }

    private func activateConstraintsScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        let top = scrollView.topAnchor
            .constraint(equalTo: topBarView.bottomAnchor)
        let leading = scrollView.leadingAnchor
            .constraint(equalTo: view.leadingAnchor)
        let trailing = scrollView.trailingAnchor
            .constraint(equalTo: view.trailingAnchor, constant: -(view.frame.width-visibleWidth))
        let bottom = scrollView.bottomAnchor
            .constraint(equalTo: bottomView.topAnchor)

        NSLayoutConstraint.activate([
            top, leading, trailing, bottom
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
}
