//
//  ImageViewController.swift
//  Emojify
//
//  Created by Mordechai Levi on 1/27/15.
//  Copyright (c) 2015 Yoni Goldstein. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {


    @IBOutlet weak var imageView: UIImageView!
    var message : PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //imageView = UIImageView()
        
        println(message)
        
        var imageFile = message.objectForKey("file") as PFFile?
        var imageFileURL = NSURL(string: imageFile!.url!)
        var imageData = NSData(contentsOfURL: imageFileURL!)
        
        imageView.image = UIImage(data: NSData(contentsOfURL: imageFileURL!)!)
        
        navigationItem.title = message.objectForKey("senderUsername") as String!
        
    }

   

}
