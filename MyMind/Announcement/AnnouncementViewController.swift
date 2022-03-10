//
//  AnnouncementViewController.swift
//  MyMind
//
//  Created by Chijung Chan on 2021/8/31.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
import WebKit

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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // MARK: - UI

    private let contentView: UIView = UIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private let typeLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .prussianBlue
        $0.textColor = .white
        $0.textAlignment = NSTextAlignment.center
        $0.font = .pingFangTCRegular(ofSize: 12)
        $0.clipsToBounds = true
    }
    
    private let timeLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .brownGrey2
        $0.font = .pingFangTCRegular(ofSize: 12)
    }
    
    private let titleLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .emperor
        $0.font = .pingFangTCSemibold(ofSize: 16)
        $0.numberOfLines = 0
    }

    private let contentWebView: WKWebView = WKWebView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.autoresizesSubviews = false
    }

    // MARK: - Methods
    private func constructViewHierarchy() {
        view.addSubview(contentView)
        contentView.addSubview(typeLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentWebView)
    }
    
    private func activateConstraints() {
        activateConstraintsContentView()
        activateConstraintsTypeLabel()
        activateConstraintsTimeLabel()
        activateConstraintsTitleLabel()
        activateConstraintscontentWebView()
    }
    
    private func setup() {
        typeLabel.text = announcement?.type.description
        timeLabel.text = formatter.string(from: announcement?.started ?? Date())
        titleLabel.text = announcement?.title
        if let htmlString = announcement?.content {
            contentWebView.loadHTMLString(htmlString, baseURL: nil)
        }
        title = announcement?.type.description
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
    private func activateConstraintsContentView() {
        let width = contentView.widthAnchor.constraint(equalTo: view.widthAnchor)
        let top = contentView.topAnchor.constraint(equalTo: view.topAnchor, constant: self.navigationBarWithStatusBarHeight)
        let bottom = contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        let leading = contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let trailing = contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        
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
        let leading = timeLabel.leadingAnchor.constraint(equalTo: typeLabel.trailingAnchor, constant: 8)
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

    func activateConstraintscontentWebView() {
        let top = contentWebView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8)
        let leading = contentWebView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor)
        let trailing = contentWebView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        let bottom = contentWebView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        
        NSLayoutConstraint.activate([
            top, leading, trailing, bottom
        ])
    }
}
