//
//  OAuthClient.swift
//  GithubClient
//
//  Created by HoodsDream on 11/9/15.
//  Copyright © 2015 HoodsDream. All rights reserved.
//

import Foundation
import UIKit

let kOAuthBaseURLString = "https://github.com/login/oauth/"
let kAccessTokenKey = "kAccessTokenKey"
let kAccessTokenRegExPattern = "access_token=([^&]+)"

typealias OAuthCompletion = (success: Bool) -> ()

typealias OAuthClientCompletion = (success: Bool) -> ()


enum OAuthClientError: ErrorType {
    
    case MissingAccessToken(String)
    case ExtractingTokenFromString()
    case ExtractingTemporaryCode(String)
    case ResponseFromGithub(String)
     
}

enum SaveOptions: Int {
    case UserDefaults
}


class OAuthClient {
    
    //make sure URL Scheme inside app is set to add it to your Authorization callback URL
    //first register your app inside Github -> Settings -> Applications -> Register new app
    
    let githubClientID = "036b244a739b96b24768"
    let githubClientSecret = "d2f603d2fbf6a8e3fdf2a693cfc3233c357860ca"
    
    static let shared = OAuthClient()
    
    
    func oauthRequestWithParameters(parameters: [String : String]) {
        
        
        var parameterString = String()
        
        
        for parameter in parameters.values {
           parameterString = parameterString.stringByAppendingString(parameter)
        }
        
        // URL Constructor
        guard let requestURL = NSURL(string: "\(kOAuthBaseURLString)authorize?client_id=\(self.githubClientID)&scope=\(parameterString)") else {return}
        
        
        print(requestURL)
        
        UIApplication.sharedApplication().openURL(requestURL)
        
        
    }


    func accessToken() throws -> String {
        
        guard let accessToken = NSUserDefaults.standardUserDefaults().stringForKey(kAccessTokenKey) else {
            throw OAuthClientError.MissingAccessToken("You don't have access token saved.")
        }
            
        return accessToken
        
    }
    
    
    func temporaryCodeFromCallback(url: NSURL) throws -> String? {
        
        guard let temporaryCode = url.absoluteString.componentsSeparatedByString("=").last else {
            throw OAuthClientError.ExtractingTemporaryCode("Error ExtractingTermporaryCode. See: temporaryCodeFromCallback:")
        }
        
        return temporaryCode
        
        
    }
    
    
    
    func accessTokenFromString(string: String) -> String? {
        
        if string.containsString("access_token") {
            
            var equalSplitArray = string.componentsSeparatedByString("=")
            if (equalSplitArray.count > 1) {
                let tokenAndScope = equalSplitArray[1].componentsSeparatedByString("&scope")
                return tokenAndScope.first
            } else{
                return nil
                // fail
                //print(fail)
            }
            
        } else {
            return nil
        }
        
    }
    
    
    
    func tokenRequestWithCallback(url: NSURL, options: SaveOptions, completion: OAuthCompletion) {
        
        do {
            let temporaryCode = try self.temporaryCodeFromCallback(url)
            let requestString = "\(kOAuthBaseURLString)access_token?client_id=\(self.githubClientID)&client_secret=\(self.githubClientSecret)&code=\(temporaryCode!)"

            
            
            if let requestURL = NSURL(string: requestString) {
                
                
                let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
                let session = NSURLSession(configuration: sessionConfiguration)
                session.dataTaskWithURL(requestURL, completionHandler: { (data, response, error) -> Void in
                    
                    if let _ = error {

                        print("did recieve error from dataTaskWithURL")
                        completion(success: false); return
                    }
                    
                    if let data = data {
                        
                        
                        if let tokenString = self.stringWith(data) {
                            print("tokenString: \(tokenString)")
                            
                            do {
                                
                                let token = try self.accessTokenFromString(tokenString)                                
                                
                                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                    completion(success: self.saveAccessTokenToUserDefaults(token!))
                                })
                                
                            } catch _ {
                                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                    completion(success: false)
                                })
                            }
                            
                        }
                    }
                }).resume()
            }
            
        } catch _ {
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                completion(success: false)
            })
        }
        
        
    }
    
    
    
    
    func saveAccessTokenToUserDefaults(accessToken: String) -> Bool {
        NSUserDefaults.standardUserDefaults().setObject(accessToken, forKey: kAccessTokenKey)
        return NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    
    
    func stringWith(data: NSData) -> String? {
        let byteBuffer: UnsafeBufferPointer<UInt8> = UnsafeBufferPointer<UInt8>(start: UnsafeMutablePointer<UInt8>(data.bytes), count: data.length)
        return String(bytes: byteBuffer, encoding: NSASCIIStringEncoding)
    }
    
    
    
    
}











