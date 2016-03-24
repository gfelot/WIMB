//
//  LoginViewController.swift
//  WIMB
//
//  Created by Gil Felot on 05/01/16.
//  Copyright © 2016 gfelot. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var signUpTextField: UILabel!
    @IBOutlet weak var changeStateButton: UIButton!

    
    var activityIndicator = UIActivityIndicatorView()
    
    var loginStatut = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username.delegate = self
        password.delegate = self
        

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        var nav = self.navigationController?.navigationBar
//        nav?.barStyle = UIBarStyle.Black
//        nav?.tintColor = UIColor.whiteColor()
        
        let me = PFUser.currentUser()
        
        if me!.username != nil {
            username.text = me!.username
        } else {
            connectButton.setTitle("SignUp", forState: .Normal)
            signUpTextField.text = "Already an account ?"
            changeStateButton.setTitle("Login", forState: .Normal)
            loginStatut = false
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // Don't forget to unsubscribe to KB notification
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }


    @IBAction func connectAction(sender: AnyObject) {
        guard username.text != "" && password.text != "" else {
            alertPopUp("Error in Form", message: "Please enter a username AND a password")
            return
        }
        waitingIndicator()
        if loginStatut == true {
            tryToLogin(username.text!, _password: password.text!)
        } else {
            tryToSignUp(username.text!, _password: password.text)
        }

    }

    @IBAction func changeStateAction(sender: AnyObject) {
        if loginStatut == true {
            connectButton.setTitle("SignUp", forState: .Normal)
            signUpTextField.text = "Already an account ?"
            changeStateButton.setTitle("Login", forState: .Normal)
            loginStatut = false
        } else {
            connectButton.setTitle("Login", forState: .Normal)
            signUpTextField.text = "Wanna SignUp ?"
            changeStateButton.setTitle("SignUp", forState: .Normal)
            loginStatut = true
        }
    }

    
    @IBAction func FBLogin(sender: AnyObject) {
        alertPopUp("Not Implemented Yet !!!", message: "But I'm gonna do it soon I promise.")
    }
    
    func tryToSignUp(_username: String!, _password: String!) {
        var errorMessage = "Please try again later"
        let user = PFUser()
        user.username = _username
        user.password = _password
        user.signUpInBackgroundWithBlock { (success, error) -> Void in
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            guard error == nil else {
                if let errorString = error!.userInfo["error"] as? String {
                    errorMessage = errorString
                }
                self.alertPopUp("Failed Sign Up", message: errorMessage)
                return
            }
            self.performSegueWithIdentifier("login", sender: self)
        }
    }
    
    func tryToLogin(_username: String!, _password: String!) {
        var errorMessage = "Please try again later"
        PFUser.logInWithUsernameInBackground(_username, password: _password) { (user, error) -> Void in
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            guard user != nil else {
                if let errorString = error!.userInfo["error"] as? String {
                    errorMessage = errorString
                }
                self.alertPopUp("Failed Login", message: errorMessage)
                return
            }
            self.performSegueWithIdentifier("login", sender: self)
        }
    }
    
    func waitingIndicator() {
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
    }
    
    func alertPopUp(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}
