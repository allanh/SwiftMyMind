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
        $0.layer.cornerRadius = 16
        $0.contentMode = .scaleAspectFit
    }
    // 種類標籤
    let typeLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 8
        $0.backgroundColor = UIColor(hex: "004477")
        $0.textColor = .white
        $0.textAlignment = NSTextAlignment.center
        $0.font = .pingFangTCRegular(ofSize: 12)
        $0.clipsToBounds = true
    }
    // 內容標籤
    let contentLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = UIColor(hex: "545454")
        $0.numberOfLines = 2
        $0.font = .pingFangTCRegular(ofSize: 14)
    }
    // 時間標籤
    let timeLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = UIColor(hex: "b4b4b4")
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
    func construct(with item: Announcement) {
        contentView.backgroundColor = item.readed == nil ? UIColor(hex: "f1f8fe"): .white
        constructViewHierarchy()
        let size = (item.type.description as NSString).size(withAttributes: [.font: typeLabel.font as Any])
        activateConstraints(size)
        typeImageView.image = UIImage(named: item.imageName)
        typeImageView.backgroundColor = item.iconBackground

        typeLabel.text = item.type.description
        let formatter = DateFormatter {
            $0.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }
        timeLabel.text = formatter.string(from: item.started)
        contentLabel.text = item.title
    }
    // 建立所有的 View
    func constructViewHierarchy() {
        contentView.addSubview(typeImageView)
        contentView.addSubview(typeLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(timeLabel)
    }
    // 建立所有的 Layouts
    func removeConstraints() {
        contentView.removeConstraints(contentView.constraints)
        typeImageView.removeConstraints(typeImageView.constraints)
        typeLabel.removeConstraints(typeLabel.constraints)
        contentLabel.removeConstraints(contentLabel.constraints)
        timeLabel.removeConstraints(timeLabel.constraints)
    }
    func activateConstraints(_ size: CGSize) {
        activateConstraintsTypeImageView()
        activateConstraintsTypeLabel(size)
        activateConstraintsContentLabel()
        activateConstraintsTimeLabel()
    }
    
}
// MARK: - Layouts
extension AnnouncementBriefTableViewCell {
    // 種類圖片 layout
    func activateConstraintsTypeImageView() {
        let top = typeImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16)
        let leading = typeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        let height = typeImageView.heightAnchor.constraint(equalToConstant: 32)
        let width = typeImageView.widthAnchor.constraint(equalToConstant: 32)
        NSLayoutConstraint.activate([
            top, leading, height, width
        ])
    }
    // 種類標籤 layout
    func activateConstraintsTypeLabel(_ size: CGSize) {
        typeLabel.removeConstraints(typeLabel.constraints)
        let bottom = typeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        let leading = typeLabel.leadingAnchor.constraint(equalTo: contentLabel.leadingAnchor)
        let width = typeLabel.widthAnchor.constraint(equalToConstant: size.width+16)
        let height = typeLabel.heightAnchor.constraint(equalToConstant: 16)
        NSLayoutConstraint.activate([
            bottom, leading, width, height
        ])
    }
    // 內容標籤 layout
    func activateConstraintsContentLabel() {
        let top = contentLabel.topAnchor.constraint(equalTo: typeImageView.topAnchor)
        let leading = contentLabel.leadingAnchor.constraint(equalTo: typeImageView.trailingAnchor, constant: 12)
        let trailing = contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        
        NSLayoutConstraint.activate([
            top, leading, trailing
        ])
    }
    // 時間標籤 layout
    func activateConstraintsTimeLabel() {
        let bottom = timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        let trailing = timeLabel.trailingAnchor.constraint(equalTo: contentLabel.trailingAnchor)
        
        NSLayoutConstraint.activate([
            bottom, trailing
        ])
    }
    
}
