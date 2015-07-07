//
//  UIVC_SeekerNewRequestPage.swift
//  Workers
//
//  Created by Ziyad Alghoneim on 7/4/15.
//  Copyright (c) 2015 ZazowPro. All rights reserved.
//

import UIKit
import MobileCoreServices
import MapKit
import CoreLocation
import Parse

class UIVC_SeekerNewRequestPage: UIViewController, UIPageViewControllerDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    //Vars
    
    var pageViewController: UIPageViewController!
    var pageTitles: NSArray!
    var pageImages: NSArray!
    var vc: UIVC_ContentViewControllerSType!
    
    var newMedia: Bool?
    var imageViewArray: [UIImageView]!
    var imageInputCount: Int = 0

    var dropPin = MKPointAnnotation()
    var touchMapCoordinate: CLLocationCoordinate2D!
    
    //Outlets
    
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    
    @IBOutlet weak var userTextInput: UITextView!
    
    @IBOutlet weak var newRequestMap: MKMapView!
    
    @IBOutlet var longPressOnMapOultet: UILongPressGestureRecognizer!

    @IBOutlet weak var Buttontest: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Call Page View Controller
        self.pageViewControllerViewDidLoad()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func longPressOnMap(sender: AnyObject) {
        
       
        let tapPoint: CGPoint = longPressOnMapOultet.locationInView(newRequestMap)
        
        touchMapCoordinate = newRequestMap.convertPoint(tapPoint, toCoordinateFromView: newRequestMap)
        
        newRequestMap.removeAnnotation(dropPin)
        dropPin.coordinate = touchMapCoordinate
        dropPin.title = "Chosen Location"
        dropPin.subtitle = ":P"
        newRequestMap.addAnnotation(dropPin)
    }
    
    @IBAction func useCamera(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        {
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker.mediaTypes = [kUTTypeImage as NSString]
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
            
            newMedia = true
        }
        else
        {
            let alertController = UIAlertController(title: "Camera", message:"No camera found :(", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func useCameraRoll(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum) {
            
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                imagePicker.mediaTypes = [kUTTypeImage as NSString]
                imagePicker.allowsEditing = false
            
                self.presentViewController(imagePicker, animated: true, completion: nil)
            
                newMedia = false
        }
    }
    
    @IBAction func submitButton(sender: AnyObject) {
        
        var noErrors: Bool = true
        
        let geopoint = PFGeoPoint(latitude: touchMapCoordinate.latitude, longitude: touchMapCoordinate.longitude)
        
        var jobRequest = PFObject(className: "JobRequest")
        
        //Problem info
        if userTextInput != nil{
            jobRequest["problemInfo"] = userTextInput.text}
        else{
            noErrors = false
            
            let alertController = UIAlertController(title: "Error", message: "You must fill the text field", preferredStyle:UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        
        jobRequest["serviceType"] = vc.pageIndex
        jobRequest["location"] = geopoint
        jobRequest["user"] = PFUser.currentUser()
        
        if imageView1.image != nil{
        var imageData = UIImagePNGRepresentation(self.imageView1.image)
        var parseImageFile = PFFile(name: "image1.png", data: imageData)
        jobRequest["image1"] = parseImageFile
        }
        else
        {
            noErrors = false
            
            let alertController = UIAlertController(title: "Error", message: "You must upload at least one image", preferredStyle:UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        if imageView2.image != nil{
        var imageData = UIImagePNGRepresentation(self.imageView2.image)
        var parseImageFile = PFFile(name: "image2.png", data: imageData)
        jobRequest["image2"] = parseImageFile
        }
        
        if imageView3.image != nil{
        var imageData = UIImagePNGRepresentation(self.imageView3.image)
        var parseImageFile = PFFile(name: "image3.png", data: imageData)
        jobRequest["image3"] = parseImageFile
        }
        
        if noErrors == true
        {
            jobRequest.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    // The object has been saved.
                    let alertController = UIAlertController(title: "Success!", message: "Youre request has been sent", preferredStyle:UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                
                } else {
                    // There was a problem, check error.description
                    let alertController = UIAlertController(title: "Error", message: error?.description, preferredStyle:UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func clearButton(sender: AnyObject) {
        Buttontest.setTitle(String(vc.pageIndex), forState: .Normal)
    }
   
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
    {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        imageViewArray = [imageView1, imageView2, imageView3]
        
        imageViewArray[imageInputCount].image = image
        
                imageInputCount++

    }
    
    
    // Page View Controller Functions:
    
    func pageViewControllerViewDidLoad()
    {
        self.pageTitles = NSArray(objects: "Electrician", "Plumber", "Mover", "Painter", "Constructer", "Carpenter", "Other")
        self.pageImages = NSArray(objects: "Electrician.png", "Plumber.png", "", "", "", "" ,"")
        
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewControllerSType") as! UIPageViewController
        
        self.pageViewController.dataSource = self
        
        var startVC = self.viewControllerAtIndex(0) as UIVC_ContentViewControllerSType
        var viewControllers = NSArray(object: startVC)
        
        self.pageViewController.setViewControllers(viewControllers as [AnyObject], direction: .Forward, animated: true, completion: nil)
        
        self.pageViewController.view.frame = CGRectMake(0, 20, 400, 100)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
    }
    
    func viewControllerAtIndex(index: Int) -> UIVC_ContentViewControllerSType
    {
        if ((self.pageTitles.count == 0) || (index >= self.pageTitles.count))
        {
            return UIVC_ContentViewControllerSType()
        }
        
        vc = self.storyboard?.instantiateViewControllerWithIdentifier("ContentViewControllerSType") as! UIVC_ContentViewControllerSType
        
        vc.imageFile = self.pageImages[index] as! String
        vc.titleText = self.pageTitles[index] as! String
        vc.pageIndex = index
        
        return vc
    }
    
    // MARK:- Page View Controller Data Source
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        var vc = viewController as! UIVC_ContentViewControllerSType
        var index = vc.pageIndex as Int
        
        if (index == 0 || index == NSNotFound)
        {
            return nil
        }
        
        index--
        
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        var vc = viewController as! UIVC_ContentViewControllerSType
        var index = vc.pageIndex as Int
        
        if (index == NSNotFound)
        {
            return nil
        }
        
        index++
        
        if (index == self.pageTitles.count)
        {
            return nil
        }
        
        return self.viewControllerAtIndex(index)
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.pageTitles.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
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
