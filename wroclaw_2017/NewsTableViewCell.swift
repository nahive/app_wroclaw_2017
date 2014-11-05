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
    
    
    @IBOutlet weak var contentW: NSLayoutConstraint!
    @IBOutlet weak var titleW: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleW.constant = screen.width - 80 - 32;
        contentW.constant = screen.width - 20;
//        var contentView: UIView = self.subviews[0].subviews[0] as UIView;
//        contentView.frame = CGRectMake(0, 0, 100, 100);
//       println(self.subviews[0]);
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
