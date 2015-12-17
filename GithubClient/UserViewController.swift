//
//  UserViewController.swift
//  GithubClient
//
//  Created by HoodsDream on 11/15/15.
//  Copyright © 2015 HoodsDream. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
    
    
    var user:User?
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.usernameLabel.text = self.user?.name
        
        let urlz = self.user?.avatarURL
        if let url = NSURL(string: urlz!) {
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
