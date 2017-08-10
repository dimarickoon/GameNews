//
//  GamePost.swift
//  MyProject
//
//  Created by iD Student on 8/8/17.
//  Copyright © 2017 iD Tech. All rights reserved.
//

import Foundation
import UIKit

class GamePost {
    var postTitle : String
    var image : UIImage?
    var text : [String]
    var rating : String
    
    init?(postTitle : String, image : UIImage?, text : [String], rating: String) {
        self.postTitle = postTitle
        self.image = image
        self.text = text
        self.rating = rating
    }
}
