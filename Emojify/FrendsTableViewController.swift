//
//  FrendsTableViewController.swift
//  Emojify
//
//  Created by Mordechai Levi on 1/26/15.
//  Copyright (c) 2015 Yoni Goldstein. All rights reserved.
//

import UIKit

class FrendsTableViewController: UITableViewController {

    var friendsRelation : PFRelation!
    var friends = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        friendsRelation = PFUser.currentUser().relationForKey("friendsRelation")
        var query : PFQuery = friendsRelation.query()
        query.orderByAscending("username")
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            
            if error != nil {
                
                println("Error: \(error), \(error.userInfo)")
                
            }else{
                
                self.friends = objects
                self.tableView.reloadData()
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
        return friends.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        var user : PFUser = friends.objectAtIndex(indexPath.row) as PFUser
        
        cell.textLabel?.text = user.username

        return cell
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showEditFriends" {
            
            var vc : EditFriendsTableViewController = segue.destinationViewController as EditFriendsTableViewController
            vc.friends = NSMutableArray(array: friends)
            
            println("going")
            
        }
        
    }

}
