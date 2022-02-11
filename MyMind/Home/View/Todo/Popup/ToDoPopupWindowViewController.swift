//
//  ToDoPopupWindowViewController.swift
//  MyMind
//
//  Created by Shih Allan on 2022/1/28.
//  Copyright © 2022 United Digital Intelligence. All rights reserved.
//

import UIKit

class ToDoPopupWindowViewController: NiblessViewController {

    private var defaultIndex = 0
    private var toDos: [ToDo] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    private let backgroundView: UIView = UIView {
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
    
    private let pageControl: UIPageControl = {
        let view = UIPageControl()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.pageIndicatorTintColor = .border
        view.currentPageIndicatorTintColor = .prussianBlue
        return view
    }()
    
    private let closeImageView = UIImageView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "close_popup")
        $0.contentMode = .scaleAspectFit
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        constructViewHierarchy()
        activateConstraints()
        configCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
       self.collectionView.scrollToItem(at: NSIndexPath(item: self.defaultIndex, section: 0) as IndexPath,
                                   at: .centeredHorizontally,
                                   animated: false)
    }
    
    // MARK: - Methods

    init(toDos: [ToDo], index: Int) {
        self.toDos = toDos
        self.defaultIndex = index
        pageControl.numberOfPages = toDos.count
        super.init()
    }
    
    func config(index: Int) {
//        collectionView.scrollToItem(at: NSIndexPath(item: index, section: 0) as IndexPath, at: .centeredHorizontally, animated: false)
//        collectionView.selectItem(at: NSIndexPath(item: index, section: 0) as IndexPath, animated: false, scrollPosition: .centeredHorizontally)
    }
    
    private func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func constructViewHierarchy() {
        view.addSubview(backgroundView)
        // 1. create a gesture recognizer (tap gesture)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        // 2. add the gesture recognizer to a view
        backgroundView.addGestureRecognizer(tapGesture)
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        view.addSubview(closeImageView)
        closeImageView.addTapGesture {
            self.dismiss(animated: true, completion: nil)
        }
    }

    private func activateConstraints() {
        activateConstraintsbackgroundView()
        activateConstraintsCollectionView()
        activateConstraintsPageControl()
        activateConstraintsCloseImageView()
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

// MARK: - Layouts

extension ToDoPopupWindowViewController {
    private func activateConstraintsbackgroundView() {
        let leading = backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let trailing = backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let topAnchor = backgroundView.topAnchor.constraint(equalTo: view.topAnchor)
        let bottomAnchor = backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        NSLayoutConstraint.activate([
            leading, trailing, topAnchor, bottomAnchor
        ])
    }
    
    private func activateConstraintsCollectionView() {
        let leading = collectionView.leadingAnchor
            .constraint(equalTo: backgroundView.leadingAnchor, constant: 0)
        let trailing = collectionView.trailingAnchor
            .constraint(equalTo: backgroundView.trailingAnchor, constant: 0)
        let height = collectionView.heightAnchor.constraint(equalToConstant: 380)
        let centerYAnchor = collectionView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor)

        NSLayoutConstraint.activate([
            centerYAnchor, leading, trailing, height
        ])
    }
    
    private func activateConstraintsPageControl() {
        let bottom = pageControl.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor)
        let leading = pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let trailing = pageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let height = pageControl.heightAnchor.constraint(equalToConstant: 32)
        NSLayoutConstraint.activate([
            leading, trailing, bottom, height
        ])
    }
    
    private func activateConstraintsCloseImageView() {
        let centerXAnchor = closeImageView.centerXAnchor
            .constraint(equalTo: view.centerXAnchor)
        let top = closeImageView.topAnchor
            .constraint(equalTo: collectionView.bottomAnchor, constant: 40)

        NSLayoutConstraint.activate([
            centerXAnchor, top
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
    
    // For Display the page number in page controll of collection view Cell
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: self.collectionView.contentOffset, size: self.collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = self.collectionView.indexPathForItem(at: visiblePoint) {
            self.pageControl.currentPage = visibleIndexPath.row
        }
    }
}
