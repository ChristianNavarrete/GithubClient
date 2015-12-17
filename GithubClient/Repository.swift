//
//  Repository.swift
//  GithubClient
//
//  Created by HoodsDream on 11/12/15.
//  Copyright © 2015 HoodsDream. All rights reserved.
//

import Foundation


struct Repository {
    let name : String
    let url : String
    let id : Int
    let owner: Owner
    
    init(name: String, id: Int, url: String, owner: Owner) {
        self.name = name
        self.id = id
        self.url = url
        self.owner = owner
    }
}