//
//  YouTubeTableViewCell.swift
//  MyProject
//
//  Created by iD Student on 8/11/17.
//  Copyright © 2017 iD Tech. All rights reserved.
//

import UIKit

class YouTubeTableViewCell: UITableViewCell {

    @IBOutlet weak var videoWebView: UIWebView!
    @IBOutlet weak var videoTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
