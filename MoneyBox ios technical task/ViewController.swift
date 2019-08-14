//
//  ViewController.swift
//  MoneyBox ios technical task
//
//  Created by Rehan Khan on 13/08/2019.
//  Copyright © 2019 Rehan. All rights reserved.
//

import UIKit
import Foundation
import Firebase

// declare colour
let red = UIColor(r: 208, g: 81, b: 81)

class ViewController: UIViewController {
    // hides nav bar on load
    override func viewDidAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    // Label
    let logInLbl: UILabel = {
        let lb = UILabel()
        lb.text = "Log in"
        lb.textColor = .black
        lb.textAlignment = .center
        lb.font = UIFont(name: "Arial", size: 30)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()

    // segmented Control
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = red
        sc.selectedSegmentIndex = 1
        sc.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Arial", size: 15.0)!],
                                  for: UIControl.State())
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    
        @objc func handleLoginRegisterChange(){
            if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
                loginRegisterButton.setTitle("Login", for: UIControl.State())
                nameTxt.isHidden = true
                ResetPasswordbtn.isHidden = false
            } else {
                loginRegisterButton.setTitle("Register", for: UIControl.State())
                nameTxt.isHidden = false
                ResetPasswordbtn.isHidden = true
            }
            
        }
    
    // Textbox creation function
    func createTextbox()-> UITextField {
        let widthAnchor = CGFloat(360)
        let heightAnchor = CGFloat(50)
        
        let tf = UITextField()
        tf.placeholder = "test"
        tf.textAlignment = .left
        tf.widthAnchor.constraint(equalToConstant: widthAnchor).isActive = true
        tf.heightAnchor.constraint(equalToConstant: heightAnchor).isActive = true
        // Create a padding view for padding on left
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 55, height: tf.frame.height))
        tf.leftViewMode = .always
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.spellCheckingType = .no
        tf.layer.cornerRadius = 15
        tf.clearButtonMode = .whileEditing
        tf.backgroundColor = .white
        tf.font = UIFont(name: "Arial", size: 17)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }
    
        // decleration
        lazy var emailTxt = createTextbox()
        lazy var passwordTxt = createTextbox()
        lazy var nameTxt = createTextbox()
    
    // Button
    lazy var loginRegisterButton: UIButton = {
        let widthAnchor = CGFloat(300)
        let heightAnchor = CGFloat(50)
        let button = UIButton(type: .system)
        button.backgroundColor = red
        button.setTitle("Register", for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        button.widthAnchor.constraint(equalToConstant: widthAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: heightAnchor).isActive = true
        return button
    }()
    
    
        @objc func handleLoginRegister() {
            if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
                handleSignIn()
                
            } else {
                createAccountAction()
                
            }
        }
    
            @objc func handleSignIn() {
       
                    if self.emailTxt.text == "" || self.passwordTxt.text == "" {
                        
                        // Error handling
                        
                        let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
                        
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                        
                    } else {
                        
                      // check to see if the credentials are correct
                        Auth.auth().signIn(withEmail: self.emailTxt.text!, password: self.passwordTxt.text!) { (user, error) in
                            
                            if error == nil {
                                
                                //Print into the console if successfully logged in
                                print("You have successfully logged in")
                            
                                let vc = Home()
                                self.navigationController?.pushViewController(vc, animated: true)
                                
                            } else {
                                
                                //Tells the user that there is an error and then gets firebase to tell them the error
                                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                                
                                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                alertController.addAction(defaultAction)
                                
                                self.present(alertController, animated: true, completion: nil)
                            }
                        }
                    }
                }
    
            func createAccountAction() {

                
               if self.emailTxt.text == "" || self.passwordTxt.text == "" {
                    let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                } else {
                
                // create user
                    Auth.auth().createUser(withEmail: emailTxt.text ?? "", password: self.passwordTxt.text ?? "") { (result, error) in
                       
                 // display alert to notify sucessful user account creation
                        let alertController = UIAlertController(title: "Account Sucessfully Created", message: "Your account has been sucessfully created", preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                       
                        // Add user to database
                        let userDB = Database.database().reference().child("Users")
                         let uid = Auth.auth().currentUser?.uid
                        var  userDictionary : NSDictionary = ["name" : self.nameTxt.text, "email" : self.emailTxt.text]
                        
                        userDB.child(uid!).setValue(userDictionary) {
                            (error, ref) in
                            if error != nil {
                                print(error!)
                            }
                            else {
                                print("User details saved successfully!")
                            }
                        }
                   // clear textboxes
                        self.emailTxt.text = ""
                        self.passwordTxt.text = ""
                        self.nameTxt.text = ""
                        
                        if error != nil {
                            // display error if there is one
                            let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alertController.addAction(defaultAction)
                            self.present(alertController, animated: true, completion: nil)
                            return
                        }
                        guard let user = result?.user else { return }
                        
                    }
                }
            }
    

    lazy var ResetPasswordbtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reset Password", for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(ResetPassword), for: .touchUpInside)
        
        return button
    }()
    
    // Reset password Button function
        @objc func ResetPassword(){
            
            // error validation
            if emailTxt.text == "" {
                let alertController = UIAlertController(title: "Oops!", message: "Please enter an email.", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                present(alertController, animated: true, completion: nil)
                
            } else {
                
                // send password reset
                Auth.auth().sendPasswordReset(withEmail: emailTxt.text!, completion: { (error) in
                    
                    var title = ""
                    var message = ""
                    
                    if error != nil {
                        title = "Error!"
                        message = (error?.localizedDescription)!
                    } else {
                        title = "Success!"
                        message = "Password reset email sent."
                        self.emailTxt.text = ""
                        
                    }
                    
                    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                })
            }
        }

   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        // add to view
        view.addSubview(logInLbl)
        view.addSubview(loginRegisterSegmentedControl)
        view.addSubview(emailTxt)
        view.addSubview(ResetPasswordbtn)
        view.addSubview(passwordTxt)
        view.addSubview(nameTxt)
        view.addSubview(loginRegisterButton)
        
        ResetPasswordbtn.isHidden = true
        constriants()
        
    }

    func constriants() {
        
      // set spacing constraint
      let spacing = CGFloat(40)
        
       // Login Title constriant
        logInLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logInLbl.centerYAnchor.constraint(equalTo: emailTxt.topAnchor, constant: -130).isActive = true
        
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.centerYAnchor.constraint(equalTo: emailTxt.topAnchor, constant: -50).isActive = true
        
         // email textbox constriant
        emailTxt.placeholder = "Email"
        emailTxt.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailTxt.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60).isActive = true

        ResetPasswordbtn.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100).isActive = true
        ResetPasswordbtn.centerYAnchor.constraint(equalTo: passwordTxt.topAnchor, constant: -13).isActive = true
        
        // password textbox constriant
        passwordTxt.placeholder = "Password"
        passwordTxt.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordTxt.centerYAnchor.constraint(equalTo: emailTxt.bottomAnchor, constant: 55).isActive = true
        passwordTxt.isSecureTextEntry = true
        
         // name textbox constriant
        nameTxt.placeholder = "Name (optional)"
        nameTxt.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameTxt.centerYAnchor.constraint(equalTo: passwordTxt.bottomAnchor, constant: spacing).isActive = true
        
        // login button constriant
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80).isActive = true

    }

}

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
}
