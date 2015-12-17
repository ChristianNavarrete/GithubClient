//
//  HomeViewController.swift
//  GithubClient
//
//  Created by HoodsDream on 11/11/15.
//  Copyright © 2015 HoodsDream. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var repos = [Repository]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        GithubService.grabRepositories { (repositories) -> () in
            self.repos = repositories
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showProfile" {
            
            let viewController = segue.destinationViewController as! ProfileViewController
            guard let index = self.tableView.indexPathForSelectedRow else { return }
            print("index path selected \(index)")
            viewController.repository = self.repos[index.row]
            
            print("self.repos[index] name \(self.repos[index.row].name)")

            
        }
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("repoCell")! as UITableViewCell
        
        cell.textLabel?.text = repos[indexPath.row].name
        cell.detailTextLabel?.text = repos[indexPath.row].url
        return cell
    }

}
