//
//  IndicatorSwitchContentHeaderView.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/13.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class IndicatorSwitchContentHeaderView: NiblessView {
    var hierarchyNotReady: Bool = true
    let indicatorWidth: CGFloat
    let title: String
    let switcher: SwitcherInfo
    weak var delegate: IndicatorSwitchContentHeaderViewDelegate?
    init(frame: CGRect, indicatorWidth: CGFloat, title: String, switcher: SwitcherInfo, delegate: IndicatorSwitchContentHeaderViewDelegate? = nil) {
        self.indicatorWidth = indicatorWidth
        self.title = title
        self.switcher = switcher
        self.delegate = delegate
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    @objc private func switchContent() {
        delegate?.contentNeedSwitch(to: switcherSegmentControl.selectedSegmentIndex, for: switcher.section)
    }
    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard hierarchyNotReady else {
          return
        }
        arrangeView()
        activateConstraints()
        backgroundColor = .systemBackground
        titleLabel.text = title
        switcherSegmentControl.insertSegment(withTitle: switcher.0, at: 0, animated: false)
        switcherSegmentControl.insertSegment(withTitle: switcher.1, at: 1, animated: false)
        switcherSegmentControl.addTarget(self, action: #selector(switchContent), for: .valueChanged)
        switcherSegmentControl.selectedSegmentIndex = switcher.current
        hierarchyNotReady = false
    }
    private let indicatorView: UIView = UIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor(hex: "1c4373")
    }
    private let titleLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .pingFangTCSemibold(ofSize: 16)
        $0.textColor = .secondaryLabel
        $0.adjustsFontSizeToFitWidth = true
    }
    private let switcherSegmentControl: UISegmentedControl = UISegmentedControl {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitleTextAttributes([.foregroundColor : UIColor.secondaryLabel], for: .normal)
        $0.setTitleTextAttributes([.foregroundColor : UIColor.label], for: .selected)
        $0.selectedSegmentTintColor = .secondarySystemBackground
        $0.backgroundColor = .tertiarySystemBackground
    }
    private let seperatorView: UIView = UIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .secondarySystemBackground
    }
}
/// helper
extension IndicatorSwitchContentHeaderView {
    private func arrangeView() {
        addSubview(indicatorView)
        addSubview(titleLabel)
        addSubview(switcherSegmentControl)
        addSubview(seperatorView)
    }
    private func activateConstraints() {
        activateConstraintsIndicatorView()
        activateConstraintsTitleLabel()
        activateConstraintsSwitcherSegmentControl()
        activateConstraintsSeperatorView()
    }
}
/// constraint
extension IndicatorSwitchContentHeaderView {
    private func activateConstraintsIndicatorView() {
        let top = indicatorView.topAnchor
            .constraint(equalTo: topAnchor, constant: 8)
        let bottom = indicatorView.bottomAnchor
            .constraint(equalTo: bottomAnchor, constant: -8)
        let width = indicatorView.widthAnchor
            .constraint(equalToConstant: indicatorWidth)
        let leading = indicatorView.leadingAnchor
            .constraint(equalTo: leadingAnchor, constant: 8)

        NSLayoutConstraint.activate([
            top, bottom, leading, width
        ])
    }
    private func activateConstraintsTitleLabel() {
        let top = titleLabel.topAnchor
            .constraint(equalTo: topAnchor, constant: 8)
        let bottom = titleLabel.bottomAnchor
            .constraint(equalTo: bottomAnchor, constant: -8)
        let leading = titleLabel.leadingAnchor
            .constraint(equalTo: indicatorView.trailingAnchor, constant: 8)
//        let trailing = titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        
        NSLayoutConstraint.activate([
            top, bottom, leading//, trailing
        ])
    }
    private func activateConstraintsSwitcherSegmentControl() {
        let leading = switcherSegmentControl.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8)
        let centerY = switcherSegmentControl.centerYAnchor
            .constraint(equalTo: titleLabel.centerYAnchor)
        let trailing = switcherSegmentControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)

        let width = switcherSegmentControl.widthAnchor.constraint(equalToConstant: 140)
        NSLayoutConstraint.activate([
            centerY, trailing, leading, width
        ])
    }
    private func activateConstraintsSeperatorView() {
        let trailing = seperatorView.trailingAnchor
            .constraint(equalTo: trailingAnchor, constant: 0)
        let leading = seperatorView.leadingAnchor
            .constraint(equalTo: leadingAnchor, constant: 0)
        let height = seperatorView.heightAnchor
            .constraint(equalToConstant: 1)
        
        let bottom = seperatorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1)
        NSLayoutConstraint.activate([
            leading, trailing, height, bottom
        ])
    }
}
