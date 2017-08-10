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
    let default_wall = UIImage(named: "Default_wallpaper")
    
    var textViewText : String = ""
    var titleText : String = ""
    var workingPosts = [Int : GamePost]()
    var currentWebsite : String = ""
    var htmlCode : String = ""
    var imageUrlArr1 : [String] = ["",""]
    var imageUrlArr2 : [String] = ["",""]
    var imageUrl : String = ""
    
    func postRequest( htmlAdress : String, params:[String : AnyObject]?, threadID: Int, filterParams : [String]?, success: @escaping (_ response: [String]?, _ response2: String?, _ response3: String?, _ threadID : Int) -> Void)
    {
        
        Alamofire.request(htmlAdress).responseString { response in
            
            switch response.result
            {
            case .success:
                self.currentWebsite = htmlAdress
                self.htmlCode = response.result.value! as String
                print("its here \(self.parseHTMLImage(html: self.htmlCode))")
                var result : [String] = self.parseHTML(html: response.result.value! as String)
                var result2 : String = self.parseHTMLTitle(html: response.result.value! as String)
                var result3 : String = self.parseHTMLIGNRating(html: response.result.value! as String)
                success(result, result2, result3, threadID)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    
    func parseHTML(html: String) -> [String] {
        if let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
            // Search for nodes by CSS selector
            var showString : String = ""
            var showS : [String] = []
            for show in doc.css("div[class^='article-content']") {
                
                for i in show.css("p") {
                    // Strip the string of surrounding whitespace.
                    
                    showS.append(i.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
                    showString = i.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                    
                    //print("\(showString)\n")
                    
                }
                return(showS)
            }
        }
        return ["error"]
    }
    
    func parseHTMLIGNRating(html: String) -> String {
        if let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
            // Search for nodes by CSS selector
            for show in doc.css("span[itemprop^='ratingValue']") {
                
                    // Strip the string of surrounding whitespace.
                    let showString = show.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                    
                    //print("\(showString)\n")
                    return(showString)
            }
        }
        return "N/A"
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
        return "N/A"
    }
    
    func parseHTMLImage(html: String) -> String {
        imageUrlArr2[0] = "error"
        if let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
            // Search for nodes by CSS selector
            for show in doc.css("div[class^='hero-unit-container']") {
                // Strip the string of surrounding whitespace.
                //let sg : String
                if let sgj = show["style"] {
                print("atribute \(sgj)")
                imageUrlArr1 = sgj.characters.split{$0 == "("}.map(String.init)
                print(imageUrlArr1)
                imageUrlArr2 = imageUrlArr1[1].characters.split{$0 == ")"}.map(String.init)
                print(imageUrlArr2)
                let showString = show.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                
                print(showString)
                //print("\(showString)\n")
                return(showString)
                }
                else
                {
                    for i in show.css("div[class^='hero-unit-stage']") {
                        
                        //hero-poster
                        if let sg = i["style"] {
                        print("atribute \(sg)")
                        imageUrlArr1 = sg.characters.split{$0 == "("}.map(String.init)
                        print(imageUrlArr1)
                        imageUrlArr2 = imageUrlArr1[1].characters.split{$0 == ")"}.map(String.init)
                        print(imageUrlArr2)
                        let showString = show.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                        
                        print(showString)
                        //print("\(showString)\n")
                        return(showString)
                        }
                        else {
                            for b in i.css("div[class^='hero-post']") {
                                let bg = b["style"]
                                print("atribute \(bg)")
                                imageUrlArr1 = (bg?.characters.split{$0 == "("}.map(String.init))!
                                print(imageUrlArr1)
                                imageUrlArr2 = imageUrlArr1[1].characters.split{$0 == ")"}.map(String.init)
                                print(imageUrlArr2)
                                let showString = show.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                                
                                print(showString)
                                //print("\(showString)\n")
                               
                                return(showString)
                            }
                        }
                    }
                }
                
            }
        }
        return "error"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                let object = gamePosts[indexPath.row]
                
                (segue.destination as! DetailViewController).detailItem = object
                
            }
        }
    }
    
    func getImage( catPictureURL : URL!, params:[String : AnyObject]?, threadID: Int, filterParams : [String]?, success: @escaping (_ response: UIImage?, _ threadID : Int) -> Void)
    {
        
        let session = URLSession(configuration: .default)
        
        // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
        let downloadPicTask = session.dataTask(with: catPictureURL) { (data, response, error) in
            
            if let e = error {
                print("Error downloading cat picture: \(e)")
                success(self.default_wall, threadID)
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
                        success(self.default_wall, threadID)
                    }
                } else {
                    print("Couldn't get response code for some reason")
                    success(self.default_wall, threadID)
                    //self.photo4 = self.photo2
                }
            }
        }

        downloadPicTask.resume()
        
    }

    
    private func loadSamplePosts() {
        
        photo4 = photo2
        guard let post1 = GamePost(postTitle: "Call of duty : black ops 2", image: photo1, text: ["Oddly for a game so focused on brutality, betrayal, violence, techno-fear and man’s inhumanity to man, generosity is Call of Duty: Black Ops 3’s biggest asset. This is a mountainous all-you-can-eat buffet of a Call of Duty, its steaming heated trays crammed with game modes, options and hidden features. It adds enough to the core gameplay to make it feel like more than just another lazy retread, and it’s easily the best-looking CoD to date.The only problem is that, as with all all youcan-eat buffets, some portions are a lot tastier than others, leaving you wondering whether a little more focus might have created something really exceptional.", "IGN 11/10"], rating: "11.0") else {
            fatalError("Unable to instantiate gamepost1")
        }
        /*guard let post2 = GamePost(postTitle: "Borderlands 2", image: photo2, text: ["Amazing graphics!", "IGN 9/10"]) else {
            fatalError("Unable to instantiate gamepost2")
        }
        guard let post3 = GamePost(postTitle: "Assasins creed unity", image: photo3, text: ["Game of the year!", "IGN 12/10"]) else {
            fatalError("Unable to instantiate gamepost3")
        }
 */
        gamePosts += [post1]
        
        self.postRequest(htmlAdress: "http://www.ign.com/articles/2017/08/04/superhot-vr-review", params: [:], threadID: 0, filterParams: nil, success: { (response, response2, response3, threadID) -> Void in
            self.afterResponseText(responseData: response!, responseTitle: response2!, responseRating: response3!, threadID: threadID)
        })
        self.postRequest(htmlAdress: "http://www.ign.com/articles/2017/07/24/splatoon-2-review", params: [:], threadID: 1, filterParams: nil, success: { (response, response2, response3, threadID) -> Void in
            self.afterResponseText(responseData: response!, responseTitle: response2!, responseRating: response3!, threadID: threadID)
        })
        self.postRequest(htmlAdress: "http://www.ign.com/articles/2017/08/01/lone-echo-review", params: [:], threadID: 2, filterParams: nil, success: { (response, response2, response3, threadID) -> Void in
            self.afterResponseText(responseData: response!, responseTitle: response2!, responseRating: response3!, threadID: threadID)
        })
        self.postRequest(htmlAdress: "http://www.ign.com/articles/2017/08/01/overcooked-special-edition-review", params: [:], threadID: 3, filterParams: nil, success: { (response, response2, response3, threadID) -> Void in
            self.afterResponseText(responseData: response!, responseTitle: response2!, responseRating: response3!, threadID: threadID)
        })
        self.postRequest(htmlAdress: "http://www.ign.com/articles/2017/07/29/sega-genesis-flashback-review", params: [:], threadID: 4, filterParams: nil, success: { (response, response2, response3, threadID) -> Void in
            self.afterResponseText(responseData: response!, responseTitle: response2!, responseRating: response3!, threadID: threadID)
        })
        self.postRequest(htmlAdress: "http://www.ign.com/articles/2017/07/27/sundered-review", params: [:], threadID: 5, filterParams: nil, success: { (response, response2, response3, threadID) -> Void in
            self.afterResponseText(responseData: response!, responseTitle: response2!, responseRating: response3!, threadID: threadID)
        })
        self.postRequest(htmlAdress: "http://www.ign.com/articles/2017/07/26/hey-pikmin-review", params: [:], threadID: 6, filterParams: nil, success: { (response, response2, response3, threadID) -> Void in
            self.afterResponseText(responseData: response!, responseTitle: response2!, responseRating: response3!, threadID: threadID)
        })
        self.postRequest(htmlAdress: "http://www.ign.com/articles/2017/07/25/pyre-review", params: [:], threadID: 7, filterParams: nil, success: { (response, response2, response3, threadID) -> Void in
            self.afterResponseText(responseData: response!, responseTitle: response2!, responseRating: response3!, threadID: threadID)
        })
        self.postRequest(htmlAdress: "http://www.ign.com/articles/2017/08/10/gran-turismo-sport-wont-include-microtransactions?abthid=598c6e5b7d5b19230f000007", params: [:], threadID: 8, filterParams: nil, success: { (response, response2, response3, threadID) -> Void in
            self.afterResponseText(responseData: response!, responseTitle: response2!, responseRating: response3!, threadID: threadID)
        })
        self.postRequest(htmlAdress: "http://www.ign.com/articles/2017/07/20/black-the-fall-review", params: [:], threadID: 9, filterParams: nil, success: { (response, response2, response3, threadID) -> Void in
            self.afterResponseText(responseData: response!, responseTitle: response2!, responseRating: response3!, threadID: threadID)
        })
        
    }
    
    func afterResponseImage(responseData : UIImage, threadID : Int)
    {
        /*self.getImage(catPictureURL: URL(string: imageUrlArr2[0])!, params: [:], threadID: threadID, filterParams: nil, success: { (response, threadID) -> Void in
            self.afterResponseImage(responseData: response!, threadID: threadID)
        })
        */
        workingPosts[threadID]?.image = responseData
        //workingPosts.removeValue(forKey: threadID)
        gamePosts.append(workingPosts[threadID]!)
        
        
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
    }
    
    
    func afterResponseText(responseData : [String], responseTitle : String, responseRating : String, threadID : Int)
    {
        
        self.getImage(catPictureURL: URL(string: imageUrlArr2[0])!, params: [:], threadID: threadID, filterParams: nil, success: { (response, threadID) -> Void in
            self.afterResponseImage(responseData: response!, threadID: threadID)
        })

        workingPosts.updateValue(GamePost(postTitle: responseTitle, image: photo4, text: responseData, rating: responseRating)!, forKey: threadID)
        
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
        cell.ratingLabel.text = gamepost.rating
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
