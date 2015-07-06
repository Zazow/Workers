//
//  ViewController.swift
//  Workers
//
//  Created by Ziyad Alghoneim on 7/3/15.
//  Copyright (c) 2015 ZazowPro. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var password: UITextField!
    

    
    //Funsction for users to sign in
    @IBAction func signIn(sender: AnyObject) {
        
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        var userPhoneNumber = phoneNumber.text
        
        var userPassword = password.text
        
        PFUser.logInWithUsernameInBackground(userPhoneNumber, password:userPassword) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                var userType = user?.objectForKey("userType") as! String
                //check if user is worker or seeker
                if (userType == "Seeker"){
                    dispatch_async(dispatch_get_main_queue()) {
                        self.performSegueWithIdentifier("signInMainView", sender: self)
                    }
                }else if (userType == "Worker"){//job type is worker
                    dispatch_async(dispatch_get_main_queue()) {
                        self.performSegueWithIdentifier("workerLogInPage", sender: self)
                    }
                }else{
                    self.message.text = "problem with detecting type of user"
                }
            } else {
                self.activityIndicator.stopAnimating()
                
                if let message: AnyObject = error!.userInfo!["error"] {
                    self.message.text = "\(message)"
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.hidden = true
        activityIndicator.hidesWhenStopped = true
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

// Test Git
}

