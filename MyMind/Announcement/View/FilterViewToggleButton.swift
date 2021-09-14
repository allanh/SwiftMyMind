//
//  FilterViewToggleButton.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/9/10.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class FilterViewToggleButton: UIButton {
    var selectedBackground: UIColor = .prussianBlue
    var normalBackground: UIColor = .veryLightPink
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? selectedBackground : normalBackground
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
