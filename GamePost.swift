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
    
    init?(postTitle : String, image : UIImage?, text : [String]) {
        self.postTitle = postTitle
        self.image = image
        self.text = text
    }
}
