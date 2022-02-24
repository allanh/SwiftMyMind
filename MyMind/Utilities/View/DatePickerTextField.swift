//
//  DatePickerTextField.swift
//  MyMind
//
//  Created by Shih Allan on 2022/2/24.
//  Copyright © 2022 United Digital Intelligence. All rights reserved.
//

import UIKit

class DatePickerTextField: UITextField {
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configView()
    }
    
    private func configView() {
        self.borderStyle = .none
        self.layer.cornerRadius = 4
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        let leftContainerView = UIView()
        leftContainerView.frame = CGRect(origin: .zero, size: .init(width: 10, height: 32))
        self.leftView = leftContainerView
        self.leftViewMode = .always
        self.clearButtonMode = .never
        
        let rightContainerView = UIView()
        rightContainerView.frame = CGRect(origin: .zero, size: .init(width: 34, height: 32))
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 34, height: 32))
        button.setImage(UIImage(named: "date_picker"), for: .normal)
        button.touchEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
        rightContainerView.addSubview(button)
        self.rightView = rightContainerView
        self.rightViewMode = .always
        
        button.addTarget(self, action: #selector(buttonTap(button:)), for: .touchUpInside)
    }
    
    @objc private func buttonTap(button: UIButton) {
        self.becomeFirstResponder()
    }
}
