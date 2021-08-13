//
//  PurchaseReviewingApplyInfoViewController.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/5.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
import RxSwift

class PurchaseReviewingApplyInfoViewController: UIViewController {

    @IBOutlet private weak var purchaseIDLabel: UILabel!
    @IBOutlet private weak var vendorNameLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var expectStorageDateLabel: UILabel!
    @IBOutlet private weak var warehouseLabel: UILabel!
    @IBOutlet private weak var recipientNameLabel: UILabel!
    @IBOutlet private weak var recipientPhoneLabel: UILabel!
    @IBOutlet private weak var recipientAddressLabel: UILabel!
    @IBOutlet private weak var checkPurchasedProductsButton: UIButton!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var totalCostLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    private let dateFormatter: DateFormatter = DateFormatter {
        $0.dateFormat = "yyyy-MM-dd"
    }

    var viewModel: PurchaseApplyInfoViewModel!
    let bag: DisposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bindToViewModel()
        subscribeViewModel()

        configureRootView()
        configureStatusLabel()
        configureContentWithViewModel()
    }
    private func configureRootView() {
        view.layer.cornerRadius = 4
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.separator.cgColor
    }

    private func bindToViewModel() {
        checkPurchasedProductsButton.rx.tap
            .map({ () })
            .bind(to: viewModel.showSuggestionInfo)
            .disposed(by: bag)
    }

    private func subscribeViewModel() {
        viewModel.purchaseID
            .compactMap({ $0 })
            .bind(to: purchaseIDLabel.rx.text)
            .disposed(by: bag)

//        viewModel.suggestionProductMaterialViewModels
//            .map({ "共 \($0.count) 件SKU" })
//            .bind(to: checkPurchasedProductsButton.rx.title())
//            .disposed(by: bag)

        viewModel.expectedStorageDate
            .map { [unowned self] date -> String in
                guard let date = date else { return "" }
                return dateFormatter.string(from: date)
            }
            .bind(to: expectStorageDateLabel.rx.text)
            .disposed(by: bag)

        viewModel.pickedWarehouse
            .map({ $0?.name })
            .bind(to: warehouseLabel.rx.text)
            .disposed(by: bag)

        viewModel.recipientName
            .bind(to: recipientNameLabel.rx.text)
            .disposed(by: bag)

        viewModel.recipientPhone
            .bind(to: recipientPhoneLabel.rx.text)
            .disposed(by: bag)

        viewModel.recipientAddress
            .bind(to: recipientAddressLabel.rx.text)
            .disposed(by: bag)
        
        viewModel.purchaseStatus
            .map({
                $0.description
            })
            .bind(to: statusLabel.rx.text)
            .disposed(by: bag)

        viewModel.suggestionProductMaterialViewModels
            .map({ "共 \($0.count) 件SKU" })
            .bind(to: summaryLabel.rx.text)
            .disposed(by: bag)
        let formatter: NumberFormatter = NumberFormatter {
            $0.numberStyle = .currency
            $0.currencySymbol = ""
        }

        let totalCost = viewModel.suggestionProductMaterialViewModels.value
            .map {
                $0.purchaseCost.value
            }.reduce(0) { (sum, num) -> Double in
                return sum+num
            }
        let tax = totalCost * 0.05
        totalCostLabel.text = formatter.string(from: NSNumber(value: totalCost))
        taxLabel.text = formatter.string(from: NSNumber(value: tax))
        totalLabel.text = formatter.string(from: NSNumber(value: totalCost+tax))
    }

    private func configureContentWithViewModel() {
        vendorNameLabel.text = viewModel.venderName
    }

   private func configureStatusLabel() {
        statusLabel.layer.borderWidth = 1
        statusLabel.layer.borderColor = UIColor.init(hex: "ff8500").cgColor
        statusLabel.layer.cornerRadius = 4

        statusLabel.textColor = UIColor.init(hex: "ff8500")
    }

    private func configRightIconForTextField(_ textField: UITextField, imageName: String) {
        let containerView = UIView()
        containerView.frame = CGRect(origin: .zero, size: .init(width: 35, height: 25))
        let iconImageView = UIImageView(image: UIImage(named: imageName))
        iconImageView.frame = CGRect(origin: .zero, size: .init(width: 25, height: 25))
        containerView.addSubview(iconImageView)
        textField.rightView = containerView
        textField.rightViewMode = .always
    }
}
