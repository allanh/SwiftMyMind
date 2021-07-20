//
//  MainPageViewController.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/15.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class MainPageViewController: UIViewController {

    @IBOutlet weak var otpView: UIView!
    @IBOutlet weak var myMindView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let navigationTitleView: UIImageView = UIImageView {
            $0.image = UIImage(named: "udi_logo")
        }
        let leftItem = UIBarButtonItem(customView: navigationTitleView)
        navigationItem.leftBarButtonItem = leftItem
        
        
        let otpTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(otp(_:)))
        otpView.layer.cornerRadius = 10
        otpView.layer.shadowOffset = CGSize(width: 0, height: 3)
        otpView.layer.shadowOpacity = 0.6
        otpView.addGestureRecognizer(otpTapGestureRecognizer)
        let myMindTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(myMind(_:)))
        myMindView.layer.cornerRadius = 10
        myMindView.layer.shadowOffset = CGSize(width: 0, height: 3)
        myMindView.layer.shadowOpacity = 0.6
        myMindView.addGestureRecognizer(myMindTapGestureRecognizer)
        navigationItem.backButtonTitle = ""
        
    }
    
    @IBAction func otp(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "TOTP", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SecretListViewController")
        show(viewController, sender: self)
    }
    @IBAction func myMind(_ sender: Any) {
        MyMindEmployeeAPIService.shared.authorization()
            .done { authorization in
                let rootTabBarViewController = RootTabBarController(authorization: authorization)
                self.show(rootTabBarViewController, sender: self)
            }
            .ensure {
            }
            .catch { error in
                _ = ErrorHandler.shared.handle((error as! APIError))
            }
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
