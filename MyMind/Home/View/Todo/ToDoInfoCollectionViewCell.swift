//
//  ToDoInfoCollectionViewCell.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/10.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class ToDoInfoCollectionViewCell: UICollectionViewCell {
    var infoView: ToDoInfoView!
    func config(with toDo: ToDo) {
        infoView = ToDoInfoView(frame: bounds.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)), toDo: toDo)
        contentView.addSubview(infoView)
    }

}
