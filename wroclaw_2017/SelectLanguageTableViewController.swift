//
//  SelectCountryTableViewController.swift
//  wroclaw_2017
//
//  Created by Adam Mateja on 22.11.2014.
//  Copyright (c) 2014 pl.wroclaw. All rights reserved.
//

import UIKit

class SelectLanguageTableViewController: UITableViewController {
    
    var data: Int = -1;
    var checkedData: Int = -1;
    
    ///////////////////////////////////// System functions /////////////////////////////////////

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    ///////////////////////////////////// View functions ///////////////////////////////////////
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellId = "Cell";
        switch(indexPath.row){
        case 0:
            cellId = "poland";
            break;
        case 1:
            cellId = "england";
            break;
        default:
            cellId = "null";
            break;
        }
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as UITableViewCell;
        
        data = indexPath.row;
        
        if (data == self.checkedData)
        {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None;
        }
        
        if (cellId == "poland" && NSUserDefaults.standardUserDefaults().boolForKey("PolishLanguage")) {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark;
        } else if (cellId == "england" && NSUserDefaults.standardUserDefaults().boolForKey("EnglishLanguage")) {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark;
        }
        
        
        
        return cell;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!;
        cell.accessoryType = UITableViewCellAccessoryType.Checkmark;
        
        data = indexPath.row;
        
        if (data != self.checkedData) {
            self.checkedData = data;
        }
        
        if (data == 0) {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "PolishLanguage");
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "EnglishLanguage");
        } else if (data == 1) {
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "PolishLanguage");
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "EnglishLanguage");
        }
        
        tableView.reloadData();
    }
}
