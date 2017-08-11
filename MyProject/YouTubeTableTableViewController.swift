//
//  YouTubeTableTableViewController.swift
//  MyProject
//
//  Created by iD Student on 8/11/17.
//  Copyright © 2017 iD Tech. All rights reserved.
//

import UIKit

class YouTubeTableTableViewController: UITableViewController {

    var youTubePosts = [YouTubePost]()
    
    private func loadSampleVids() {
        let id1 = "XCRSyxwE9IY"
        let id2 = "OSxO1sC1Zfw"
        let id3 = "3nZQoNtF_Y4"
        
        guard let vid1 = YouTubePost(title: "hallo", id: id1) else {
            fatalError("Unable to instantiate vid1")
        }
        guard let vid2 = YouTubePost(title: "hey", id: id2) else {
            fatalError("Unable to instantiate vid1")
        }
        guard let vid3 = YouTubePost(title: "hi", id: id3) else {
            fatalError("Unable to instantiate vid1")
        }
        youTubePosts += [vid1, vid2, vid3]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSampleVids()
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
        return youTubePosts.count
    }

    func loadYoutube(videoID:String) -> URLRequest{
        guard
            let youtubeURL = URL(string: "https://www.youtube.com/embed/\(videoID)")
            else {fatalError("YouTube video embeding failed")}
        return( URLRequest(url: youtubeURL) )
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "YouTubeTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? YouTubeTableViewCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        let youTubepost = youTubePosts[indexPath.row]

        cell.videoTitleLabel.text = youTubepost.title
        cell.videoWebView.loadRequest(loadYoutube(videoID: youTubepost.id))
        

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
