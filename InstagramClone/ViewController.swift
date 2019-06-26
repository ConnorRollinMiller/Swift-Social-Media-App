//
//  ViewController.swift
//  InstagramClone
//
//  Created by Connor Miller on 11/25/18.
//  Copyright © 2018 Connor Miller. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController, UITextFieldDelegate {
    
    var signupModeActive = true
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            
            self.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signupOrLoginBtn: UIButton!
    @IBOutlet weak var switchLoginModeLabel: UILabel!
    @IBOutlet weak var switchLoginModeBtn: UIButton!
    
    @IBAction func signupOrLogin(_ sender: Any) {
        
        if email.text == "" || password.text == "" {
            
            displayAlert(title: "Error In Form", message: "Please enter an email & password.")
            
        } else {
            
            self.view.endEditing(true)
            
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.style = UIActivityIndicatorView.Style.gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            if (signupModeActive) {
                
                let user = PFUser()
                
                user.username = email.text
                user.password = password.text
                user.email = email.text
                
                user.signUpInBackground { (success, error) in
                    
                    if let error = error {
                        
                        self.displayAlert(title: "Error With Sign Up", message: error.localizedDescription)
                        
                    } else {
                        
                        print("Signed up!")
                        
                        self.performSegue(withIdentifier: "showUserTable", sender: self)
                        
                    }
                    
                }
                
            } else {
                
                PFUser.logInWithUsername(inBackground: email.text!, password: password.text!, block: { (user, error) in
                    
                    if (user != nil) {
                        
                        print("Login successful!")
                        
                        self.performSegue(withIdentifier: "showUserTable", sender: self)
                        
                    } else {
                        
                        var errorText = "Unknown error: Please try again."
                        
                        if let error = error {
                            
                            errorText = error.localizedDescription
                            
                        }
                        
                        self.displayAlert(title: "Sign Up Failed", message: errorText)
                        
                    }
                    
                })
                
            }
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
        }
        
        
    }
    
    @IBAction func switchLoginMode(_ sender: Any) {
        
        if (signupModeActive) {
            
            signupModeActive = false
            signupOrLoginBtn.setTitle("Log In", for: [])
            switchLoginModeBtn.setTitle("Sign Up", for: [])
            switchLoginModeLabel.text = "New To Instagram?"
            
        } else {
            
            signupModeActive = true
            signupOrLoginBtn.setTitle("Sign Up", for: [])
            switchLoginModeBtn.setTitle("Log In", for: [])
            switchLoginModeLabel.text = "Already Have An Account?"
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if PFUser.current() != nil {
            
            self.performSegue(withIdentifier: "showUserTable", sender: self)
            
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.signupOrLogin(self)
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
}

