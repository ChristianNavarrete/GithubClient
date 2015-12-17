//
//  GithubService.swift
//  GithubClient
//
//  Created by HoodsDream on 11/10/15.
//  Copyright © 2015 HoodsDream. All rights reserved.
//

import Foundation
import UIKit


class GithubService {
    
    
    class func searchRepositories(searchTerm:String){
        
        do {
            
            let token = try OAuthClient.shared.accessToken()
            
            let url = NSURL(string: "https://api.github.com/search/repositories?q=\(searchTerm)&access_token=\(token)")
            
            let request = NSMutableURLRequest(URL: url!)
            request.HTTPMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            let session = NSURLSession.sharedSession()
            
            let dataTask = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
                
                if error == nil {
        
                    
                    if let data = data {
                        
                        do {
                            let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)
                            print(json)
                        } catch {}
                        
                    }
                    
                } else {
                    
                    print("Error is:\(error?.description)")
                }

            }
            
            dataTask.resume()
            
        } catch _{}
   
        
    }
    
    
    class func createNewRepository(name:String) {
        
        //make sure we have token
        do {
            
            let token = try OAuthClient.shared.accessToken()
            
            if token.characters.count != 0 {
                //create the NSURL
                let url = NSURL(string: "https://api.github.com/user/repos?access_token=\(token)")
                
                //Create NSMutableRequest
                let request = NSMutableURLRequest(URL:url!)
                request.HTTPMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Accept")
                
                let parameter = ["name":name]
                request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(parameter, options: NSJSONWritingOptions.PrettyPrinted)
                
                let session = NSURLSession.sharedSession()
                _ = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                    
                    if error == nil {
                        
                        let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                        print(json)
                        
                        
                    } else {
                        print("something went wrong")
                    }
                    
                    
                }).resume()

            }
            
        } catch {return}

        
    }
    
    class func grabUser(completion: (user:User?) -> ()) {
        return
        
        do {
            let token = try OAuthClient.shared.accessToken()
            let url = NSURL(string: "https://api.github.com/user?access_token=\(token)")
            let request = NSMutableURLRequest(URL: url!)
            request.HTTPMethod = "GET"
            let session = NSURLSession.sharedSession()
            session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                
                if error == nil {
                    
                    do {
                        
                        if let user = try  NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? [String:AnyObject] {
                            
                            if let name = user["login"] as? String, avatarURL = user["avatar_url"] as? String {
                                let user = User(name: name, avatarURL: avatarURL)
                                completion(user: user)
                                return
                                
                            }
                            
                            completion(user: nil)
                            return
                            
                        }
                        completion(user: nil)
                        return
                        
   
                    } catch {
                        completion(user: nil)
                        return
                    }
                    
                }
                    completion(user: nil)
                    return
                
                
            })
            
        } catch let error {
            completion(user: nil)
            print(error)
            return
        }

        
    }
    


    
    class func grabRepositories(completion:(repositories:[Repository]) -> ()){
        
        var repositories = [Repository]()
        
        do {
            
            let token = try! OAuthClient.shared.accessToken()
            
            if token.characters.count != 0 {
                let url = NSURL(string: "https://api.github.com/user/repos?access_token=\(token)")
                let request = NSMutableURLRequest(URL: url!)
                request.HTTPMethod = "GET"
                let session = NSURLSession.sharedSession()
                session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                    
                    
                    if error == nil {
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            
                            do {
                                
                                if let repos = try  NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? [[String: AnyObject]] {
                                    for repo in repos {
                                        if let name = repo["name"] as? String,
                                            url = repo["url"] as? String,
                                            id = repo["id"] as? Int,
                                            owner = repo["owner"] as? [String:AnyObject],
                                            username = owner["login"] as? String,
                                            avatarURL = owner["avatar_url"] as? String {
                                            
                                                let newRepo = Repository(name: name, id:id, url: url, owner:Owner(name: username, avatarURL: avatarURL))
                                            repositories.append(newRepo)
                                        }
                                        
                                        
                                        
                                        completion(repositories: repositories)
                                        
                                    }
                                    
                                }
                                
                            } catch{return}
                            
                        })
                        
                    } else {
                        
                        print("ERROR: \(error?.description)")
                        
                    }
                    
                    print(repositories.count)
                    
                }).resume()
                
            }
            
            
        } catch _{}
        
        
        completion(repositories:[])
       
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    


}