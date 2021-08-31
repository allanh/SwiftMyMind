//
//  AnnouncementBriefTableViewCell.swift
//  MyMind
//
//  Created by Chijung Chan on 2021/8/18.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class AnnouncementBriefTableViewCell: UITableViewCell {
    // 種類圖片
    let typeImageView: UIImageView = UIImageView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "exclamation_circle")
    }
    // 種類標籤
    let typeLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 5
        $0.layer.borderColor = UIColor.orange.cgColor
        $0.textColor = .orange
        $0.text = "類別"
        $0.textAlignment = NSTextAlignment.center
        $0.font = .pingFangTCRegular(ofSize: 14)
    }
    // 內容標籤
    let contentLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .black
        $0.numberOfLines = 2
        $0.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
        $0.font = .pingFangTCRegular(ofSize: 14)
    }
    // 時間標籤
    let timeLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = UIColor(hex: "b4b4b4")
        $0.text = "(2020/5/6 05:06)"
        $0.font = .pingFangTCRegular(ofSize: 12)
    }
    
    // MARK: - Methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // 建立所有的 View & Layout
    func construct() {
        constructViewHierarchy()
        activateConstraints()
    }
    // 建立所有的 View
    func constructViewHierarchy() {
        contentView.addSubview(typeImageView)
        contentView.addSubview(typeLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(timeLabel)
    }
    // 建立所有的 Layouts
    func activateConstraints() {
        activateConstraintsTypeImageView()
        activateConstraintsTypeLabel()
        activateConstraintsContentLabel()
        activateConstraintsTimeLabel()
    }
    
}
// MARK: - Layouts
extension AnnouncementBriefTableViewCell {
    // 種類圖片 layout
    func activateConstraintsTypeImageView() {
        let top = typeImageView.topAnchor.constraint(equalTo: contentLabel.topAnchor)
        let leading = typeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        let height = typeImageView.heightAnchor.constraint(equalTo: typeLabel.heightAnchor)
        let width = typeImageView.widthAnchor.constraint(equalTo: typeImageView.heightAnchor)
        NSLayoutConstraint.activate([
            top, leading, height, width
        ])
    }
    // 種類標籤 layout
    func activateConstraintsTypeLabel() {
        let top = typeLabel.topAnchor.constraint(equalTo: contentLabel.topAnchor)
        let leading = typeLabel.leadingAnchor.constraint(equalTo: typeImageView.trailingAnchor, constant: 5)
        let width = typeLabel.widthAnchor.constraint(equalToConstant: 50)
        NSLayoutConstraint.activate([
            top, leading, width
        ])
    }
    // 內容標籤 layout
    func activateConstraintsContentLabel() {
        let centerY = contentLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        let leading = contentLabel.leadingAnchor.constraint(equalTo: typeLabel.trailingAnchor, constant: 10)
        let trailing = contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        
        NSLayoutConstraint.activate([
            centerY, leading, trailing
        ])
    }
    // 時間標籤 layout
    func activateConstraintsTimeLabel() {
        let bottom = timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        let trailing = timeLabel.trailingAnchor.constraint(equalTo: contentLabel.trailingAnchor)
        
        NSLayoutConstraint.activate([
            bottom, trailing
        ])
    }
    
}
