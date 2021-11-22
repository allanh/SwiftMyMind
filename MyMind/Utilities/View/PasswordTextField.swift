//
//  PasswordTextField.swift
//  MyMind
//
//  Created by Shih Allan on 2021/11/22.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import UIKit

class PasswordTextField: UITextField {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.cornerRadius = 4.0
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.border.cgColor
        self.layer.masksToBounds = true
        isSecureTextEntry = true
        
        // lock image
        let image = UIImage(named: "lock")
        let leftContainerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 30, height: 30)))
        let imageView = UIImageView(frame: CGRect(x: 8, y: leftContainerView.frame.midY-7, width: 14, height: 14))
        imageView.image = image
        leftContainerView.addSubview(imageView)
        leftView = leftContainerView
        leftViewMode = .always
        
        // eye image
        let rightContainerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 30, height: 30)))
        let button = UIButton(frame: CGRect(x: 8, y: rightContainerView.frame.midY-7, width: 14, height: 14))
        button.setImage(UIImage(named: "eye_open"), for: .normal)
        button.setImage(UIImage(named: "eye_close"), for: .selected)
        button.touchEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
        button.isSelected = true
        rightContainerView.addSubview(button)
        rightView = rightContainerView
        rightViewMode = .always
        

        button.addTarget(self, action: #selector(eyeButtonTap(button:)), for: .touchUpInside)
    }
    
    @objc func eyeButtonTap(button: UIButton) {
        button.isSelected.toggle()
        isSecureTextEntry = button.isSelected
    }
}
