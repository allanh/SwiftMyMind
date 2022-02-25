//
//  MainFunctionEntryCollectionViewCell.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/10/13.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class MainFunctionEntryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var categoryTitleLabel: UILabel!
    @IBOutlet weak var entryTitleLabel: UILabel!
    
    private var imageBackground: UIView = UIView()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 16
        imageView.layer.cornerRadius = 16
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = 16.0
        contentView.layer.masksToBounds = true

        layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 10.0
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        entryTitleLabel.adjustsFontSizeToFitWidth = true
        entryTitleLabel.minimumScaleFactor = 0.5
    }

    func config(with item: FunctionEntryList.FunctionEntry.FunctionEntryItem, category: Category) {
        categoryTitleLabel.text = category.title
        entryTitleLabel.text = item.rawValue
        imageView.image = UIImage(named: item.imageName)
        if imageBackground.superview != nil {
            imageBackground.removeFromSuperview()
        }
        if let start = item.gradient.first, let end = item.gradient.last {
            imageBackground = UIView()
            imageBackground.layer.cornerRadius = 16
            imageBackground.frame = imageView.frame
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = imageBackground.bounds
            gradientLayer.colors = [start.cgColor, end.cgColor]
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
            imageBackground.layer.insertSublayer(gradientLayer, at: 0)
            imageBackground.clipsToBounds = true
            contentView.insertSubview(imageBackground, belowSubview: imageView)
        }
    }
}
