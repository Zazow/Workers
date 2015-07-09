//
//  UIVC_WorkerSettingsPage.swift
//  Workers
//
//  Created by Abdulaziz Alghunaim on 7/5/15.
//  Copyright (c) 2015 ZazowPro. All rights reserved.
//

import UIKit
import Parse
import MobileCoreServices

class UIVC_WorkerSettingsPage: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var longPressOnImageOutlet: UILongPressGestureRecognizer!
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
        
        
        // set up our query for a User object
        let userQuery = PFUser.query();
        
        userQuery?.includeKey("workerExtraInfo");
        
        // execute the query
        userQuery?.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            // objects contains all of the User objects, and their associated Weapon objects, too
        }
        
        //get the worker type- returns WorkerExtraInfo Class
        var workerExtraInfo: PFObject = PFUser.currentUser()?.objectForKey("workerExtraInfo") as! PFObject
        workerExtraInfo = workerExtraInfo.fetchIfNeeded()!
        
        var workTypeArray = workerExtraInfo["workType"] as! NSArray
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
    
    @IBAction func longPressOnImage(sender: AnyObject) {
        
        userFullName.text = "test"
        
        var refreshAlert = UIAlertController(title: "Change Picture", message: "Choose", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Take a Picture", style: .Default, handler: { (action: UIAlertAction!) in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
            {
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
                imagePicker.mediaTypes = [kUTTypeImage as NSString]
                imagePicker.allowsEditing = true
                
                self.presentViewController(imagePicker, animated: true, completion: nil)
                
                //newMedia = true
            }
            else
            {
                let alertController = UIAlertController(title: "Camera", message:"No camera found :(", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }

        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Choose a Picture", style: .Default, handler: { (action: UIAlertAction!) in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum) {
                
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                imagePicker.mediaTypes = [kUTTypeImage as NSString]
                imagePicker.allowsEditing = true
                
                self.presentViewController(imagePicker, animated: true, completion: nil)
                
                //newMedia = false
            }
            
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)

    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
    {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        userImage.image = image
        
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
