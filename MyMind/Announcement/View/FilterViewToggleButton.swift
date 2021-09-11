//
//  FilterViewToggleButton.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/9/10.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class FilterViewToggleButton: UIButton {
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? UIColor(hex: "004477") : UIColor(hex: "f2f2f2")
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
