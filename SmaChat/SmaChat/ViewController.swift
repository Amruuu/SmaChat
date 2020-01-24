//
//  ViewController.swift
//  SmChat
//
//  Created by Amr on 9/7/19.
//  Copyright © 2019 Amr. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func LoginBtn(_ sender: Any) {
        //if username&pass are Right then go to AppScreens
        performSegue(withIdentifier: Home, sender: nil)
    }
    
    @IBAction func SignUpBtn(_ sender: Any) {
        performSegue(withIdentifier: To_SignUp, sender: nil)    }
}

