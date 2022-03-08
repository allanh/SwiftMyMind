//
//  BulletinCollectionViewCell.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/8/30.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

protocol BulletinCollectionViewCellDelegate: AnyObject {
    func showAnnouncement(id: Int)
}

class BulletinCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var marqueeView: UDNSKInteractiveMarqueeView!
    @IBOutlet weak var bulletinView: RollingNoticeView!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var announcementButton: UIButton!
    private weak var delegate: BulletinCollectionViewCellDelegate?

    var bulletins: BulletinList? {
        didSet {
            bulletinView.isHidden = bulletins?.items.count ?? 0 == 0
            self.bulletinView.reloadDataAndStartRoll()
        }
    }
    
    var account: Account? {
        didSet {
            DispatchQueue.main.async {
                if let session = KeychainUserSessionDataStore().readUserSession() {
                    let accountUnit = String(session.businessInfo.name)
                    self.accountLabel.text = "Hello, \(self.account?.account ?? "")/\(accountUnit)"
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bulletinView.dataSource = self
        bulletinView.delegate = self
        bulletinView.backgroundColor = .clear
        bulletinView.register(UINib.init(nibName: "BulletinView", bundle: nil), forCellReuseIdentifier: "BulletinView")
        marqueeView.isHidden = true
        bulletinView.isHidden = true
        announcementButton.touchEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
        
        accountLabel.applySketchShadow(color: .black, alpha: 0.5, x: 0, y: 3, blur: 4, spread: 0)
        welcomeLabel.applySketchShadow(color: .black, alpha: 0.5, x: 0, y: 3, blur: 4, spread: 0)

    }
    func config(with bulletins: BulletinList?, account: Account?, delegate: BulletinCollectionViewCellDelegate? = nil) {
        self.account = account
        self.bulletins = bulletins
        self.delegate = delegate
    }
}


extension BulletinCollectionViewCell: RollingNoticeViewDelegate, RollingNoticeViewDataSource {
    func numberOfRowsFor(roolingView: RollingNoticeView) -> Int {
        return self.bulletins?.items.count ?? 0
    }
    
    func rollingNoticeView(roolingView: RollingNoticeView, cellAtIndex index: Int) -> NoticeViewCell {
        if let cell = roolingView.dequeueReusableCell(withIdentifier: "BulletinView") as? BulletinView {
            cell.titleLabel.text = self.bulletins?.items[index].title ?? ""
            return cell
        }
        return NoticeViewCell()
    }
    
    func rollingNoticeView(_ roolingView: RollingNoticeView, didClickAt index: Int) {
        if let id = self.bulletins?.items.getElement(at: index)?.id {
            delegate?.showAnnouncement(id: id)
        }
    }
}
