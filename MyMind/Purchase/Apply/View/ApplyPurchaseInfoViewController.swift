//
//  ApplyPurchaseInfoViewController.swift
//  MyMind
//
//  Created by Barry Chen on 2021/6/10.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

final class ApplyPurchaseInfoViewController: UIViewController {

    @IBOutlet private weak var vendorNameLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var expectStorageDateTextField: CustomClearButtonPositionTextField!
    @IBOutlet private weak var warehouseTextField: CustomClearButtonPositionTextField!
    @IBOutlet private weak var recipientNameLabel: UILabel!
    @IBOutlet private weak var recipientPhoneLabel: UILabel!
    @IBOutlet private weak var recipientAddressLabel: UILabel!
    @IBOutlet private weak var checkPurchasedProductsButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
