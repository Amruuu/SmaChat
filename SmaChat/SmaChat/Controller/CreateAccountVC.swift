//
//  CreateAccountVC.swift
//  SmChat
//
//  Created by Amr on 9/7/19.
//  Copyright © 2019 Amr. All rights reserved.
//

import UIKit
import Firebase

class CreateAccountVC: UIViewController {

    @IBOutlet weak var UsernameTxtField: UITextField!
    @IBOutlet weak var EmailTxtField: UITextField!
    @IBOutlet weak var PassTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //to dismiss the keyboard after and before typing...
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(dismisskeyboard))
        view.addGestureRecognizer(tapGest)
    }
    @objc func dismisskeyboard(){
        view.endEditing(true)
    }
    

    @IBAction func CancelBtn(_ sender: Any) {
        performSegue(withIdentifier: To_Login, sender: nil)
    }
    
    @IBAction func CreateAccountBtn(_ sender: Any) {
        guard let email = EmailTxtField.text, let pass = PassTxtField.text else {return}
        if (email.isEmpty == true || pass.isEmpty == true || UsernameTxtField.text?.isEmpty == true){
            self.displayErrorMessage(thetitle: "Oooh, Smack Error",errorMess: "Empty Email, Password Or UserName")
        }else{
            Auth.auth().createUser(withEmail: email, password: pass) { (result, error) in
                if (error == nil){
                    guard let userID = result?.user.uid, let userName = self.UsernameTxtField.text else {return}
                    let reference = Database.database().reference()
                    let user = reference.child("users").child(userID)
                    let ArrayOfUserData: [String: Any] = ["username": userName]
                    user.setValue(ArrayOfUserData)
                    self.performSegue(withIdentifier: Home, sender: nil)
                }else{
                    self.displayErrorMessage(thetitle: "Oooh, Smack Error",errorMess: "Wrong Email or Password, Try again")
                }
            }        }
      }
    
  

}
