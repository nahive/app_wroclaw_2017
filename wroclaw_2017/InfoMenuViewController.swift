//
//  InfoMenuViewController.swift
//  wroclaw_2017
//
//  Created by Szy Mas on 05/11/14.
//  Copyright (c) 2014 pl.wroclaw. All rights reserved.
//

import UIKit

class InfoMenuViewController: UITableViewController {
    
    // menu button
    @IBOutlet weak var revealButtonItem: UIBarButtonItem!
    
    // info data
    var infoTitles = ["The World Games 2017", "Hosting City Wroclaw","TWG History", "Charity", "Organization"];
    var infoHeaders = ["General information!","Organizing committee","Important informations"];
    var infoContents: [String] = ["Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam eleifend malesuada arcu, tincidunt feugiat leo lacinia at. Nam felis metus, scelerisque ultrices metus quis, vulputate ultricies quam. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam eleifend malesuada arcu, tincidunt feugiat leo lacinia at. Nam felis metus, scelerisque ultrices metus quis, vulputate ultricies quam. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam eleifend malesuada arcu, tincidunt feugiat leo lacinia at. \n\nNam felis metus, scelerisque ultrices metus quis, vulputate ultricies quam. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam eleifend malesuada arcu, tincidunt feugiat leo lacinia at. Nam felis metus, scelerisque ultrices metus quis, vulputate ultricies quam. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam eleifend malesuada arcu, tincidunt feugiat leo lacinia at. Nam felis metus, scelerisque ultrices metus quis, vulputate ultricies quam.",
        "Sed eros lacus, tincidunt luctus pulvinar a, ornare quis ante. Praesent sed nibh nisi. Donec tempor sit amet sapien a euismod. Proin tempus purus gravida condimentum tempor. Sed eros lacus, tincidunt luctus pulvinar a, ornare quis ante. Praesent sed nibh nisi. Donec tempor sit amet sapien a euismod. Proin tempus purus gravida condimentum tempor. Sed eros lacus, tincidunt luctus pulvinar a, ornare quis ante. Praesent sed nibh nisi. Donec tempor sit amet sapien a euismod. Proin tempus purus gravida condimentum tempor.",
        "Duis ut nulla interdum, malesuada justo nec, posuere purus. Mauris ac porta eros. Nulla finibus nisi sit amet commodo ullamcorper. Cras mollis tempor commodo. Integer quam tellus. Duis ut nulla interdum, malesuada justo nec, posuere purus. Mauris ac porta eros. Nulla finibus nisi sit amet commodo ullamcorper. Cras mollis tempor commodo. Integer quam tellus. Duis ut nulla interdum, malesuada justo nec, posuere purus.  \n\nMauris ac porta eros. Nulla finibus nisi sit amet commodo ullamcorper. Cras mollis tempor commodo. Integer quam tellus."];
    
    ///////////////////////////////////// System functions /////////////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customSetup();
        
        // view customization
        var bgView = UIImageView(image: UIImage(named:"bg_news.jpg"));
        bgView.alpha = 0.3;
        tableView.backgroundView = bgView;
    }
    
    override func viewWillAppear(animated: Bool) {
        // check language
        if (NSUserDefaults.standardUserDefaults().boolForKey("PolishLanguage")) {
            self.title = "Informacje";
        } else if (NSUserDefaults.standardUserDefaults().boolForKey("EnglishLanguage")){
            self.title = "Info";
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    ///////////////////////////////////// Custom functions /////////////////////////////////////

    func customSetup(){
        // menu button init
        var revealViewController = self.revealViewController();
        if(revealViewController != nil){
            self.revealButtonItem.target = revealViewController;
            self.revealButtonItem.action = "revealToggle:";
            self.navigationController?.navigationBar.addGestureRecognizer(revealViewController.panGestureRecognizer());
            view.addGestureRecognizer(revealViewController.panGestureRecognizer());
        }
    }
    
    ///////////////////////////////////// View functions ///////////////////////////////////////
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoTitles.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // assign view for cell
        let tableId = "InfoCell";
        var cell = tableView.dequeueReusableCellWithIdentifier(tableId) as? UITableViewCell;
        if !(cell != nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: tableId);
        }
        
        // assign data to views
        var title: UILabel? = cell!.viewWithTag(203) as? UILabel;
        title?.text = infoTitles[indexPath.row];
        title?.font = UIFont(name: "HelveticaNeue-Light", size:18);
        cell?.backgroundColor = UIColor.clearColor()
        cell?.selectionStyle = UITableViewCellSelectionStyle.None;
        return cell!
    }
    
    // show details on click
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showInfoDetail", sender: self);
    }
    
    // pass data to detailed view
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "showInfoDetail"){
            let row = self.tableView.indexPathForSelectedRow()?.row as Int!;
            var destViewController : InfoViewController = segue.destinationViewController as InfoViewController;
            destViewController.infoHeaders = infoHeaders;
            destViewController.infoContents = infoContents;
            destViewController.infoTitle = infoTitles[row];
        }
    }
}