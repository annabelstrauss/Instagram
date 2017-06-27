//
//  LoginViewController.swift
//  Instagram
//
//  Created by Annabel Strauss on 6/26/17.
//  Copyright © 2017 Annabel Strauss. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var emptyFieldAlert: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up the emptyFieldAlert
        emptyFieldAlert = UIAlertController(title: "Empty Field", message: "Fill in all text fields!", preferredStyle: .alert)
        // create a cancel action
        let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
            // handle cancel response here. Doing nothing will dismiss the view.
        }
        // add the cancel action to the alertController
        emptyFieldAlert.addAction(cancelAction)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPressSignIn(_ sender: Any) {
        
        //check to display error message if one of the field is empty
        if (usernameTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! {
            present(emptyFieldAlert, animated: true) { }
            return
        }
        
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
            if let error = error {
                print("User log in failed: \(error.localizedDescription)")
            } else {
                print("User logged in successfully")
                // display view controller that needs to shown after successful login
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
        
    }//close didPressSignIn
    
    @IBAction func didPressSignUp(_ sender: Any) {
        
        //check to display error message if one of the field is empty
        if (usernameTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! {
            present(emptyFieldAlert, animated: true) { }
            return
        }

        let newUser = PFUser()
        newUser.username = usernameTextField.text
        newUser.password = passwordTextField.text
        
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if success {
                print("Yay, created a user!")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                print(error?.localizedDescription)
            }
        }
    }//close didPressSignUp

}
