//
//  UIVC_WorkerRequestsTable.swift
//  Workers
//
//  Created by Abdulaziz Alghunaim on 7/9/15.
//  Copyright (c) 2015 ZazowPro. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class UIVC_WorkerRequestsTable: PFQueryTableViewController {
    
    
    // Initialise the PFQueryTable tableview
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Configure the PFQueryTableView
        self.parseClassName = "JobRequest"
        self.textKey = "serviceType"
        self.imageKey = "image1"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
    }
    
    
    // Define the query that will provide the data for the table view
    override func queryForTable() -> PFQuery {
        var query = PFQuery(className: "JobRequest")
        query.orderByAscending("serviceType")
//        query.whereKey(“currencyCode”, equalTo:”EUR”)
        return query
    }
    
    
    //override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
        
        
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! PFTableViewCell!
        
        if cell == nil {
            cell = PFTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        }
        
        
        // Extract values from the PFObject to display in the table cell
        if let nameEnglish = object?.objectForKey("serviceType") as? String {
            cell?.textLabel?.text = nameEnglish
        }
        
        
        if let problem = object?.objectForKey("problemInfo") as? String! {
        
            cell?.detailTextLabel?.text = problem
        }
        
        if let type = object?.objectForKey("serviceType") as? Int! {
            
            cell?.textLabel?.text = String(type)
        }
        
        if let imageFile = object?.objectForKey("image1") as? PFFile! {
            
            imageFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        let image = UIImage(data:imageData)
                        
                        cell?.imageView?.image = image
                    }
                }
            }
            
        }
        
        
        return cell
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Get the new view controller using [segue destinationViewController].
        var detailScene = segue.destinationViewController as! UIVC_WorkerRequestDetail
        
        // Pass the selected object to the destination view controller.
        if let indexPath = self.tableView.indexPathForSelectedRow() {
            let row = Int(indexPath.row)
            detailScene.currentObject = (objects?[row] as! PFObject)
        }
    }
    
}
