//
//  fakeNews.swift
//  MyProject
//
//  Created by iD Student on 8/11/17.
//  Copyright © 2017 iD Tech. All rights reserved.
//

import UIKit

class fakeNews: UIViewController {

    @IBOutlet weak var uiWebViewGame: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //uiWebViewGame.delegate = self as! UIWebViewDelegate
        /*
        if let url = URL(string: "http://m.silvergames.com/game/flappy-bird/") {
            let request = URLRequest(url: url)
            uiWebViewGame.loadRequest(request)
        }
        */
        loadYoutube(videoID: "XCRSyxwE9IY")
        /*let url = NSURL(string: "http://m.silvergames.com/game/flappy-bird/")
        let requestObj = NSURLRequest(URL: url as! URL)
        uiWebViewGame.loadRequest(requestObj)
        */
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadYoutube(videoID:String) {
        guard
            let youtubeURL = URL(string: "https://www.youtube.com/embed/\(videoID)")
            else { return }
            uiWebViewGame.loadRequest( URLRequest(url: youtubeURL) )
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
