//
//  SettingTableViewCell.swift
//  MyMind
//
//  Created by Shih Allan on 2021/11/5.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func config(with info: SettingInfo) {
        iconImageView.image = UIImage(named: info.icon)
        titleLabel.text = info.title
    }
}
