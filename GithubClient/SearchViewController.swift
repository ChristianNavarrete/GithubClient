//
//  SearchViewController.swift
//  GithubClient
//
//  Created by HoodsDream on 11/13/15.
//  Copyright © 2015 HoodsDream. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    var repositories = [Repository]() {
    didSet {
    self.tableView.reloadData()
    }
    }

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var repos = [Repository]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    func update(searchTerm: String) {
        
        do {
            
            
            let token = try OAuthClient.shared.accessToken()
            
            let url = NSURL(string: "https://api.github.com/search/repositories?access_token=\(token)&q=\(searchTerm)")!
            
            let request = NSMutableURLRequest(URL: url)
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
                
                if let error = error {
                    print(error)
                }
                
                if let data = data {
                    if let dictionaryOfRepositories = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? [String : AnyObject] {
                        
                        if let items = dictionaryOfRepositories["items"] as? [[String : AnyObject]] {
                            
                            
                            var repositories = [Repository]()
                            
                            for eachRepository in items {
                                
                                let name = eachRepository["name"] as? String
                                let id = eachRepository["id"] as? Int
                                let url = eachRepository["url"] as? String
                                let owner = eachRepository["owner"] as? [String:AnyObject]
                                let ownerName = owner!["login"] as? String
                                let avatarURL = owner!["url"] as? String
                                
                                
                                if let name = name,
                                    id = id, url = url,
                                    ownerName = ownerName,
                                    avatarURL = avatarURL {
                                        
                                        let repo = Repository(name: name,id: id, url: url, owner: Owner(name: ownerName, avatarURL: avatarURL))
                                    repositories.append(repo)
                                        
                                }
                            }
                            
                            // This is because NSURLSession comes back on a background q.
                            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                self.repositories = repositories
                                
                                
                            })
                        }
                    }
                }
                }.resume()
        } catch {}
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repositories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("repoCell", forIndexPath: indexPath)
        let repository = self.repositories[indexPath.row]
        cell.textLabel?.text = repository.name
        cell.detailTextLabel?.text = repository.owner.ownerName
        return cell
    }
    
    // MARK: UISearchBarDelegate
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        guard let searchTerm = self.searchBar.text else {return}
        self.update(searchTerm)
        self.searchBar.resignFirstResponder()
    }
    
}

