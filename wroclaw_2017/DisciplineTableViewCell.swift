//
//  DisciplineTableViewCell.swift
//  wroclaw_2017
//
//  Created by nahive on 08/12/14.
//  Copyright (c) 2014 pl.wroclaw. All rights reserved.
//

import UIKit

class DisciplineTableViewCell: UITableViewCell {
    
    var screen = UIScreen.mainScreen().bounds;

    @IBOutlet weak var contentW: NSLayoutConstraint!
    @IBOutlet weak var titleW: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleW.constant = screen.width - 20;
        contentW.constant = screen.width - 20;
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
