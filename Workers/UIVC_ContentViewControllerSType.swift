//
//  UICV_ContentViewControllerSType.swift
//  Workers
//
//  Created by Ziyad Alghoneim on 7/4/15.
//  Copyright (c) 2015 ZazowPro. All rights reserved.
//

import UIKit

class UIVC_ContentViewControllerSType: UIViewController {

    @IBOutlet weak var STypeLabel: UILabel!
    @IBOutlet weak var STypeImage: UIImageView!
    
    var pageIndex: Int!
    var titleText: String!
    var imageFile: String!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.STypeImage.image = UIImage(named: imageFile)
        self.STypeLabel.text = self.titleText

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
