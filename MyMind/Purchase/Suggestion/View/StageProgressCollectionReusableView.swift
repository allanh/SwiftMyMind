//
//  StageProgressCollectionReusableView.swift
//  MyMind
//
//  Created by Barry Chen on 2021/6/4.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class StageProgressCollectionReusableView: UICollectionReusableView {
    let progressView: StageProgressView = StageProgressView()
    let bottomSeperatorView: UIView = UIView {
        $0.backgroundColor = .separator
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        constructViewHierarchy()
        activateConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func constructViewHierarchy() {
        addSubview(progressView)
        addSubview(bottomSeperatorView)
    }

    private func activateConstraints() {
        activateConstraintsProgressView()
        activateConstraintsBottomSeperatorView()
    }

    private func activateConstraintsProgressView() {
        progressView.translatesAutoresizingMaskIntoConstraints = false
        let top = progressView.topAnchor
            .constraint(equalTo: topAnchor)
        let leading = progressView.leadingAnchor
            .constraint(equalTo: leadingAnchor)
        let bottom = progressView.bottomAnchor
            .constraint(equalTo: bottomAnchor)
        let trailing = progressView.trailingAnchor
            .constraint(equalTo: trailingAnchor)

        NSLayoutConstraint.activate([
            top, leading, bottom, trailing
        ])
    }

    private func activateConstraintsBottomSeperatorView() {
        bottomSeperatorView.translatesAutoresizingMaskIntoConstraints = false
        let leading = bottomSeperatorView.leadingAnchor
            .constraint(equalTo: leadingAnchor)
        let bottom = bottomSeperatorView.bottomAnchor
            .constraint(equalTo: bottomAnchor)
        let trailing = bottomSeperatorView.trailingAnchor
            .constraint(equalTo: trailingAnchor)
        let height = bottomSeperatorView.heightAnchor
            .constraint(equalToConstant: 1)

        NSLayoutConstraint.activate([
            leading, bottom, trailing, height
        ])
    }

    func configProgressView(numberOfStage: Int, stageTitleList: [String], currentStageIndex: Int) {
        progressView.numberOfStages = numberOfStage
        progressView.stageDescriptionList = stageTitleList
        progressView.currentStageIndex = currentStageIndex
    }
}
