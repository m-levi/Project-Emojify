//
//  EditFriendsTableViewController.swift
//  Emojify
//
//  Created by Dov on 1/24/15.
//  Copyright (c) 2015 Yoni Goldstein. All rights reserved.
//

import UIKit

class EditFriendsTableViewController: UITableViewController {
    
    var friends : NSMutableArray!
    var allUsers : NSArray!
    var currentUser : PFUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allUsers = []
        friends = NSMutableArray()
        currentUser = PFUser.currentUser()
        
        var query : PFQuery = PFUser.query()
        query.orderByAscending("username")
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error != nil {
                println("Error: \(error), \(error.userInfo)")
            }
            else{
                self.allUsers = objects
                self.tableView.reloadData()
            }
        }
        
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        
        return allUsers.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        var user : PFUser = allUsers.objectAtIndex(indexPath.row) as PFUser
//        cell.textLabel.text = user.username
        cell.textLabel?.text = user.username
        
        if isFriend(user) {
            
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            
            println("yo")
            
        }else{
            
            println("yoYo")
            
            cell.accessoryType = UITableViewCellAccessoryType.None
            
        }
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        let cell : UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        var friendsRelation = currentUser.relationForKey("friendsRelation")
        var user : PFUser = allUsers.objectAtIndex(indexPath.row) as PFUser
        isFriend(user)
        if isFriend(user) == true{
            
            cell.accessoryType = UITableViewCellAccessoryType.None

            println("isFriend")
            
            for friend in self.friends {
                
                if friend.objectId == user.objectId {
                    

                    friends.removeObject(friend)
                    break
                }
            }
            
            friendsRelation.removeObject(user)
            
        }else{
            
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            friends.addObject(user)
            //println(friends)
            friendsRelation.addObject(user)
            
        }
        
        currentUser.saveInBackgroundWithBlock { (succeeded, error) -> Void in
            
            if error != nil {
                
                println("Error: \(error), \(error.userInfo)")
                
            }

        }
        
        
        
        
        
        /**
        I think the problem is with the user object. Everytime its not used the app works fine. But when the app is using it - it crashes. Welp :/.
        */
        

        
    }
    
    func isFriend (user : PFUser) -> Bool {
        
        //var friend : PFUser!
        
        for friend in self.friends {
    
            if friend.objectId == user.objectId {
                
                println("true")
                
                return true
            }
        }
        
        return false
    }
    
    
}
