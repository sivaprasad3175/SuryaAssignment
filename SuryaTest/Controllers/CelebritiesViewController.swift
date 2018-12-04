//
//  ViewController.swift
//  SuryaTest
//
//  Created by Siva on 04/12/18.
//  Copyright © 2018 Siva. All rights reserved.
//

import UIKit
import CoreData


class CelebritiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var userTable: UITableView!
    
    fileprivate lazy var logoutBtn: UIBarButtonItem = {
        let btn = UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.done, target: self, action: #selector(logoutBtnHandler))
        return btn
    }()
    
    fileprivate var celebritiesList = [User]()
    public var isFromLogin = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userTable.rowHeight = UITableView.automaticDimension
        setUpView()
    }
    
    fileprivate func fetchDataFromDb() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let parserHelper = CoreDataHelper(persistentContainer: appDelegate.persistentContainer)
        if let list = parserHelper.getStoredData() {
            DispatchQueue.main.async {
                self.celebritiesList = list
                self.userTable.reloadData()
            }
        }
    }
    
    fileprivate func setUpView(){
        self.navigationItem.title = "Celebrities"
        self.navigationItem.rightBarButtonItem = logoutBtn
        
        self.fetchDataFromDb()
        
        if !isFromLogin {
            handleBackgroundRefresh()
        }
    }
    
    //MARK:- Tableview Delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return celebritiesList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! CustomCell
        cell.user = celebritiesList[indexPath.row]
        return cell
    }
    
    @objc fileprivate func logoutBtnHandler() {
        let loginVC = self.storyboard!.instantiateViewController(withIdentifier: "login_view_controller_identifier")
        let navController = UINavigationController(rootViewController: loginVC)
        self.present(navController, animated: false, completion: nil)
    }
    
    fileprivate func handleBackgroundRefresh() {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            guard let userEmail = UserDefaults.standard.value(forKey: "user_email") as? String else {return}
            HTTPRequests.ApiCall(params: ["emailId": userEmail], completionHandler: { (isSuccesssful) in
                self.fetchDataFromDb()
            })
        }
    }
}

