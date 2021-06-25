//
//  ProductMaterialSuggestionInfoTableViewCell.swift
//  MyMind
//
//  Created by Barry Chen on 2021/6/4.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class ProductMaterialSuggestionInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var bottomBorderView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func config(with title: String, content: String) {
        titleLabel.text = title
        contentLabel.text = content
    }
}
