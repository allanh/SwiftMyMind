//
//  MainFunctionEntryViewController.swift
//  MyMind
//
//  Created by Barry Chen on 2021/3/11.
//

import UIKit

enum MainFunctoinType: String {
    case purchaseApply = "採購申請"
    case paybill = "付款單"
    case saleChart = "銷售報表"
    case revenueChart = "營收報表"
    case systemSetting = "系統設定"
    case accountSetting = "帳號設定"
}

final class MainFunctionEntryViewController: NiblessViewController {
    typealias FunctionControlInfo = (type: MainFunctoinType, imageName: String)
    private var functionControls: [MainFunctionControl] = []


    private let functionControlInfos: [FunctionControlInfo] = [
        (.purchaseApply, "buy_icon"),
        (.paybill, "pay_icon"),
        (.saleChart, "sale_icon"),
        (.revenueChart, "renvenu_icon"),
        (.systemSetting, "system_setting_icon"),
        (.accountSetting, "account_setting_icon")
    ]

    private let stackView: UIStackView = UIStackView {
        $0.spacing = 30
        $0.axis = .vertical
        $0.distribution = .fillEqually
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        title = "站內功能"
        navigationController?.navigationBar.tintColor = .white
        constructViewHeirarchy()
        creatFuncitonControls()
        constructStackViews()
        activateConstraintsStackView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    private func constructViewHeirarchy() {
        view.addSubview(stackView)
    }

    private func activateConstraintsStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let centerX = stackView.centerXAnchor
            .constraint(equalTo: view.centerXAnchor)
        let centerY = stackView.centerYAnchor
            .constraint(equalTo: view.centerYAnchor)
        let width = stackView.widthAnchor
            .constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        let height = stackView.heightAnchor
            .constraint(equalTo: stackView.widthAnchor, multiplier: 1.7)
        NSLayoutConstraint.activate([
            centerX, centerY, width, height
        ])
    }

    private func constructStackViews() {
        var horizontalStackView: UIStackView? = creatHorizontalStackView()
        for index in 0..<functionControls.count {
            if horizontalStackView == nil {
                horizontalStackView = creatHorizontalStackView()
            }
            horizontalStackView?.addArrangedSubview(functionControls[index])
            if (index + 1) % 2 == 0{
                self.stackView.addArrangedSubview(horizontalStackView!)
                horizontalStackView = nil
            }
        }
    }

    private func creatHorizontalStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 40
        return stackView
    }

    private func creatFuncitonControls() {
        for item in functionControlInfos {
            let functionControl = MainFunctionControl(mainFunctionType: item.type)
            functionControl.imageView.image = UIImage(named: item.imageName)
            functionControl.addTarget(self, action: #selector(didTapFunctionControl(_:)), for: .touchUpInside)
            functionControls.append(functionControl)
        }
    }

    @objc
    private func didTapFunctionControl(_ sender: MainFunctionControl) {
        switch sender.functionType {
        case .purchaseApply:
            let navigationController = UINavigationController(rootViewController: PurchaseListViewController(purchaseListLoader: MyMindPurchaseAPIService.shared))
            navigationController.modalPresentationStyle = .fullScreen
            show(navigationController, sender: nil)
        default:
            print(sender.functionType)
        }
    }

}
