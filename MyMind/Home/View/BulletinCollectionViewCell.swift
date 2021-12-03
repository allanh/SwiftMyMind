//
//  BulletinCollectionViewCell.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/8/30.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class BulletinCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var marqueeView: UDNSKInteractiveMarqueeView!
    @IBOutlet weak var bulletinView: RollingNoticeView!
    
    var bulletins: BulletinList? {
        didSet {
            bulletinView.isHidden = bulletins?.items.count ?? 0 == 0
            self.bulletinView.reloadDataAndStartRoll()
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
    }
    func config(with bulletins: BulletinList?) {
        self.bulletins = bulletins
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
         print("did click index: \(roolingView.currentIndex)")
    }
}
