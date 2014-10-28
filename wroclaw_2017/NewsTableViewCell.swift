//
//  NewsTableViewCell.swift
//  wroclaw_2017
//
//  Created by Szy Mas on 27/10/14.
//  Copyright (c) 2014 pl.wroclaw. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    var screen = UIScreen.mainScreen().bounds;

    @IBOutlet weak var titleW: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleW.constant = screen.width - 80 - 25;
    }


    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}
