//
//  UIVC_RegistrationPage2.swift
//  Workers
//
//  Created by Ziyad Alghoneim on 7/3/15.
//  Copyright (c) 2015 ZazowPro. All rights reserved.
//

import UIKit
import Parse

class UIVC_RegistrationPage2: UIViewController {

    var user:PFUser!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var workType: UITextField!
    @IBOutlet weak var languages: UITextField!
    @IBOutlet weak var idNumber: UITextField!
    
    
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
        
        var userWorkTypeArray: [String] = [workType.text]
        var userWorkLanguageArray: [String] = [languages.text]
        var userIdNumber = idNumber.text
        
        
        // Start activity indicator
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
            
        // Create the user
        var workerInfo = PFObject(className: "WorkerExtraInfo")
        workerInfo["workType"] = userWorkTypeArray
        workerInfo["languages"] = userWorkLanguageArray
        workerInfo["idNumber"] = userIdNumber
        
        
        user.setObject(workerInfo, forKey: "workerExtraInfo")
            
            user.signUpInBackgroundWithBlock {
                (succeeded: Bool, error: NSError?) -> Void in
                if error == nil {
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.performSegueWithIdentifier("workerSignedUp", sender: self)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
