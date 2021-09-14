//
//  AnnouncementFilterViewController.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/9/9.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class AnnouncementFilterViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @objc
    private func closeButtonDidTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    @objc
    private func resetButtonDidTapped(_ sender: UIButton) {
        titleTextField.text = nil
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "篩選條件"
        let close = UIButton(type: .custom)
        close.setImage(UIImage(named: "close")?.withRenderingMode(.alwaysTemplate), for: .normal)
        close.addTarget(self, action: #selector(closeButtonDidTapped(_:)), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: close)
        navigationItem.leftBarButtonItem = leftBarButton
        let reset = UIButton(type: .custom)
        reset.setTitle("重置", for: .normal)
        reset.addTarget(self, action: #selector(resetButtonDidTapped(_:)), for: .touchUpInside)
        let rightBarButton = UIBarButtonItem(customView: reset)
        navigationItem.rightBarButtonItem = rightBarButton
        titleTextField.layer.cornerRadius = 4
        titleTextField.layer.borderWidth = 1
        titleTextField.layer.borderColor = UIColor.lightGray.cgColor
        let containerView = UIView()
        containerView.frame = CGRect(origin: .zero, size: .init(width: 35, height: 25))
        let iconImageView = UIImageView(image: UIImage(named: "search")?.withRenderingMode(.alwaysTemplate))
        iconImageView.tintColor = .lightGray
        iconImageView.frame = CGRect(origin: .zero, size: .init(width: 25, height: 25))
        containerView.addSubview(iconImageView)
        titleTextField.leftView = containerView
        titleTextField.leftViewMode = .always

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
