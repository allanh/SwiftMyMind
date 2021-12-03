//
//  NoticeViewCell.swift
//  MyMind
//
//  Created by Shih Allan on 2021/11/26.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit


let RollingDebugLog = false

open class NoticeViewCell: UIView {
    
    open private(set) lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        self.addSubview(view)
        isAddedContentView = true
        return view
    }()
    
    open private(set) lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .pingFangTCSemibold(ofSize: 12)
        self.contentView.addSubview(label)
        return label
    }()
    
    @objc open private(set) var reuseIdentifier: String?
    fileprivate var isAddedContentView = false
    
    /// leading >= 0
    open var textLabelLeading: CGFloat
    /// trailing >= 0
    open var textLabelTrailing: CGFloat
    
    
    public required init(reuseIdentifier: String?, textLabelLeading: CGFloat = 10, textLabelTrailing: CGFloat = 10){
        
        self.textLabelLeading = textLabelLeading
        self.textLabelTrailing = textLabelTrailing
        self.reuseIdentifier = reuseIdentifier
        
        super.init(frame: .zero)
        
        if RollingDebugLog {
            print(String(format: "init a cell from code: %p", self))
        }
        
        setupInitialUI()
    }
    
    public required init?(coder aDecoder: NSCoder){
        self.textLabelLeading = 8
        self.textLabelTrailing = 8
        super.init(coder: aDecoder)
        if RollingDebugLog {
            print(String(format: "init a cell from xib: %p", self))
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if isAddedContentView {
            self.contentView.frame = self.bounds
            
            var lead = textLabelLeading
            if lead < 0 {
                lead = 0
            }
            var trai = textLabelTrailing
            if trai < 0 {
                trai = 0
            }

            var width = self.frame.size.width - lead - trai
            if width < 0 {
                width = 0
            }
            self.textLabel.frame = CGRect(x: lead, y: 0, width: width, height: self.frame.size.height)
        }
        
    }
    
    deinit {
        
        if RollingDebugLog {
            print(String(format: "cell deinit %p", self))
        }
    }
}

extension NoticeViewCell{
    fileprivate func setupInitialUI() {
        self.backgroundColor = .clear
    }
}
