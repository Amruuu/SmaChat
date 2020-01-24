//
//  pop up.swift
//  SmaChat
//
//  Created by Amr on 9/10/19.
//  Copyright © 2019 Amr. All rights reserved.
//

import Foundation

class pop:UIAlert
//The pop up Function
func displayErrorMessage(errorMess: String){
    let alert = UIAlertController.init(title: "Oooh, Smack Error", message: errorMess, preferredStyle: .alert)
    let dismissButton = UIAlertAction.init(title: "OK", style: .default, handler: nil)
    alert.addAction(dismissButton)
    self.present(alert, animated: true, completion: nil)
    
}
