//
//  SearchUserViewController.swift
//  GithubClient
//
//  Created by HoodsDream on 11/15/15.
//  Copyright © 2015 HoodsDream. All rights reserved.
//

import UIKit

class SearchUserViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var users = [User]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    class func identifier() -> String {
        return "SearchUserViewController"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.collectionViewLayout = CustomFlowLayout(columns: 2)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func update(searchTerm: String) {
        
        do {
            
            let token = try OAuthClient.shared.accessToken()
            
            let url = NSURL(string: "https://api.github.com/search/users?access_token=\(token)&q=\(searchTerm)")!
            
            let request = NSMutableURLRequest(URL: url)
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
                
                if let error = error {
                    print(error)
                }
                
                if let data = data {
                    
                    if let json = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? [String : AnyObject] {
                        
                        if let items = json["items"] as? [[String : AnyObject]] {
                            
                            // login
                            // avatar_url
                            
                            var users = [User]()
                            
                            for item in items {
                                
                                let name = item["login"] as? String
                                let profileImageUrl = item["avatar_url"] as? String
                                
                                if let name = name, profileImageUrl = profileImageUrl {
                                    
                                    users.append(User(name: name, avatarURL: profileImageUrl))
                                    
                                }
                                
                            }
                            
                            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                self.users = users
                            })
                            
                        }
                        
                    }
                    
                }
                
                }.resume()
        } catch {}
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "customSegue" {
            let vc = segue.destinationViewController as! UserViewController
            let cell = sender as! UICollectionViewCell
            let indexPath = self.collectionView!.indexPathForCell(cell)
            print("this is the index path:\(indexPath)")
            vc.user = self.users[indexPath!.row]
            
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("userCell", forIndexPath: indexPath) as! UserCollectionViewCell
        let user = self.users[indexPath.row]
        cell.user = user
        return cell
    }
    
    // MARK: UISearchBarDelegate
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text else {return}
        self.update(searchTerm)
        self.searchBar.resignFirstResponder()
    }
    
    
    

    
    
}
