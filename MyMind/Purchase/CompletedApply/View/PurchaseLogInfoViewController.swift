//
//  PurchaseLogInfoViewController.swift
//  MyMind
//
//  Created by Chen Yi-Wei on 2021/6/22.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

final class PurchaseLogInfoViewController: UIViewController {

    @IBOutlet private weak var stackView: UIStackView!

    var logInfos: [PurchaseOrder.LogInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        configureRootView()
        configureContentWithLogInfos()
    }

    private func configureRootView() {
        view.layer.cornerRadius = 4
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.separator.cgColor
    }

    private func makeLogInfoView(with logInfo: PurchaseOrder.LogInfo) -> LogInfoView {
        let logInfoView = LogInfoView()
        logInfoView.configure(with: logInfo)
        return logInfoView
    }

    private func configureContentWithLogInfos() {
        logInfos.forEach {
            let logInfoView = makeLogInfoView(with: $0)
            stackView.addArrangedSubview(logInfoView)
        }
    }
}
