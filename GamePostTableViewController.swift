//
//  GamePostTableViewController.swift
//  MyProject
//
//  Created by iD Student on 8/8/17.
//  Copyright © 2017 iD Tech. All rights reserved.
//

import UIKit
import Kanna
import Alamofire

var finishedParse : Bool = true
var resultString : String = ""

class GamePostTableViewController: UITableViewController {

    var gamePosts = [GamePost]()
    var parsing : Bool = false
    let photo1 = UIImage(named: "CodBo3")
    let photo2 = UIImage(named: "BLands2")
    let photo3 = UIImage(named: "ACU")
    var photo4 : UIImage?
    
    var textViewText : String = ""
    var titleText : String = ""
    var workingPosts = [Int : GamePost]()
    var currentWebsite : String = ""
    var htmlCode : String = ""
    
    func postRequest( htmlAdress : String, params:[String : AnyObject]?, threadID: Int, filterParams : [String]?, success: @escaping (_ response: String?, _ response2: String?, _ threadID : Int) -> Void)
    {
        
        Alamofire.request(htmlAdress).responseString { response in
            
            switch response.result
            {
            case .success:
                self.currentWebsite = htmlAdress
                self.htmlCode = response.result.value! as String
                print("its here \(self.parseHTMLImage(html: self.htmlCode))")
                var result : String = self.parseHTML(html: response.result.value! as String)
                var result2 : String = self.parseHTMLTitle(html: response.result.value! as String)
                success(result, result2, threadID)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    
    func parseHTML(html: String) -> String {
        if let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
            // Search for nodes by CSS selector
            for show in doc.css("div[class^='article-content']") {
                
                for i in show.css("p") {
                // Strip the string of surrounding whitespace.
                let showString = i.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                
                //print("\(showString)\n")
                return(showString)
                }
            }
        }
        return "error"
    }
    
    func parseHTMLTitle(html: String) -> String {
        if let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
            // Search for nodes by CSS selector
            for show in doc.css("h1[class^='article-headline']") {
                // Strip the string of surrounding whitespace.
                let showString = show.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                print(showString)
                //print("\(showString)\n")
                return(showString)
                
            }
        }
        return "error"
    }
    
    func parseHTMLImage(html: String) -> String {
        if let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
            // Search for nodes by CSS selector
            for show in doc.css("div[class^='hero-poster']") {
                // Strip the string of surrounding whitespace.
                let sg : String
                sg = show["style"]!
                print("atribute \(sg)")
                let showString = show.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                
                print(showString)
                //print("\(showString)\n")
                return(showString)
                
            }
        }
        return "error"
    }
    
    
    func getImage( catPictureURL : URL!, params:[String : AnyObject]?, threadID: Int, filterParams : [String]?, success: @escaping (_ response: UIImage?, _ threadID : Int) -> Void)
    {
        let session = URLSession(configuration: .default)
        
        // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
        let downloadPicTask = session.dataTask(with: catPictureURL) { (data, response, error) in
            
            if let e = error {
                print("Error downloading cat picture: \(e)")
            } else {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if let res = response as? HTTPURLResponse {
                    print("Downloaded cat picture with response code \(res.statusCode)")
                    if let imageData = data {
                        // Finally convert that Data into an image and do what you wish with it.
                        let image = UIImage(data: imageData)
                        success(image, threadID)
                        // Do something with your image.
                    } else {
                        print("Couldn't get image: Image is nil")
                        self.photo4 = self.photo2
                    }
                } else {
                    print("Couldn't get response code for some reason")
                    self.photo4 = self.photo2
                }
            }
        }
        
        downloadPicTask.resume()
        
    }

    
    private func loadSamplePosts() {
        
        photo4 = photo2
        guard let post1 = GamePost(postTitle: "Call of duty : black ops 2", image: photo1, text: ["Oddly for a game so focused on brutality, betrayal, violence, techno-fear and man’s inhumanity to man, generosity is Call of Duty: Black Ops 3’s biggest asset. This is a mountainous all-you-can-eat buffet of a Call of Duty, its steaming heated trays crammed with game modes, options and hidden features. It adds enough to the core gameplay to make it feel like more than just another lazy retread, and it’s easily the best-looking CoD to date.The only problem is that, as with all all youcan-eat buffets, some portions are a lot tastier than others, leaving you wondering whether a little more focus might have created something really exceptional.", "IGN 11/10"]) else {
            fatalError("Unable to instantiate gamepost1")
        }
        guard let post2 = GamePost(postTitle: "Borderlands 2", image: photo2, text: ["Amazing graphics!", "IGN 9/10"]) else {
            fatalError("Unable to instantiate gamepost2")
        }
        guard let post3 = GamePost(postTitle: "Assasins creed unity", image: photo3, text: ["Game of the year!", "IGN 12/10"]) else {
            fatalError("Unable to instantiate gamepost3")
        }
        gamePosts += [post1, post2, post3]
        
        self.postRequest(htmlAdress: "http://www.ign.com/articles/2017/08/07/batman-the-telltale-series-season-2-review", params: [:], threadID: 0, filterParams: nil, success: { (response, response2, threadID) -> Void in
            self.afterResponseText(responseData: response!, responseTitle: response2!, threadID: threadID)
        })
        self.postRequest(htmlAdress: "http://www.ign.com/articles/2017/07/24/splatoon-2-review", params: [:], threadID: 1, filterParams: nil, success: { (response, response2, threadID) -> Void in
            self.afterResponseText(responseData: response!, responseTitle : response2!, threadID: threadID)
        })
        
        
    }
    
    func afterResponseImage(responseData : UIImage, threadID : Int)
    {
        workingPosts[threadID]?.image = responseData
        
        gamePosts.append(workingPosts[threadID]!)
        
        
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
    }
    
    func afterResponseText(responseData : String, responseTitle : String, threadID : Int)
    {
        
        self.getImage(catPictureURL: URL(string: "http://assets1.ignimgs.com/2017/08/04/telltalebatman-enemy-header-1501887356260_960w.jpg")!, params: [:], threadID: threadID, filterParams: nil, success: { (response, threadID) -> Void in
            self.afterResponseImage(responseData: response!, threadID: threadID)
        })

        workingPosts.updateValue(GamePost(postTitle: responseTitle, image: photo4, text: [responseData, "IGN 9/10"])!, forKey: threadID)
        
        /*scrapeIGN(htmlAdress: "http://www.ign.com/games/mega-man-legacy-collection-2/ps4-20068173")
        
        guard let post100 = GamePost(postTitle: "Borderlands 2", image: photo4, text: [resultString, "IGN 9/10"]) else {
                fatalError("Unable to instantiate gamepost2")
            }
        */
        
        /*
        workingPost?.text = post100.text
        workingPost?.postTitle = post100.postTitle
        workingPost?.image = post100.image
         */
        
        //GamePost(postTitle: post100.postTitle, image: post100.image, text: post100.text)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSamplePosts()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gamePosts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "GamePostTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? GamePostTableViewCell else {
            fatalError("The deq...")
        }
        let gamepost = gamePosts[indexPath.row]

        cell.titleLabel.text = gamepost.postTitle
        cell.photoImageView.image = gamepost.image
        cell.textTextView.text = gamepost.text[0]
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
