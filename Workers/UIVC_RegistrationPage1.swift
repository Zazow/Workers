//
//  UIVC_RegistrationPage1.swift
//  Workers
//
//  Created by Ziyad Alghoneim on 7/3/15.
//  Copyright (c) 2015 ZazowPro. All rights reserved.
//

import UIKit
import Parse

class UIVC_RegistrationPage1: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var emailAdress: UITextField!
    @IBOutlet weak var regType: UISegmentedControl!
    @IBOutlet weak var passwordConfirmation: UITextField!

    var user = PFUser()

    @IBAction func signUp(sender: AnyObject) {
        
        // Build the terms and conditions alert
        let alertController = UIAlertController(title: "Agree to terms and conditions",
            message: "Click I AGREE to signal that you agree to the End User Licence Agreement.",
            preferredStyle: UIAlertControllerStyle.Alert
        )
        alertController.addAction(UIAlertAction(title: "I AGREE",
            style: UIAlertActionStyle.Default,
            handler: { alertController in self.processSignUp()})
        )
        alertController.addAction(UIAlertAction(title: "I do NOT agree",
            style: UIAlertActionStyle.Default,
            handler: nil)
        )
        
        // Display alert
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func processSignUp() {
        
        var userPhoneNumber = phoneNumber.text
        var userFirstName = firstName.text
        var userLastName = lastName.text
        var userEmailAddress = emailAdress.text
        var userPassword = password.text
        var userPasswordConfirmation = passwordConfirmation.text
        var userTypeArray: [String] = ["Worker", "Seeker"]
        var userType = userTypeArray[regType.selectedSegmentIndex]
        
        //check that the password is valid
        var passIsGood = false
        if ((userPassword == userPasswordConfirmation) && (userPassword != "")){
            passIsGood = true
        }else{
            self.message.text = "passwords don't match or you left them empty"
        }
        
        
        //if the user is a seeker, sign him up
        if (passIsGood){
            // Ensure email is lowercase
            userEmailAddress = userEmailAddress.lowercaseString
            
            // Add email address validation
            
            // Start activity indicator
            activityIndicator.hidden = false
            activityIndicator.startAnimating()
            
            // Create the user
            user.username = userPhoneNumber
            user.password = userPassword
            user.email = userEmailAddress
            user["firstName"] = userFirstName
            user["lastName"] = userLastName
            user["userType"] = userType
            
            
            if (userType == "Seeker") {
                user.signUpInBackgroundWithBlock {
                    (succeeded: Bool, error: NSError?) -> Void in
                    if error == nil {
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            self.performSegueWithIdentifier("RegSuccessful", sender: self)
                        }
                        
                    } else {
                        
                        self.activityIndicator.stopAnimating()
                        
                        if let message: AnyObject = error!.userInfo!["error"] {
                            self.message.text = "\(message)"
                        }
                    }
                }
            }else{//user is a worker.. move him to the next page
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.performSegueWithIdentifier("workerRegPage", sender: self)
                }
                
            }
        }else{//the password is not ok. Don't do anything
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
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "workerRegPage"
        {
            if let destinationVC = segue.destinationViewController as? UIVC_RegistrationPage2{
                destinationVC.user = user
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
