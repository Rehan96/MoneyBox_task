//
//  Home.swift
//  MoneyBox ios technical task
//
//  Created by Rehan Khan on 13/08/2019.
//  Copyright © 2019 Rehan. All rights reserved.
//

import UIKit
import Firebase
var name = String()


class Home: UIViewController {
    
    // hides nav bar on load
    override func viewDidAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    // Button
    lazy var addMoney: UIButton = {
        let widthAnchor = CGFloat(100)
        let heightAnchor = CGFloat(30)
        let button = UIButton(type: .system)
        button.backgroundColor = .gray
        button.setTitle("Add £10", for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(AddValues), for: .touchUpInside)
        button.widthAnchor.constraint(equalToConstant: widthAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: heightAnchor).isActive = true
        return button
    }()
    

    lazy var logOutBtn: UIButton = {
        let widthAnchor = CGFloat(100)
        let heightAnchor = CGFloat(30)
        let button = UIButton(type: .system)
        button.setTitle("Log Out", for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(red, for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(logOut), for: .touchUpInside)
        button.widthAnchor.constraint(equalToConstant: widthAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: heightAnchor).isActive = true
        return button
    }()
    
    // Log User out function
    @objc func logOut(){
      try! Auth.auth().signOut()
        let vc = ViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // Labels
    func createTitle(text: String)-> UILabel {
        let lb = UILabel()
        lb.text = text
        lb.textColor = .black
        lb.textAlignment = .center
        lb.font = UIFont(name: "Arial", size: 26)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }
    lazy var Title = createTitle(text: "User Accounts")
    
    func createLabel()-> UILabel {
        let lb = UILabel()
        lb.textColor = .black
        lb.textAlignment = .center
        lb.font = UIFont(name: "Arial", size: 17)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }
    
    // Decleration of welcome name and total plan value labels
    lazy var welcomeLbl = createLabel()
    lazy var totlPlanVl = createLabel()
    
    
    // decleration of first Acccount labels
    lazy var account1 = createLabel()
    lazy var planVlAc1 = createLabel()
    lazy var mnyboxAc1 = createLabel()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // get user details and set contraints
        getUser()
        constraints()
        view.backgroundColor = .white
        
    }
   
    // name of user and total plan value
    var nameDB = String()
    var totalPlanVlDB = Int()
    
    
    // Acccount 1 decleration
    var acc1 = String()
    var accPln1 = Int()
    var accMny1 = Int()
    
    func getUser(){
        
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }

        
        let uid = Auth.auth().currentUser?.uid
        
        Database.database().reference().child("Users").child(currentUserUID).observeSingleEvent(of: .value) { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                
                self.nameDB = ((dictionary as? NSDictionary)?["name"] as? String)!
                 self.totalPlanVlDB = (((dictionary as? NSDictionary)?["planValue"] as? Int)!)
                
                self.acc1 = ((dictionary as? NSDictionary)?["account1"] as? String)!
                self.accPln1 = ((dictionary as? NSDictionary)?["account1PlanValue"] as? Int)!
                self.accMny1 = ((dictionary as? NSDictionary)?["account1MoneyBox"] as? Int)!
            }
            print(snapshot)
            print("Current User ID: " + currentUserUID)
            print("Name of User is: " +  self.nameDB)
            self.welcomeLbl.text = "Welcome \(self.nameDB)!"
            self.totlPlanVl.text = " Total Plan Value: £\(self.totalPlanVlDB)"
            self.account1.text = "\(self.acc1)"
            self.planVlAc1.text = "Plan Value: £\(self.accPln1)"
            self.mnyboxAc1.text = "MoneyBox: £\(self.accMny1)"
        }
    
    }
    
    func constraints(){
        view.addSubview(Title)
        view.addSubview(welcomeLbl)
        view.addSubview(totlPlanVl)
        view.addSubview(logOutBtn)

        Title.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -105).isActive = true
        Title.centerYAnchor.constraint(equalTo: welcomeLbl.topAnchor, constant: -70).isActive = true
 
        welcomeLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -112).isActive = true
        welcomeLbl.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -220).isActive = true
        
        totlPlanVl.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100).isActive = true
        totlPlanVl.centerYAnchor.constraint(equalTo: welcomeLbl.bottomAnchor, constant: 34).isActive = true
        
        logOutBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 160).isActive = true
        logOutBtn.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        
        
        view.addSubview(account1)
        view.addSubview(planVlAc1)
        view.addSubview(mnyboxAc1)
        
        account1.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -80).isActive = true
        account1.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20).isActive = true
        
        planVlAc1.centerXAnchor.constraint(equalTo: account1.leftAnchor,constant: 65).isActive = true
        planVlAc1.centerYAnchor.constraint(equalTo: account1.bottomAnchor, constant: 20).isActive = true
       
        mnyboxAc1.centerXAnchor.constraint(equalTo: account1.leftAnchor,constant: 65).isActive = true
        mnyboxAc1.centerYAnchor.constraint(equalTo: planVlAc1.bottomAnchor, constant: 20).isActive = true
        
        
        view.addSubview(addMoney)
        
        addMoney.centerXAnchor.constraint(equalTo: account1.rightAnchor, constant: 90).isActive = true
        addMoney.centerYAnchor.constraint(equalTo: account1.centerYAnchor, constant: 25).isActive = true
        
    }
    
    // When user decides to add £10, add to value the rewrite in database
    @objc func AddValues(){
        
        
        accPln1 += 10
        totalPlanVlDB += 10
        totlPlanVl.text = " Total Plan Value: £\(self.totalPlanVlDB)"
        planVlAc1.text = "Plan Value: £\(self.accPln1)"
        
        
        let userDB = Database.database().reference().child("Users")
        let uid = Auth.auth().currentUser?.uid
        var  userDictionary : NSDictionary = ["account1PlanValue" : accPln1, "planValue" : totalPlanVlDB]
        
        userDB.child(uid!).updateChildValues(userDictionary as! [AnyHashable : Any]) {
            (error, ref) in
            if error != nil {
                print(error!)
            }
            else {
                print("User details saved successfully!")
            }
        }
        
        
        
        
    }
    
}
