//
//  ToDoListCollectionViewCell.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/10.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

protocol ToDoListCollectionViewCellDelegate: AnyObject {
    func showToDoListPopupWindow(index: Int)
}

class ToDoListCollectionViewCell : UICollectionViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    private weak var delegate: ToDoListCollectionViewCellDelegate?
    
    private var toDos: [ToDo] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // remove all the spaces
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            collectionView.collectionViewLayout = layout
        }
    }
    func config(with toDos:[ToDo], delegate: ToDoListCollectionViewCellDelegate?) {
        self.toDos = toDos
        self.delegate = delegate
    }

}
extension ToDoListCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return toDos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(ToDoInfoCollectionViewCell.self, for: indexPath) as? ToDoInfoCollectionViewCell else {
            fatalError("Wrong cell identifier or not registered yet")
        }
        cell.config(with: toDos[indexPath.item])
        return cell
    }
}
extension ToDoListCollectionViewCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return  CGSize(width: 149, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        delegate?.showToDoListPopupWindow(index: indexPath.row)
    }
}

