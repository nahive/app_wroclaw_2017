//
//  ResultsTableViewCell.swift
//  wroclaw_2017
//
//  Created by nahive on 08/12/14.
//  Copyright (c) 2014 pl.wroclaw. All rights reserved.
//

import UIKit

class ResultsTableViewCell: UITableViewCell {
    
    var screen = UIScreen.mainScreen().bounds;

    
    @IBOutlet weak var contentW: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        contentW.constant = screen.width;
        
        // Initialization code
        //        var contentView: UIView = self.subviews[0].subviews[0] as UIView;
        //        contentView.frame = CGRectMake(0, 0, 100, 100);
        //       println(self.subviews[0]);
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
