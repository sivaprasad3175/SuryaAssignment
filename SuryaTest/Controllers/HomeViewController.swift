//
//  HomeViewController.swift
//  SuryaTest
//
//  Created by Siva on 04/12/18.
//  Copyright © 2018 Siva. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var mailId: UITextField!
    @IBOutlet weak var verifyBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func verifyBtnHandler(_ sender: UIButton) {
        let email = mailId.text!
        if !email.isValidEmail || email.isEmpty {
            self.showToast(message: "Enter proper Id")
            return
        }
        let params = ["emailId": email] as [String:Any]
        verifyBtn.isEnabled = false
        HTTPRequests.ApiCall(params: params) { (isSuccessful) in
            self.verifyBtn.isEnabled = true
            UserDefaults.standard.set(isSuccessful, forKey: "is_logged_in")
            UserDefaults.standard.set(email, forKey: "user_email")
            self.handleCelebrityController()
        }
    }

    func handleCelebrityController() {
        let celebrityVC = self.storyboard!.instantiateViewController(withIdentifier: "celebrity_view_controller_identifier") as! CelebritiesViewController
        celebrityVC.isFromLogin = true
        let navController = UINavigationController(rootViewController: celebrityVC)
        self.present(navController, animated:true, completion: nil)
    }
}
