//
//  AnnouncementListFilterView.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/9/9.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
protocol AnnouncementListFilterViewDelegate {
    func didCancelFilter(_ view: AnnouncementListFilterView)
    func filterView(_ view: AnnouncementListFilterView, didFilterWith info: AnnouncementListQueryInfo)
}
class AnnouncementListFilterView: NiblessView {
    @objc
    private func closeButtonDidTapped(_ sender: UIButton) {
        delegate?.didCancelFilter(self)
    }
    @objc
    private func resetButtonDidTapped(_ sender: UIButton) {
        titleTextField.text = nil
        startTimeTextField.text = nil
        endTimeTextField.text = nil
        for button in buttons {
            button.isSelected = false
        }
    }
    @objc
    private func buttonDidTapped(_ sender: UIButton) {
        let selected = sender.isSelected
        for button in buttons {
            button.isSelected = false
        }
        sender.isSelected = !selected
    }
    @objc
    private func startDateChanged(_ sender: UIDatePicker) {
        startTimeTextField.text = formatter.string(from: sender.date)
        (endTimeTextField.inputView as? UIDatePicker)?.minimumDate = sender.date
    }
    @objc
    private func endDateChanged(_ sender: UIDatePicker) {
        endTimeTextField.text = formatter.string(from: sender.date)
    }
    @objc
    private func searchButtonDidTapped(_ sender: UIButton) {
        let info = AnnouncementListQueryInfo()
        if let text = titleTextField.text, !text.isEmpty {
            info.title = text
        }
        info.start = formatter.date(from: startTimeTextField.text ?? "")
        info.end = formatter.date(from: endTimeTextField.text ?? "")
        let selected = buttons.first { button in
            button.isSelected
        }
        if let selectedButton = selected {
            if let type = objc_getAssociatedObject(selectedButton, &handle) as? AnnouncementType {
                info.type = type
            }
        }
        delegate?.filterView(self, didFilterWith: info)
    }
    private let formatter: DateFormatter = DateFormatter {
        $0.dateFormat = "yyyy-MM-dd"
    }
    var delegate: AnnouncementListFilterViewDelegate?
    private let backgroundView: UIView = UIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .black.withAlphaComponent(0.5)
    }
    private let contentView: UIView = UIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        let tapGestureRecognizer = UITapGestureRecognizer(target: $0, action: #selector(UIView.endEditing(_:)))
        $0.addGestureRecognizer(tapGestureRecognizer)
    }
    private let titleView: UIView = UIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private let closeButton: UIButton = UIButton {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(named: "close")?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.tintColor = UIColor(hex: "004477")
        $0.addTarget(self, action: #selector(closeButtonDidTapped(_:)), for: .touchUpInside)
    }
    private let resetButton: UIButton = UIButton {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("重置", for: .normal)
        $0.setTitleColor(UIColor(hex: "004477"), for: .normal)
        $0.titleLabel?.font = .pingFangTCRegular(ofSize: 14)
        $0.addTarget(self, action: #selector(resetButtonDidTapped(_:)), for: .touchUpInside)
    }
    private let titleSeparator: UIView = UIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor(hex: "e5e5e5")
    }
    private let titleTextField: UITextField = UITextField {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.borderStyle = .none
        $0.font = .pingFangTCRegular(ofSize: 14)
        $0.placeholder = "請輸入公告標題"
        $0.layer.cornerRadius = 4
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(hex: "cccccc").cgColor
        let containerView = UIView()
        containerView.frame = CGRect(origin: .zero, size: .init(width: 35, height: 25))
        let iconImageView = UIImageView(image: UIImage(named: "search")?.withRenderingMode(.alwaysTemplate))
        iconImageView.tintColor = UIColor(hex: "cccccc")
        iconImageView.frame = CGRect(origin: .zero, size: .init(width: 25, height: 25))
        containerView.addSubview(iconImageView)
        $0.leftView = containerView
        $0.leftViewMode = .always
        $0.clearButtonMode = .whileEditing
    }
    private let kindTitleLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .pingFangTCSemibold(ofSize: 14)
        $0.textColor = UIColor(hex: "545454")
        $0.text = "類別"
    }
    private var buttons: [FilterViewToggleButton] = []
    private let separator: UIView = UIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor(hex: "e5e5e5")
    }
    private let timeTitleLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .pingFangTCSemibold(ofSize: 14)
        $0.textColor = UIColor(hex: "545454")
        $0.text = "發佈時間"
    }
    private let startTimeTextField: UITextField = UITextField {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.borderStyle = .none
        $0.font = .pingFangTCRegular(ofSize: 14)
        $0.placeholder = "開始日期"
        $0.layer.cornerRadius = 4
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(hex: "cccccc").cgColor
        let leftContainerView = UIView()
        leftContainerView.frame = CGRect(origin: .zero, size: .init(width: 10, height: 32))
        $0.leftView = leftContainerView
        $0.leftViewMode = .always
        $0.clearButtonMode = .never
        let rightContainerView = UIView()
        rightContainerView.frame = CGRect(origin: .zero, size: .init(width: 34, height: 32))
        let iconImageView = UIImageView(image: UIImage(named: "date_picker"))
        iconImageView.frame = CGRect(origin: .zero, size: .init(width: 34, height: 32))
        iconImageView.contentMode = .center
        rightContainerView.addSubview(iconImageView)
        $0.rightView = rightContainerView
        $0.rightViewMode = .always
        let datePicker: UIDatePicker = UIDatePicker {
            $0.datePickerMode = .date
            if #available(iOS 14.0, *) {
                $0.preferredDatePickerStyle = .wheels
            }
            $0.maximumDate = Date()
            $0.addTarget(self, action: #selector(startDateChanged(_:)), for: .valueChanged)
        }
        $0.inputView = datePicker
    }
    private let endTimeTextField: UITextField = UITextField {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.borderStyle = .none
        $0.font = .pingFangTCRegular(ofSize: 14)
        $0.placeholder = "結束日期"
        $0.layer.cornerRadius = 4
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(hex: "cccccc").cgColor
        let leftContainerView = UIView()
        leftContainerView.frame = CGRect(origin: .zero, size: .init(width: 10, height: 32))
        $0.leftView = leftContainerView
        $0.leftViewMode = .always
        $0.clearButtonMode = .never
        let rightContainerView = UIView()
        rightContainerView.frame = CGRect(origin: .zero, size: .init(width: 34, height: 32))
        let iconImageView = UIImageView(image: UIImage(named: "date_picker"))
        iconImageView.frame = CGRect(origin: .zero, size: .init(width: 34, height: 32))
        iconImageView.contentMode = .center
        rightContainerView.addSubview(iconImageView)
        $0.rightView = rightContainerView
        $0.rightViewMode = .always
        let datePicker: UIDatePicker = UIDatePicker {
            $0.datePickerMode = .date
            if #available(iOS 14.0, *) {
                $0.preferredDatePickerStyle = .wheels
            }
            $0.maximumDate = Date()
            $0.addTarget(self, action: #selector(endDateChanged(_:)), for: .valueChanged)
        }
        $0.inputView = datePicker
    }
    private let bottomSeparator: UIView = UIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor(hex: "e5e5e5")
    }
    private let searchButton: UIButton = UIButton {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor(hex: "004477")
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("搜尋", for: .normal)
        $0.titleLabel?.font = .pingFangTCSemibold(ofSize: 24)
        $0.layer.cornerRadius = 4
        $0.addTarget(self, action: #selector(searchButtonDidTapped(_:)), for: .touchUpInside)
    }
    private let bottomLine: UIView = UIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor(hex: "e5e5e5")
    }
    private let rightLine: UIView = UIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor(hex: "e5e5e5")
    }
    var hierarchyNotReady: Bool = true
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard hierarchyNotReady else {
          return
        }
        constructViews()
        activateConstraints()
        backgroundColor = .white
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeButtonDidTapped(_:)))
        backgroundView.addGestureRecognizer(tapGestureRecognizer)
        hierarchyNotReady = false
    }

}
/// helper
private var handle: Void?

extension AnnouncementListFilterView {
    private func constructViews() {
        titleView.addSubview(closeButton)
        titleView.addSubview(titleSeparator)
        titleView.addSubview(resetButton)
        contentView.addSubview(titleView)
        contentView.addSubview(titleTextField)
        contentView.addSubview(kindTitleLabel)
        let allCases = AnnouncementType.allCases
        allCases.forEach {type in
            let button: FilterViewToggleButton = FilterViewToggleButton {
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.setTitle(type.description, for: .normal)
                $0.layer.cornerRadius = 16
                $0.titleLabel?.font = .pingFangTCRegular(ofSize: 14)
                $0.setTitleColor(UIColor(hex:"7f7f7f"), for: .normal)
                $0.setTitleColor(.white, for: .selected)
                $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
                $0.backgroundColor = UIColor(hex: "f2f2f2")
                $0.addTarget(self, action: #selector(buttonDidTapped(_:)), for: .touchUpInside)
                objc_setAssociatedObject($0, &handle, type, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            contentView.addSubview(button)
            buttons.append(button)
        }
        contentView.addSubview(separator)
        contentView.addSubview(timeTitleLabel)
        contentView.addSubview(startTimeTextField)
        contentView.addSubview(endTimeTextField)
        contentView.addSubview(bottomSeparator)
        contentView.addSubview(searchButton)
        contentView.addSubview(bottomLine)
        contentView.addSubview(rightLine)
        backgroundView.addSubview(contentView)
        addSubview(backgroundView)
    }
    private func activateConstraints() {
        activateConstraintsCloseButton()
        activateConstraintsTitleSeparator()
        activateConstraintsResetButton()
        activateConstraintsTitleView()
        activateConstraintsTitleTextField()
        activateConstraintsKindTitleLabel()
        activateConstraintsButtons()
        activateConstraintsSeparatorView()
        activateConstraintsTimeTitleLabel()
        activateConstraintsStartTimeTextField()
        activateConstraintsEndTimeTextField()
        activateConstraintsBottomSeparatorView()
        activateConstraintsSearchButton()
        activateConstraintsBottomLine()
        activateConstraintsRightLine()
        activateConstraintsContentView()
        activateConstraintsBackgroundView()
    }
}
/// constraints
extension AnnouncementListFilterView {
    private func activateConstraintsBackgroundView() {
        let top = backgroundView.topAnchor.constraint(equalTo: topAnchor)
        let leading = backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor)
        let trailing = backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor)
        let bottom = backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor)
        NSLayoutConstraint.activate([
            top, leading, trailing, bottom
        ])
    }
    private func activateConstraintsContentView() {
        let top = contentView.topAnchor.constraint(equalTo: backgroundView.topAnchor)
        let leading = contentView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 64)
        let trailing = contentView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor)
        let bottom = contentView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor)
        NSLayoutConstraint.activate([
            top, leading, trailing, bottom
        ])
    }
    private func activateConstraintsTitleView() {
        let top = titleView.topAnchor.constraint(equalTo: contentView.topAnchor)
        let leading = titleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        let trailing = titleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        let height = titleView.heightAnchor.constraint(equalToConstant: 40)
        NSLayoutConstraint.activate([
            top, leading, trailing, height
        ])
    }
    private func activateConstraintsCloseButton() {
        let width = closeButton.widthAnchor.constraint(equalToConstant: 44)
        let leading = closeButton.leadingAnchor.constraint(equalTo: titleView.leadingAnchor)
        let height = closeButton.heightAnchor.constraint(equalToConstant: 44)
        let centerY = closeButton.centerYAnchor.constraint(equalTo: titleView.centerYAnchor)
        NSLayoutConstraint.activate([
            width, leading, height, centerY
        ])
    }
    private func activateConstraintsTitleSeparator() {
        let leading = titleSeparator.leadingAnchor.constraint(equalTo: titleView.leadingAnchor)
        let trailing = titleSeparator.trailingAnchor.constraint(equalTo: titleView.trailingAnchor)
        let height = titleSeparator.heightAnchor.constraint(equalToConstant: 1)
        let bottom = titleSeparator.bottomAnchor.constraint(equalTo: titleView.bottomAnchor)
        NSLayoutConstraint.activate([
            leading, trailing, height, bottom
        ])
    }
    private func activateConstraintsResetButton() {
        let trailing = resetButton.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: -16)
        let height = resetButton.heightAnchor.constraint(equalToConstant: 44)
        let centerY = closeButton.centerYAnchor.constraint(equalTo: titleView.centerYAnchor)
        NSLayoutConstraint.activate([
            trailing, height, centerY
        ])
    }
    private func activateConstraintsTitleTextField() {
        let top = titleTextField.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 24)
        let leading = titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        let trailing = titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        let height = titleTextField.heightAnchor.constraint(equalToConstant: 32)
        NSLayoutConstraint.activate([
            top, leading, trailing, height
        ])
    }
    private func activateConstraintsKindTitleLabel() {
        let top = kindTitleLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 22)
        let leading = kindTitleLabel.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor)
        let height = kindTitleLabel.heightAnchor.constraint(equalToConstant: 20)
        NSLayoutConstraint.activate([
            top, leading, height
        ])
    }
    private func activateConstraintsButtons() {
        var xOffset: CGFloat = 16
        var xAnchor: FilterViewToggleButton? = nil
        var yAnchor: FilterViewToggleButton? = nil
        for index in 0..<buttons.count {
            let size = (buttons[index].title(for: .normal)! as NSString).size(withAttributes: [.font: UIFont.pingFangTCRegular(ofSize: 14) as Any])
            
            if xOffset+size.width+32+8+16+64 > window!.bounds.width {
                yAnchor = buttons[index-1]
                let top = buttons[index].topAnchor.constraint(equalTo: (yAnchor == nil) ? kindTitleLabel.bottomAnchor : yAnchor!.bottomAnchor, constant: (yAnchor == nil) ? 10 : 8)
                let leading = buttons[index].leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
                let height = buttons[index].heightAnchor.constraint(equalToConstant: 32)
                let width = buttons[index].widthAnchor.constraint(equalToConstant: size.width + 32)
                NSLayoutConstraint.activate([
                    top, leading, height, width
                ])
                xOffset = 16
            } else {
                let top = buttons[index].topAnchor.constraint(equalTo: (yAnchor == nil) ? kindTitleLabel.bottomAnchor : yAnchor!.bottomAnchor, constant: (yAnchor == nil) ? 10 : 8)
                let leading = buttons[index].leadingAnchor.constraint(equalTo: (xAnchor == nil) ? contentView.leadingAnchor : xAnchor!.trailingAnchor, constant: (xAnchor == nil) ? 16 : 8)
                let height = buttons[index].heightAnchor.constraint(equalToConstant: 32)
                let width = buttons[index].widthAnchor.constraint(equalToConstant: size.width + 32)
                NSLayoutConstraint.activate([
                    top, leading, height, width
                ])
                xOffset += size.width
                xOffset += 32
                xOffset += 8
            }
            xAnchor = buttons[index]
        }
        
    }
    private func activateConstraintsSeparatorView() {
        let top = separator.topAnchor.constraint(equalTo: buttons.last!.bottomAnchor, constant: 16)
        let leading = separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        let trailing = separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        let height = separator.heightAnchor.constraint(equalToConstant: 1)
        NSLayoutConstraint.activate([
            top, leading, height, trailing
        ])
    }
    private func activateConstraintsTimeTitleLabel() {
        let top = timeTitleLabel.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 21)
        let leading = timeTitleLabel.leadingAnchor.constraint(equalTo: separator.leadingAnchor)
        let height = timeTitleLabel.heightAnchor.constraint(equalToConstant: 20)
        NSLayoutConstraint.activate([
            top, leading, height
        ])
    }
    private func activateConstraintsStartTimeTextField() {
        let top = startTimeTextField.topAnchor.constraint(equalTo: timeTitleLabel.bottomAnchor, constant: 10)
        let leading = startTimeTextField.leadingAnchor.constraint(equalTo: separator.leadingAnchor)
        let trailing = startTimeTextField.trailingAnchor.constraint(equalTo: separator.trailingAnchor)
        let height = startTimeTextField.heightAnchor.constraint(equalToConstant: 32)
        NSLayoutConstraint.activate([
            top, leading, height, trailing
        ])
    }
    private func activateConstraintsEndTimeTextField() {
        let top = endTimeTextField.topAnchor.constraint(equalTo: startTimeTextField.bottomAnchor, constant: 8)
        let leading = endTimeTextField.leadingAnchor.constraint(equalTo: startTimeTextField.leadingAnchor)
        let trailing = endTimeTextField.trailingAnchor.constraint(equalTo: startTimeTextField.trailingAnchor)
        let height = endTimeTextField.heightAnchor.constraint(equalToConstant: 32)
        NSLayoutConstraint.activate([
            top, leading, height, trailing
        ])
    }
    private func activateConstraintsBottomSeparatorView() {
        let bottom = bottomSeparator.bottomAnchor.constraint(equalTo: searchButton.topAnchor, constant: -16)
        let leading = bottomSeparator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        let trailing = bottomSeparator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        let height = bottomSeparator.heightAnchor.constraint(equalToConstant: 1)
        NSLayoutConstraint.activate([
            bottom, leading, height, trailing
        ])
    }
    private func activateConstraintsSearchButton() {
        let bottom = searchButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        let leading = searchButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        let trailing = searchButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        let height = searchButton.heightAnchor.constraint(equalToConstant: 40)
        NSLayoutConstraint.activate([
            bottom, leading, height, trailing
        ])
    }
    private func activateConstraintsBottomLine() {
        let top = bottomLine.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1)
        let leading = bottomLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        let trailing = bottomLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        let height = bottomLine.heightAnchor.constraint(equalToConstant: 1)
        NSLayoutConstraint.activate([
            top, leading, height, trailing
        ])
    }
    private func activateConstraintsRightLine() {
        let top = rightLine.topAnchor.constraint(equalTo: contentView.topAnchor)
        let bottom = rightLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        let trailing = rightLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        let width = rightLine.widthAnchor.constraint(equalToConstant: 1)
        NSLayoutConstraint.activate([
            top, bottom, width, trailing
        ])
    }
}
