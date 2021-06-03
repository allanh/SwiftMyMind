//
//  PurchaseProductSuggestionViewController.swift
//  MyMind
//
//  Created by Chen Yi-Wei on 2021/6/2.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class PurchaseProductSuggestionViewController: UIViewController {

    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var numberLabel: UILabel!
    @IBOutlet private weak var originalNumberLabel: UILabel!
    @IBOutlet private weak var suggestedQuantityButton: UIButton!
    @IBOutlet private weak var suggestedQuantityLabel: UILabel!
    @IBOutlet private weak var purchaseCostTextField: UITextField!
    @IBOutlet private weak var purchaseQuantityTextField: UITextField!
    @IBOutlet private weak var unitLabel: UILabel!
    @IBOutlet private weak var boxCounterLabel: UILabel!
    @IBOutlet private weak var totalPurchaseCostTextField: UITextField!
    @IBOutlet weak var deleteButton: UIButton!

    var viewModel: SuggestionProductMaterialViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
