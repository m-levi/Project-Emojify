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
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    
        var query : PFQuery = PFUser.query()
        query.orderByAscending("username")
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error != nil {
                println("Error: \(error), \(error.userInfo)")
            }
            else{
                self.allUsers = objects
//                println(self.allUsers.count)
                self.tableView.reloadData()
//                println(self.allUsers)
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

        
    
        // Configure the cell...

        return cell
    }

//    - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//    {
//    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
//    
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    
//    PFRelation *friendsRelation = [self.currentUser relationforKey:@"friendsRelation"];
//    PFUser *user = [self.allUsers objectAtIndex:indexPath.row];
//    
//    if ([self isFriend:user]) {
//    cell.accessoryType = UITableViewCellAccessoryNone;
//    
//    for(PFUser *friend in self.friends) {
//    if ([friend.objectId isEqualToString:user.objectId]) {
//    [self.friends removeObject:friend];
//    break;
//    }
//    }
//    
//    [friendsRelation removeObject:user];
//    }
//    else {
//    cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    [self.friends addObject:user];
//    [friendsRelation addObject:user];
//    }
//    
//    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//    if (error) {
//    NSLog(@"Error: %@ %@", error, [error userInfo]);
//    }
//    }];
//    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        let cell : UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        var friendsRelation = currentUser.relationForKey("friendsRelation")
        var user : PFUser = allUsers.objectAtIndex(indexPath.row) as PFUser
        println(user)
        if isFriend(user) {
            cell.accessoryType = UITableViewCellAccessoryType.None

            for friend in self.friends {
             
                println("ID: \(user.objectId)")
                println("F: \(friend)")
                
                if friend.objectId == user.objectId {
                    
                    println("ID: \(user.objectId)")
                    println("F: \(friend)")
                    friends.removeObject(friend)
                    break
                }
            }
            
            friendsRelation.removeObject(user)
            
        }else{
            
            println(user)
            
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            friends.addObject(user)
            println(friends)
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
        
        var friend : PFUser!
        
        for friend in self.friends {
            
            if friend.objectId == user.objectId {
                return true
            }
        }
        
        return false
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
