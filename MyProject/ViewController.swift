//
//  ViewController.swift
//  MyProject
//
//  Created by iD Student on 8/4/17.
//  Copyright © 2017 iD Tech. All rights reserved.
//

import UIKit

class ViewController : UIViewController {
    
    var menuOpened = false
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuView.layer.shadowOpacity = 1
        menuView.layer.shadowRadius = 10
        
        
    }

    
    @IBAction func openMenu(_ sender: Any) {
        
        if menuOpened == false {
            leadingConstraint.constant = 0
            menuOpened = true
        }
        else {
            leadingConstraint.constant = -140
            menuOpened = false
        }
        UIView.animate(withDuration: 0.3, animations: {
        self.view.layoutIfNeeded()
        })
        
        view.layoutIfNeeded()
        
    }
    
}




