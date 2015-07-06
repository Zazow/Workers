//
//  UIVC_WorkerSettingsPage.swift
//  Workers
//
//  Created by Abdulaziz Alghunaim on 7/5/15.
//  Copyright (c) 2015 ZazowPro. All rights reserved.
//

import UIKit
import Parse

class UIVC_WorkerSettingsPage: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userFullName: UILabel!
    @IBOutlet weak var userPhoneNumber: UILabel!
    @IBOutlet weak var userWorkType: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.processViewUserInfo()
    }
    
    func processViewUserInfo(){
        let user = PFUser.currentUser()
        
        var firstName: NSString = user!.objectForKey("firstName") as! NSString
        var lastName: NSString = user!.objectForKey("lastName") as! NSString
        var fullName = "\(firstName) \(lastName)"
        
        
        //get the worker type- returns WorkerExtraInfo Class
        let workerExtraInfo: PFObject = user?.objectForKey("workerExtraInfo") as! PFObject
        
        var workTypeArray = workerExtraInfo.objectForKey("workType") as! NSArray
        var workType = workTypeArray[0] as! String //grab the first job
        
        
        
        
        userPhoneNumber.text = user?.username
        userFullName.text = fullName
        userWorkType.text = workType
        

        
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signOut(sender: AnyObject) {
        
        PFUser.logOut()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("VIewController") as! UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
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
