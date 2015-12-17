//
//  ViewController.swift
//  GithubClient
//
//  Created by HoodsDream on 11/9/15.
//  Copyright © 2015 HoodsDream. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
        do {
            
            let token = try OAuthClient.shared.accessToken()
            
            if token.characters.count <= 0 {
                print("something wrong with token")
            } else {
                print(token)
                self.performSegueWithIdentifier("secondView", sender: self)
            }
            
        } catch {return}
        
        
    }
    
    
    
    @IBAction func loginPressed(sender: AnyObject) {

        OAuthClient.shared.oauthRequestWithParameters(["scope" : "email,user,repo"])
        
    }
    
    
    @IBAction func printTokenPressed(sender: AnyObject) {

        do {
            
            let token = try OAuthClient.shared.accessToken()
            
            print(token)
            
        } catch let error {
            
            print(error)
            
        }
        
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

