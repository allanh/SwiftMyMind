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
    var id: Int = 0
    private var isNetworkProcessing: Bool = true {
        didSet {
            switch isNetworkProcessing {
            case true: startAnimatingActivityIndicator()
            case false: stopAnimatinActivityIndicator()
            }
        }
    }
    private var announcement: Announcement? = nil {
        didSet {
            constructViewHierarchy()
            activateConstraints()
            setup()
        }
    }
    private let formatter: DateFormatter = DateFormatter {
        $0.dateFormat = "yyyy/MM/dd hh:mm"
    }
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
        $0.layer.cornerRadius = 8
        $0.backgroundColor = UIColor(hex: "004477")
        $0.textColor = .white
        $0.textAlignment = NSTextAlignment.center
        $0.font = .pingFangTCRegular(ofSize: 12)
        $0.clipsToBounds = true
    }
    private let timeLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = UIColor(hex: "b4b4b4")
        $0.font = .pingFangTCRegular(ofSize: 12)
    }
    private let titleLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = UIColor(hex: "545454")
        $0.font = .pingFangTCSemibold(ofSize: 16)
        $0.numberOfLines = 0
    }

    private let contentLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .black
        $0.numberOfLines = 0
        $0.font = .pingFangTCRegular(ofSize: 14)
    }

    // MARK: - Methods
    private func constructViewHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(typeLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
    }
    
    private func activateConstraints() {
        activateConstraintsScrollView()
        activateConstraintsContentView()
        activateConstraintsTypeLabel()
        activateConstraintsTimeLabel()
        activateConstraintsTitleLabel()
        activateConstraintsContentLabel()
    }
    private func setup() {
        typeLabel.text = announcement?.type.description
        timeLabel.text = formatter.string(from: announcement?.started ?? Date())
        titleLabel.text = announcement?.title
        contentLabel.text = announcement?.content
    }
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        isNetworkProcessing = true
        MyMindAnnouncementAPIService.shared.announcement(for: id)
            .ensure {
                self.isNetworkProcessing = false
            }
            .done { announcement in
                self.announcement = announcement
            }
            .catch { error in
                if let apiError = error as? APIError {
                    _ = ErrorHandler.shared.handle(apiError)
                } else {
                    ToastView.showIn(self, message: error.localizedDescription)
                }
            }
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
        let size = ((announcement?.type.description ?? "") as NSString).size(withAttributes: [.font: typeLabel.font as Any])

        let top = typeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16)
        let leading = typeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        let width = typeLabel.widthAnchor.constraint(equalToConstant: size.width+16)
        let height = typeLabel.heightAnchor.constraint(equalToConstant: 16)
        
        NSLayoutConstraint.activate([
            top, leading, width, height
        ])

        NSLayoutConstraint.activate([
            top, leading
        ])
    }
    func activateConstraintsTimeLabel() {
        let leading = timeLabel.leadingAnchor.constraint(equalTo: typeLabel.leadingAnchor, constant: 8)
        let centerY = timeLabel.centerYAnchor.constraint(equalTo: typeLabel.centerYAnchor)
        
        NSLayoutConstraint.activate([
            centerY, leading
        ])
    }
    func activateConstraintsTitleLabel() {
        let leading = titleLabel.leadingAnchor.constraint(equalTo: typeLabel.leadingAnchor)
        let trailing = titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        let top = titleLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 16)
        
        NSLayoutConstraint.activate([
            trailing, leading, top
        ])
    }

    func activateConstraintsContentLabel() {
        let top = contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8)
        let leading = contentLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor)
        let trailing = contentLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        let bottom = contentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        
        NSLayoutConstraint.activate([
            top, leading, trailing, bottom
        ])
    }

}
