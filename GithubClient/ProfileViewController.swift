//
//  ProfileViewController.swift
//  GithubClient
//
//  Created by HoodsDream on 11/13/15.
//  Copyright © 2015 HoodsDream. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var repository:Repository?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var username: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.username.text = self.repository?.owner.ownerName
        
        if let name = self.repository?.name {
            print("the name is \(name)")
        }

        print("finnesed bein called")

        if let url = NSURL(string: (self.repository?.owner.ownerAvatarURL)!) {
            let downloadQ = dispatch_queue_create("downloadQ", nil)
            dispatch_async(downloadQ, { () -> Void in
                
                let imageData = NSData(contentsOfURL: url)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let image = UIImage(data: imageData!)
                    self.imageView.image = image
                    
                })
                
                
            })
        }

    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}






// download images with URL


//            if let url = NSURL(string: self.tweet.user!.profileImageURL) {
//                let downloadQ = dispatch_queue_create("downloadQ", nil)
//                dispatch_async(downloadQ, { () -> Void in
//                    let imageData = NSData(contentsOfURL: url)!
//
//                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                        let image = UIImage(data: imageData)
//                        self.imageButton.setBackgroundImage(image, forState: UIControlState.Normal)
//                    })
//
//                })
//
//            }
