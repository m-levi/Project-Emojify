//
//  CameraTableViewController.swift
//  Emojify
//
//  Created by Mordechai Levi on 1/25/15.
//  Copyright (c) 2015 Yoni Goldstein. All rights reserved.
//

import UIKit

class CameraTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var imagePicker : UIImagePickerController!
    var image : UIImage!

    var friendsRelation : PFRelation!
    var friends = []
    var recipients : NSMutableArray!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipients = NSMutableArray()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        if image == nil {
            
            generateImagePickerController()
            
        }
        
        //
        
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
        return friends.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        var user : PFUser = friends.objectAtIndex(indexPath.row) as PFUser
        
        cell.textLabel?.text = user.username
        
        if recipients.containsObject(user.objectId){
            
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            
        }else{
            
            cell.accessoryType = UITableViewCellAccessoryType.None
            
        }
        
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        var cell : UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        var user : PFUser = friends.objectAtIndex(indexPath.row) as PFUser
        
        if cell.accessoryType == UITableViewCellAccessoryType.None{
            
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            
            recipients.addObject(user.objectId)
            
        }else{
            
            cell.accessoryType = UITableViewCellAccessoryType.None
            
            recipients.removeObject(user.objectId)

        }
                
    }
    
    //MARK: Actions
    
    @IBAction func cancelDidPress(sender: AnyObject) {
        
        tabBarController?.selectedIndex = 0
        reset()
    }
    
    @IBAction func sendDidPress(sender: AnyObject) {
        
        if image == nil {
            
            let controller = UIAlertController(title: "Oopsie!", message: "You gotta take a photo silly! 😜", preferredStyle: UIAlertControllerStyle.Alert)
            
            let cancel = UIAlertAction(title: "Gotcha!", style: UIAlertActionStyle.Cancel, handler: nil)
            
            controller.addAction(cancel)
            
            presentViewController(controller, animated: true, completion: nil)
            presentViewController(imagePicker, animated: true, completion: nil)
            
        }else{
            
            uploadImage()
            tabBarController?.selectedIndex = 0
            
        }
        
        
    }
    
    //MARK: Helpers
    

    
    func uploadImage() {
        
        /*
        VARIABLES ⬇︎
        */
        var fileData = NSData()
        var fileName = String()
        var fileType = String()
        
        /*
        VARIABLES ⬆︎
        */
        
        
        //We want to shrink the image so we dont go crazy overboard with our Paser limits
        var newImage = resizeImage(forImage: image, toWidth: self.view.frame.width, andHeight: self.view.frame.height)
        
        fileData = UIImagePNGRepresentation(newImage)
        fileName = "image.png"
        fileType = "image"
            
            
        var file = PFFile(name: fileName, data: fileData, contentType: fileType)
        file.saveInBackgroundWithBlock { (succeded, error) -> Void in
            
            if error != nil {
                
                let controller = UIAlertController(title: "Uh-Oh!", message: "Something went super-duper worng. Please try again😜", preferredStyle: UIAlertControllerStyle.Alert)
                
                let cancel = UIAlertAction(title: "Gotcha!", style: UIAlertActionStyle.Cancel, handler: nil)
                
                controller.addAction(cancel)
                
                self.presentViewController(controller, animated: true, completion: nil)

                
            }else{
                
                var message : PFObject = PFObject(className: "Messages")
                message.setObject(file, forKey: "file")
                message.setObject(self.recipients, forKey: "recipientIDs")
                message.setObject(PFUser.currentUser().objectId, forKey: "senderID")
                message.setObject(PFUser.currentUser().username, forKey: "senderUsername")
                message.saveInBackgroundWithBlock({ (succeded, error) -> Void in
                    
                    if error != nil {
                        
                        let controller = UIAlertController(title: "Uh-Oh!", message: "Something went super-duper worng. Please try again😜", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        let cancel = UIAlertAction(title: "Gotcha!", style: UIAlertActionStyle.Cancel, handler: nil)
                        
                        controller.addAction(cancel)
                        
                        self.presentViewController(controller, animated: true, completion: nil)
                        
                        
                    }else{
                        
                        //Everything is awesome (Cue lego movie theme song)
                        self.reset()

                    }
                    
                    
                })
            }
            
            
        }
        
        
    }
    
    func resizeImage(forImage img : UIImage, toWidth width : CGFloat, andHeight height : CGFloat) -> UIImage {
        
        //new sizes for the image
        var newSize = CGSizeMake(width, height)
        var newRect = CGRectMake(0, 0, width, height)
        
        //Fancy shmancy image processing sauce
        UIGraphicsBeginImageContext(newSize)
        img.drawInRect(newRect)
        
        //Making that resized image into an actual image
        var resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
    
    func reset() {
        
        image = nil
        recipients.removeAllObjects()
    }
    
    func generateImagePickerController() {
        
        /**
        
        We want the camera to be loaded everytime somone comes to this view controller. ViewWillAppear is called everytime the somone comes to this view, viewdidload is only called when the view is first loaded. (LMK if you need more explanation)
        
        */
        
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            
        }else{
            
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        
        presentViewController(imagePicker, animated: false, completion: nil) //We don't want it animated bc the user will see it appear over the table view, which isnt seamles
        
        
    }

    
    //MARK: ImagePickerController Delegate
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        /**
        if the user cancels the image picker this will make them go back to the first tab bar item, the inbox.
        */
        
        dismissViewControllerAnimated(false, completion: nil)
        tabBarController?.selectedIndex = 0
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        image = info[UIImagePickerControllerOriginalImage] as UIImage!
        
        if imagePicker.sourceType == UIImagePickerControllerSourceType.Camera {
        
            //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil) //Saves photo to camera-roll
        
            //TODO: Change this to save emojified pic
            
        }
        
        /**
        
        Dismiss the camera bc we dont need that awesomeness anymore
        
        */
        
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
    
    
    
}
