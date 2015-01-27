//
//  InboxTableViewController.swift
//  Emojify
//
//  Created by Dov on 1/23/15.
//  Copyright (c) 2015 Yoni Goldstein. All rights reserved.
//

import UIKit

class InboxTableViewController: UITableViewController {

    var messages = []
    var selectedMessage : PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var currentUser = PFUser.currentUser()
        
        if (currentUser != nil) {
            
            println("Current User is: \(currentUser.username)")
            
        }else{
            
            performSegueWithIdentifier("showLogin", sender: self)

        }
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        var query = PFQuery(className: "messages")
        query.whereKey("recipientIDs", equalTo: PFUser.currentUser().objectId)
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            
            if error != nil {
                
                println("Error: \(error), \(error.userInfo)")
                
            }else{
                
                //We found a message!!
                
                self.messages = objects
                self.tableView.reloadData()
                
                println("we got \(self.messages.count) messages")
            }
            
            
        }
        
    }
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return messages.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        var message : PFObject = messages.objectAtIndex(indexPath.row) as PFObject

        cell.textLabel?.text = message.objectForKey("senderUsername") as String?
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectedMessage = messages.objectAtIndex(indexPath.row) as PFObject
        
        performSegueWithIdentifier("showImage", sender: self)
        
        
    }
    
    @IBAction func logOutButton(sender: AnyObject) {
        
        PFUser.logOut()
        performSegueWithIdentifier("showLogin", sender: self)

        
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showLogin" {
            
            let bottomBar = segue.destinationViewController as LoginViewController
            bottomBar.hidesBottomBarWhenPushed = true
            bottomBar.navigationItem.hidesBackButton = true
            
        }else if segue.identifier == "showImage" {
            
            let bottomBar = segue.destinationViewController as LoginViewController
            bottomBar.hidesBottomBarWhenPushed = true

            var imageVC : ImageViewController = segue.destinationViewController as ImageViewController
            imageVC.message = selectedMessage
            
        }
        
        
    }
    
}
