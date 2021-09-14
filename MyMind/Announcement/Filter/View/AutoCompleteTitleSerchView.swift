//
//  AutoCompleteTitleSerchView.swift
//  MyMind
//
//  Created by Chijung Chan on 2021/9/2.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class AutoCompleteTitleSerchView: NiblessView {
        let textField: CustomClearButtonPositionTextField = CustomClearButtonPositionTextField {
        $0.font = .pingFangTCRegular(ofSize: 14)
            $0.textColor = .veryDarkGray
        //$0.setLeftPaddingPoints(10)
        $0.layer.cornerRadius = 4
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.separator.cgColor
        let containerView = UIView()
        containerView.frame = CGRect(origin: .zero, size: .init(width: 35, height: 25))
        let iconImageView = UIImageView(image: UIImage(named: "search"))
        iconImageView.frame = CGRect(origin: .zero, size: .init(width: 25, height: 25))
        containerView.addSubview(iconImageView)
        $0.leftView = containerView
        $0.leftViewMode = .unlessEditing
        $0.clearButtonMode = .whileEditing
    }
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewLeftAlignedLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    lazy var collectionViewHeightAnchor: NSLayoutConstraint = {
        return self.collectionView.heightAnchor.constraint(equalToConstant: 0)
    }()
    
    //MARK: - Methods
    override func didMoveToWindow() {
        super.didMoveToWindow()
        constructViewHierarchy()
        activateConstraints()
    }
    func constructViewHierarchy() {
        addSubview(textField)
        addSubview(collectionView)
    }
    func activateConstraints() {
        activateConstraintsTextField()
        activateConstraintsColllectionView()
    }

}
// MARK: - Layout
extension AutoCompleteTitleSerchView {
    func activateConstraintsTextField() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        let top = textField.topAnchor
            .constraint(equalTo: topAnchor, constant: 10)
        let leading = textField.leadingAnchor
            .constraint(equalTo: leadingAnchor, constant: 20)
        let trailing = textField.trailingAnchor
            .constraint(equalTo: trailingAnchor, constant: -20)
        let height = textField.heightAnchor
            .constraint(equalToConstant: 40)
        
        NSLayoutConstraint.activate([
            top, leading, trailing, height
        ])
        
    }
    func activateConstraintsColllectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let top = collectionView.topAnchor
            .constraint(equalTo: textField.bottomAnchor, constant: 20)
        let leading = collectionView.leadingAnchor
            .constraint(equalTo: textField.leadingAnchor)
        let trailing = collectionView.trailingAnchor
            .constraint(equalTo: textField.trailingAnchor)
        let bottom = collectionView.bottomAnchor
            .constraint(equalTo: bottomAnchor, constant: -5)
        
        NSLayoutConstraint.activate([
            top, leading, trailing, bottom
        ])
        
    }
}
