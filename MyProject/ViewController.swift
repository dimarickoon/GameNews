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
    
    var smashCounter = 0
    
    @IBOutlet weak var smashCounterLabel: UILabel!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuView.layer.shadowOpacity = 1
        menuView.layer.shadowRadius = 10
        
        
    }

    @IBAction func smashButtonPressed(_ sender: Any) {
        smashCounter += 1
        smashCounterLabel.text = String(smashCounter)
        smashCounterLabel.textColor = getRandomColor()
        
    }
    
    func getRandomColor() -> UIColor{
        var randomRed:CGFloat = CGFloat(drand48())
        var randomGreen:CGFloat = CGFloat(drand48())
        var randomBlue:CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
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




