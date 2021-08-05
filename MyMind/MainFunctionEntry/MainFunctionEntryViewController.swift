//
//  MainFunctionEntryViewController.swift
//  MyMind
//
//  Created by Barry Chen on 2021/3/11.
//

import UIKit

enum MainFunctoinType: String {
    case purchaseApply = "採購申請"
    case purchaseReview = "採購審核"
    case paybill = "付款單"
    case saleChart = "銷售報表"
    case revenueChart = "營收報表"
    case systemSetting = "系統設定"
    case accountSetting = "帳號設定"
}

final class MainFunctionEntryViewController: NiblessViewController {
    
    typealias FunctionControlInfo = (type: MainFunctoinType, imageName: String)
    private var functionControls: [MainFunctionControl] = []
//    private var functionControls: [UIView] = []
    var authorization: Authorization?


    private var functionControlInfos: [FunctionControlInfo] = [
//        (.purchaseApply, "buy_icon"),
//        (.purchaseReview, "examine_icon"),
//        (.paybill, "pay_icon"),
//        (.saleChart, "sale_icon"),
//        (.revenueChart, "renvenu_icon"),
//        (.systemSetting, "system_setting_icon"),
//        (.accountSetting, "account_setting_icon")
    ]

    private let stackView: UIStackView = UIStackView {
        $0.spacing = 30
        $0.axis = .vertical
        $0.distribution = .fillProportionally
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        title = "功能"
        navigationController?.navigationBar.tintColor = .white
        if let authorization = authorization {
            if authorization.navigations.purchase.contains(.purapp) {
                functionControlInfos.append((.purchaseApply, "buy_icon"))
            }
            if authorization.navigations.purchase.contains(.purrev) {
                functionControlInfos.append((.purchaseReview, "examine_icon"))

            }
        }
        functionControlInfos.append((.accountSetting, "account_setting_icon"))
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

    private let rowHeight: CGFloat = 120
    private let columns = 2
    private func activateConstraintsStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let top = stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20)
        let centerX = stackView.centerXAnchor
            .constraint(equalTo: view.centerXAnchor)
        let width = stackView.widthAnchor
            .constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        let numberOfRows = functionControlInfos.count / columns + 1
        let height = stackView.heightAnchor.constraint(equalToConstant: CGFloat(numberOfRows)*rowHeight+stackView.spacing)
        NSLayoutConstraint.activate([
            centerX, top, width, height
        ])
    }
    private func constructStackViews() {
        var horizontalStackView: UIView? = creatHorizontalView()
        for index in 0..<functionControls.count {
            if horizontalStackView == nil {
                horizontalStackView = creatHorizontalView()
            }
            horizontalStackView?.addSubview(functionControls[index])
            if (index + 1) % 2 == 0{
                self.stackView.addArrangedSubview(horizontalStackView!)
                horizontalStackView = nil
            }
        }
        if let lastView = horizontalStackView {
            self.stackView.addArrangedSubview(lastView)
        }
    }
    private func creatHorizontalView() -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.stackView.bounds.width, height: rowHeight))
        return view
    }

    private func creatFuncitonControls() {
        let width = view.bounds.width*0.8
        let itemWidth = width * 0.45
        for (index, item) in functionControlInfos.enumerated() {
            let x = index%2 == 0 ? 0 : width-itemWidth
            let functionControl = MainFunctionControl(frame: CGRect(x: x, y: 0, width: itemWidth, height: rowHeight),  mainFunctionType: item.type)
            functionControl.imageView.image = UIImage(named: item.imageName)
            functionControl.addTarget(self, action: #selector(didTapFunctionControl(_:)), for: .touchUpInside)
            functionControls.append(functionControl)
        }
    }

    @objc
    private func didTapFunctionControl(_ sender: MainFunctionControl) {
        switch sender.functionType {
        case .purchaseApply:
            show(PurchaseListViewController(purchaseListLoader: MyMindPurchaseAPIService.shared), sender: nil)
        case .paybill:
            let storyboard: UIStoryboard = UIStoryboard(name: "TOTP", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "SecretListViewControllerNavi")
            present(viewController, animated: true, completion: nil)
        case .purchaseReview:
            show(PurchaseListViewController(purchaseListLoader: MyMindPurchaseReviewAPIService.shared, reviewing: true), sender: nil)
        case .accountSetting:
            if let settingViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Setting") as? SettingViewController {
                settingViewController.delegate = self
                show(settingViewController, sender: nil)
            }

        default:
            print(sender.functionType)
        }
    }

}
extension MainFunctionEntryViewController: MixedDelegate {
    func didSignOut() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    func didCancel() {
        self.navigationController?.popViewController(animated: true)
    }
}
