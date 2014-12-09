//
//  ResultsTableViewCell.swift
//  wroclaw_2017
//
//  Created by nahive on 08/12/14.
//  Copyright (c) 2014 pl.wroclaw. All rights reserved.
//

import UIKit

class ResultsTableViewCell: UITableViewCell {
    
   // var screen = UIScreen.mainScreen().bounds;

    
    @IBOutlet weak var contentW: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
       // contentW.constant = screen.width;
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
