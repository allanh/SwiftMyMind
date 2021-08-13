//
//  ServiceCellTableViewCell.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/8/9.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class ServiceCellTableViewCell: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var descriptionsLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func config(with service: ServiceInfo) {
        iconImageView.image = UIImage(named: service.icon)
        titleLabel.text = service.title
        versionLabel.text = service.version
        descriptionsLabel.text = service.descriptions
    }

}
