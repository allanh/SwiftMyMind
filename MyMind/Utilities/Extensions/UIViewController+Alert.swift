//
//  UIViewController+Alert.swift
//  MyMind
//
//  Created by Shih Allan on 2021/11/16.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(title: String?, message: String?, action: ((UIAlertAction) -> Void)? = nil) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        controller.setValue(NSAttributedString(string: "確定返回嗎？",
                                               attributes: [NSAttributedString.Key.font : UIFont.pingFangTCSemibold(ofSize: 16),
                                                            NSAttributedString.Key.foregroundColor : UIColor.prussianBlue]), forKey: "attributedTitle")
        controller.setValue(NSAttributedString(string: "您目前編輯的資料尚未儲存，請確定是否要返回。",
                                               attributes: [NSAttributedString.Key.font : UIFont.pingFangTCRegular(ofSize: 14),
                                                            NSAttributedString.Key.foregroundColor :UIColor.brownGrey]), forKey: "attributedMessage")

        let okAction = UIAlertAction(title: "確定", style: .default, color: UIColor.prussianBlue, handler: action)
        controller.addAction(okAction)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, color: UIColor.brownGrey2, handler: nil)
        controller.addAction(cancelAction)
        DispatchQueue.main.async {
            self.present(controller, animated: true, completion: nil)
        }
    }
}
