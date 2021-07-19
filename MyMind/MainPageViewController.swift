//
//  MainPageViewController.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/15.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class MainPageViewController: UIViewController {

    @IBOutlet weak var otpButton: UIButton!
    @IBOutlet weak var myMindButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let color1 = UIColor(hex: "ecedf0").cgColor
        let color2 = UIColor(hex: "f9f9f9").cgColor
        otpButton.centerVertically()
        otpButton.addGradient([color1, color2])
        otpButton.applySketchShadow()
        otpButton.layer.cornerRadius = 16
        otpButton.layer.borderWidth = 1
        otpButton.layer.borderColor = UIColor.secondaryLabel.cgColor
        otpButton.clipsToBounds = true
        
        myMindButton.centerVertically()
        myMindButton.addGradient([color1, color2])
        myMindButton.applySketchShadow()
        myMindButton.layer.cornerRadius = 16
        myMindButton.layer.borderWidth = 1
        myMindButton.layer.borderColor = UIColor.secondaryLabel.cgColor
        myMindButton.clipsToBounds = true
        
        navigationItem.backButtonTitle = ""
        title = "My Mind"
        
    }
    
    @IBAction func otp(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "TOTP", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SecretListViewControllerNavi")
        present(viewController, animated: true, completion: nil)
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
