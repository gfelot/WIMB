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
    
    var loginOrSignUp = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if PFUser.currentUser()?.username != nil {
            self.performSegueWithIdentifier("login", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func connectAction(sender: AnyObject) {
        guard username.text != "" && password.text != "" else {
            alertPopUp("Error in Form", message: "Please enter a username AND a password")
            return
        }
        waitingIndicator()
        if loginOrSignUp == true {
            tryToSignUp()
        } else {
            tryToLogin()
        }

    }

    
    @IBAction func changeStateAction(sender: AnyObject) {
        if loginOrSignUp == true {
            connectButton.setTitle("SignUp", forState: .Normal)
            signUpTextField.text = "Already an account ?"
            changeStateButton.setTitle("Login", forState: .Normal)
            loginOrSignUp = false
        } else {
            connectButton.setTitle("Login", forState: .Normal)
            signUpTextField.text = "Wanna SignUp ?"
            changeStateButton.setTitle("SignUp", forState: .Normal)
            loginOrSignUp = true
        }
    }

    
    @IBAction func FBLogin(sender: AnyObject) {
        alertPopUp("Not Implemented Yet !!!", message: "But I'm gonna do it soon I promise.")
    }
    
    func tryToSignUp() {
        var errorMessage = "Please try again later"
        let user = PFUser()
        user.username = username.text
        user.password = password.text
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
    
    func tryToLogin() {
        var errorMessage = "Please try again later"
        PFUser.logInWithUsernameInBackground(username.text!, password: password.text!) { (user, error) -> Void in
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
