//
//  ViewController.swift
//  SmChat
//
//  Created by Amr on 9/7/19.
//  Copyright © 2019 Amr. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController,UIGestureRecognizerDelegate {

    @IBOutlet weak var EmailTxtfield: UITextField!
    @IBOutlet weak var PassTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGest)
        
    }
    
  
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @IBAction func LoginBtn(_ sender: Any) {
        //if Email&Pass are Right then go to AppScreens
        guard let email = EmailTxtfield.text, let pass = PassTxtField.text else {return}
        if (email.isEmpty == true || pass.isEmpty == true){
            self.displayErrorMessage(thetitle: "Oooh, Smack Error", errorMess: "Empty Email Or Password")
        }else{
            Auth.auth().signIn(withEmail: email, password: pass) { (result, error) in
              if (error == nil){
                self.performSegue(withIdentifier: Home, sender: nil)
            }else{
                self.displayErrorMessage(thetitle: "Oooh, Smack Error", errorMess: "Wrong Email or Password, Try again")
            }
        }
      
        }
        
    }
    
    @IBAction func SignUpBtn(_ sender: Any) {
        performSegue(withIdentifier: To_SignUp, sender: nil)
    }

}
extension UIViewController{
    func displayErrorMessage(thetitle: String, errorMess: String){
        
        let alert = UIAlertController.init(title: thetitle, message: errorMess, preferredStyle: .alert)
        let dismissButton = UIAlertAction.init(title: "OK", style: .default, handler: nil)
        alert.addAction(dismissButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}
