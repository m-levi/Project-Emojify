//
//  InboxTableViewController.swift
//  Emojify
//
//  Created by Dov on 1/23/15.
//  Copyright (c) 2015 Yoni Goldstein. All rights reserved.
//

import UIKit

class InboxTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var currentUser = PFUser.currentUser()
        
        if (currentUser != nil) {
            
            println("Current User is: \(currentUser.username)")
            
        }else{
            
            performSegueWithIdentifier("showLogin", sender: self)

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
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 0
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
            
        }
        
    }
    
}
