//
//  SaleReportButton.swift
//  MyMind
//
//  Created by Shih Allan on 2021/12/13.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class SaleReportTypeView: NiblessView {
    
    // 數量或總額
    enum InfoType {
        case quantity, amount
        var description: String {
            get {
                switch self {
                case .quantity: return "數量"
                case .amount: return "總額"
                }
            }
        }
    }
    
    // MARK: - Initialization
    init(infoType: InfoType) {
        self.infoType = infoType
        super.init(frame: .zero)
        self.setupUI()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard hierarchyNotReady else {
          return
        }
        self.setupUI()
        hierarchyNotReady = false
    }
    
    private var hierarchyNotReady: Bool = true
    private let infoType: InfoType
    private let selectedimage = UIImage(named: "sale_report_item_selected_bg")!
    private let unselectedimage = UIImage(named: "sale_report_item_unselected_bg")!
    
    private lazy var backgroundImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var borderView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "sale_report_border"))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = UILabel {
        $0.font = .pingFangTCRegular(ofSize: 12)
        $0.textColor = .white
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let countLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .pingFangTCSemibold(ofSize: 24)
        $0.textColor = .white
        $0.text = "-"
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.5
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundImage.image = infoType == .quantity ? selectedimage : unselectedimage
        self.titleLabel.text = infoType.description
        self.addSubview(backgroundImage)
        self.addSubview(borderView)
        self.addSubview(titleLabel)
        self.addSubview(countLabel)

        // 總額含單位
        if (infoType == .quantity) {
            self.backgroundImage.image = selectedimage
        } else {
            self.backgroundImage.image = unselectedimage
        }

        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            borderView.topAnchor.constraint(equalTo: topAnchor, constant: 9),
            borderView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 9),
            borderView.widthAnchor.constraint(equalToConstant: 4),
            borderView.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: borderView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: borderView.trailingAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: borderView.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            countLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            countLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 21),
            countLabel.trailingAnchor
                .constraint(equalTo: trailingAnchor, constant: -19),
            countLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -23)
        ])
    }
}

extension SaleReportTypeView: ReportItemProtocol {
    func onSelected() {
        backgroundImage.image = self.selectedimage
    }
    
    func onNotSelected() {
        backgroundImage.image = self.unselectedimage
    }
}
