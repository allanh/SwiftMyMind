//
//  TodayTabItemView.swift
//  MyMind
//
//  Created by Shih Allan on 2021/12/7.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class TodayTabItemView: UIView, ReportItemProtocol {
    
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    private let title: String
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .pingFangTCRegular(ofSize: 16)
        label.textColor = .brownGrey
        label.text = title
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var borderView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "today_tab_border"))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func onSelected() {
        self.titleLabel.font = .pingFangTCSemibold(ofSize: 16)
        self.titleLabel.textColor = .prussianBlue

        if borderView.superview == nil {
            self.addSubview(borderView)

            NSLayoutConstraint.activate([
                borderView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                borderView.widthAnchor.constraint(equalToConstant: 64),
                borderView.heightAnchor.constraint(equalToConstant: 3),
                borderView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
        }
    }
    
    func onNotSelected() {
        self.titleLabel.font = .pingFangTCRegular(ofSize: 16)
        self.titleLabel.textColor = .brownGrey

        self.layer.shadowOpacity = 0
        
        self.borderView.removeFromSuperview()
    }
    
    
    // MARK: - UI Setup
    private func setupUI() {
        self.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
