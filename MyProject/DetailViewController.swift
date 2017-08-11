//
//  DetailViewController.swift
//  MyProject
//
//  Created by iD Student on 8/10/17.
//  Copyright © 2017 iD Tech. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailItemTitleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var UIImageView: UIImageView!
 
    var detailItem: GamePost? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        var gamepost = detailItem as! GamePost
        detailItemTitleLabel?.text = gamepost.postTitle
        textView?.text = ""
        for i in gamepost.text {
            //textView?.text = gamepost.text[0] + gamepost.text[1] + gamepost.text[2]
            textView?.text = (textView?.text)! + i
        }
        
        UIImageView?.image = gamepost.image
         
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
