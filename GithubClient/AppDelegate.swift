//
//  AppDelegate.swift
//  GithubClient
//
//  Created by HoodsDream on 11/9/15.
//  Copyright © 2015 HoodsDream. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        
        return true
    }
    


    
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        
        
        OAuthClient.shared.tokenRequestWithCallback(url, options: SaveOptions.UserDefaults) { (success) -> () in
            if success {
                print("We have token.")
            }
        }
        
        return true
        
        
    }

        


}

