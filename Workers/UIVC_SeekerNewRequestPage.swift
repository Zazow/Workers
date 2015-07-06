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

class UIVC_SeekerNewRequestPage: UIViewController, UIPageViewControllerDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    //Vars
    
    var pageViewController: UIPageViewController!
    var pageTitles: NSArray!
    var pageImages: NSArray!
    
    var newMedia: Bool?
    
    var imageInputCount: Int = 0

    
    
    //Outlets
    
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    
    @IBOutlet weak var userTextInput: UITextView!
    
    @IBOutlet weak var newRequestMap: MKMapView!
    
    @IBOutlet var longPressOnMapOultet: UILongPressGestureRecognizer!

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
        let touchMapCoordinate: CLLocationCoordinate2D = newRequestMap.convertPoint(tapPoint, toCoordinateFromView: newRequestMap)
        
        var dropPin = MKPointAnnotation()
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
   
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
    {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        var imageViewArray = [imageView1, imageView2, imageView3]
        
        imageViewArray[imageInputCount].image = image
        
                imageInputCount++

    }
    
    
    // Page View Controller Functions:
    
    func pageViewControllerViewDidLoad()
    {
        self.pageTitles = NSArray(objects: "Electrician", "Plumber", "Other")
        self.pageImages = NSArray(objects: "Electrician.png", "", "")
        
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
        
        var vc: UIVC_ContentViewControllerSType = self.storyboard?.instantiateViewControllerWithIdentifier("ContentViewControllerSType") as! UIVC_ContentViewControllerSType
        
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
