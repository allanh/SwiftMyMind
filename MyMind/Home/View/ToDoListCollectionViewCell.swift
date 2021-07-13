//
//  ToDoListCollectionViewCell.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/10.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
class ToDoListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var toDoListCollectionView: UICollectionView!
    private var toDos: [ToDo] = [] {
        didSet {
            toDoListCollectionView.reloadData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        toDoListCollectionView.dataSource = self
        toDoListCollectionView.delegate = self
        toDoListCollectionView.clipsToBounds = true
        toDoListCollectionView.layer.cornerRadius = 16
        toDoListCollectionView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    func config(with toDos:[ToDo]) {
        self.toDos = toDos
    }

}
extension ToDoListCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return toDos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ToDoInfoCollectionViewCell", for: indexPath) as? ToDoInfoCollectionViewCell {
            cell.config(with: toDos[indexPath.item])
            return cell
        }
        return UICollectionViewCell()
    }
}
extension ToDoListCollectionViewCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return  CGSize(width: toDoListCollectionView.bounds.size.width-60, height: toDoListCollectionView.bounds.size.height-16)
    }
}

