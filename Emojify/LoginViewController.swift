//
//  LoginViewController.swift
//  Emojify
//
//  Created by Mordechai Levi on 1/23/15.
//  Copyright (c) 2015 Yoni Goldstein. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(sender: AnyObject) {
        
        var username = usernameField.text
        var password = passwordField.text
        
        if countElements(username) == 0 || countElements(password) == 0 {
            
            let controller = UIAlertController(title: "Oops.", message: "You gotta fill in both fields, silly! 😜", preferredStyle: UIAlertControllerStyle.Alert)
            
            let cancel = UIAlertAction(title: "Gotcha!", style: UIAlertActionStyle.Cancel, handler: nil)
            
            controller.addAction(cancel)
            
            presentViewController(controller, animated: true, completion: nil)
            
            
        }else{
            
            
            PFUser.logInWithUsernameInBackground(username, password: password, block: { (PFUser, error) -> Void in
                
                if (error != nil) {
                    let signInController = UIAlertController(title: "Snarf!", message: "Looks like the info's mixed up. Try again, I guess.", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    let cancelButton = UIAlertAction(title: "Gotcha!", style: UIAlertActionStyle.Cancel, handler: nil)
                    
                    signInController.addAction(cancelButton)
                    
                    self.presentViewController(signInController, animated: true, completion: nil)
                }else{
                    
                    self.navigationController?.popToRootViewControllerAnimated(true)
                    
                }

                
                
                
            })
            
            
        }

        
    }
    
    
    

}
