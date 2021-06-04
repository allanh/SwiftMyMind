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

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(progressView)
        activateConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func activateConstraints() {
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

    func configProgressView(numberOfStage: Int, stageTitleList: [String], currentStageIndex: Int) {
        progressView.numberOfStages = numberOfStage
        progressView.stageDescriptionList = stageTitleList
        progressView.currentStageIndex = currentStageIndex
//        progressView.layout()
    }
}
