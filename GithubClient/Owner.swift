//
//  Owner.swift
//  GithubClient
//
//  Created by HoodsDream on 11/13/15.
//  Copyright © 2015 HoodsDream. All rights reserved.
//

import Foundation



class Owner {
    
    let ownerName: String
    let ownerAvatarURL: String
    
    init(name: String, avatarURL: String) {
        self.ownerName = name
        self.ownerAvatarURL = avatarURL
    }
}