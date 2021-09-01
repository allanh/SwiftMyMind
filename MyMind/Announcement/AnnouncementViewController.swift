//
//  AnnouncementViewController.swift
//  MyMind
//
//  Created by Chijung Chan on 2021/8/31.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class AnnouncementViewController: UIViewController {
    
    // MARK: - Properties


    // MARK: - UI

    private let scrollView: UIScrollView = UIScrollView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.showsVerticalScrollIndicator = false // 顯示垂直滾動條
    }

    private let contentView: UIView = UIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private let typeLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 5
        $0.layer.borderColor = UIColor.orange.cgColor
        $0.textColor = .orange
        $0.text = "類別"
        $0.textAlignment = NSTextAlignment.center
        $0.font = .pingFangTCRegular(ofSize: 14)
    }

    private let contentLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .black
        $0.numberOfLines = 2
        $0.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
        $0.font = .pingFangTCRegular(ofSize: 14)
    }

    let timeLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = UIColor(hex: "b4b4b4")
        $0.text = "(2020/5/6 05:06)"
        $0.font = .pingFangTCRegular(ofSize: 12)
    }
    // MARK: - Methods
    private func constructViewHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(timeLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(contentLabel)
    }
    
    private func activateConstraints() {
        activateConstraintsScrollView()
        activateConstraintsContentView()
        activateConstraintsTypeLabel()
        activateConstraintsTimeLabel()
        activateConstraintsContentLabel()
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

}
    // MARK: - Layouts
extension AnnouncementViewController {

    private func activateConstraintsScrollView() {
        let top = scrollView.topAnchor.constraint(equalTo: view.topAnchor)
        let trailing = scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let leading = scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let bottom = scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        NSLayoutConstraint.activate([
            top, trailing, leading, bottom
        ])
    }

    private func activateConstraintsContentView() {
        let width = contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        let top = contentView.topAnchor.constraint(equalTo: scrollView.topAnchor)
        let bottom = contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        let leading = contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor)
        let trailing = contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
        
        NSLayoutConstraint.activate([
            width, top, bottom,leading, trailing
        ])
        
    }

    func activateConstraintsTypeLabel() {
        let top = typeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15)
        let leading = typeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15)
        
        NSLayoutConstraint.activate([
            top, leading
        ])
    }

    func activateConstraintsTimeLabel() {
        let top = timeLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 10)
        let leading = timeLabel.leadingAnchor.constraint(equalTo: typeLabel.leadingAnchor)
        
        NSLayoutConstraint.activate([
            top, leading
        ])
        }

    func activateConstraintsContentLabel() {
        let top = contentLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 15)
        let leading = contentLabel.leadingAnchor.constraint(equalTo: timeLabel.leadingAnchor)
        let trailing = contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        let bottom = contentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 15)
        
        NSLayoutConstraint.activate([
            top, leading, trailing, bottom
        ])
    }

}
