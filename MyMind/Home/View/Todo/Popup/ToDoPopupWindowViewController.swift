//
//  ToDoPopupWindowViewController.swift
//  MyMind
//
//  Created by Shih Allan on 2022/1/28.
//  Copyright © 2022 United Digital Intelligence. All rights reserved.
//

import UIKit

class ToDoPopupWindowViewController: NiblessViewController {

    private var toDos: [ToDo] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private let contentView: UIView = UIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .black.withAlphaComponent(0.5)
    }
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 52, bottom: 0, right: 52)
        layout.minimumLineSpacing = 24
//        layout.minimumInteritemSpacing = 8
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints =  false
        return collectionView
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationStyle = .overFullScreen
        constructViewHierarchy()
        activateConstraints()
        configCollectionView()
    }
    
    // MARK: - Methods

    init(toDos: [ToDo]) {
        self.toDos = toDos
        super.init()
    }
    
    func config(index: Int) {
//        collectionView.selectItem(at: NSIndexPath(item: index, section: 0) as IndexPath, animated: false, scrollPosition: .centeredHorizontally)
    }
    
    private func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func constructViewHierarchy() {
        view.addSubview(contentView)
        // 1. create a gesture recognizer (tap gesture)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        // 2. add the gesture recognizer to a view
        contentView.addGestureRecognizer(tapGesture)
        contentView.addSubview(collectionView)
    }

    private func activateConstraints() {
        activateConstraintsContentView()
        activateConstraintsCollectionView()
    }

    private func configCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerCell(ToDoCardCollectionViewCell.self)
        collectionView.register(ToDoCardCollectionViewCell.self, forCellWithReuseIdentifier: "ToDoCardCollectionViewCell")
    }
    
    // this method is called when a tap is recognized
    @objc func handleTap(sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ToDoPopupWindowViewController {

}

// MARK: - Layouts

extension ToDoPopupWindowViewController {
    private func activateConstraintsContentView() {
        let leading = contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let trailing = contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let topAnchor = contentView.topAnchor.constraint(equalTo: view.topAnchor)
        let bottomAnchor = contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        NSLayoutConstraint.activate([
            leading, trailing, topAnchor, bottomAnchor
        ])
    }
    
    private func activateConstraintsCollectionView() {
        let leading = collectionView.leadingAnchor
            .constraint(equalTo: contentView.leadingAnchor, constant: 0)
        let trailing = collectionView.trailingAnchor
            .constraint(equalTo: contentView.trailingAnchor, constant: 0)
        let height = collectionView.heightAnchor.constraint(equalToConstant: 380)
        let centerYAnchor = collectionView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)

        NSLayoutConstraint.activate([
            centerYAnchor, leading, trailing, height
        ])
    }
}

// MARK: -- UICollectionViewDataSource

extension ToDoPopupWindowViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return toDos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(ToDoCardCollectionViewCell.self, for: indexPath) as? ToDoCardCollectionViewCell else {
            fatalError("Wrong cell identifier or not registered yet")
        }
        if let toDo = toDos.getElement(at: indexPath.row) {
            cell.config(with: toDo)
            return cell
        } else {
            return ToDoCardCollectionViewCell()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ToDoPopupWindowViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                   layout collectionViewLayout: UICollectionViewLayout,
                   sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width * 0.72, height: 380)
    }
}
