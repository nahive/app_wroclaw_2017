//
//  NewsViewController.swift
//  wroclaw_2017
//
//  Created by nahive on 22/10/14.
//  Copyright (c) 2014 pl.wroclaw. All rights reserved.
//

import UIKit

class NewsViewController: UITableViewController {
    @IBOutlet weak var revealButtonItem: UIBarButtonItem!
    var images: [String] = ["news1.jpg","news2.png","news3.jpg"];
    var titles: [String] = ["Alexis Sanchez increasingly crucial to Arsenal's title hopes","African Cup of Nations - Senzo Meyiwa: South Africa star killed when...","Football has to return to its roots, or it will die. Football has to return to its roots. "];
    var dates: [String] = ["2014-06-16","2014-06-15","2014-06-14"];
    var fullContents: [String] = ["Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam eleifend malesuada arcu, tincidunt feugiat leo lacinia at. Nam felis metus, scelerisque ultrices metus quis, vulputate ultricies quam. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam eleifend malesuada arcu, tincidunt feugiat leo lacinia at. Nam felis metus, scelerisque ultrices metus quis, vulputate ultricies quam. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam eleifend malesuada arcu, tincidunt feugiat leo lacinia at. Nam felis metus, scelerisque ultrices metus quis, vulputate ultricies quam. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam eleifend malesuada arcu, tincidunt feugiat leo lacinia at. Nam felis metus, scelerisque ultrices metus quis, vulputate ultricies quam. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam eleifend malesuada arcu, tincidunt feugiat leo lacinia at. Nam felis metus, scelerisque ultrices metus quis, vulputate ultricies quam.",
    "Sed eros lacus, tincidunt luctus pulvinar a, ornare quis ante. Praesent sed nibh nisi. Donec tempor sit amet sapien a euismod. Proin tempus purus gravida condimentum tempor. Sed eros lacus, tincidunt luctus pulvinar a, ornare quis ante. Praesent sed nibh nisi. Donec tempor sit amet sapien a euismod. Proin tempus purus gravida condimentum tempor. Sed eros lacus, tincidunt luctus pulvinar a, ornare quis ante. Praesent sed nibh nisi. Donec tempor sit amet sapien a euismod. Proin tempus purus gravida condimentum tempor.",
    "Duis ut nulla interdum, malesuada justo nec, posuere purus. Mauris ac porta eros. Nulla finibus nisi sit amet commodo ullamcorper. Cras mollis tempor commodo. Integer quam tellus. Duis ut nulla interdum, malesuada justo nec, posuere purus. Mauris ac porta eros. Nulla finibus nisi sit amet commodo ullamcorper. Cras mollis tempor commodo. Integer quam tellus. Duis ut nulla interdum, malesuada justo nec, posuere purus. Mauris ac porta eros. Nulla finibus nisi sit amet commodo ullamcorper. Cras mollis tempor commodo. Integer quam tellus."];
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customSetup();
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
       
        
    }
    
    

    func customSetup(){
        var revealViewController = self.revealViewController();
        if(revealViewController != nil){
            self.revealButtonItem.target = revealViewController;
            self.revealButtonItem.action = "revealToggle:";
            self.navigationController?.navigationBar.addGestureRecognizer(revealViewController.panGestureRecognizer());
        }
    }
    
   override func viewDidAppear(animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tableId = "NewsCell";
        var cell = tableView.dequeueReusableCellWithIdentifier(tableId) as? UITableViewCell;
        if !(cell != nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: tableId);
        }
        var image: UIImageView? = cell!.viewWithTag(101) as? UIImageView;
        image?.image = UIImage(named: images[indexPath.row]);
        var date: UILabel? = cell!.viewWithTag(102) as? UILabel;
        date?.text = dates[indexPath.row];
        var title: UITextView? = cell!.viewWithTag(103) as? UITextView;
        title?.text = titles[indexPath.row];
        title?.font = UIFont(name: "HelveticaNeue-Light", size: 17);
       
        
        return cell!
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "showNewsDetail"){
            let row = self.tableView.indexPathForSelectedRow()?.row;
            var destViewController : NewsDetailViewController = segue.destinationViewController as NewsDetailViewController;
            destViewController.titleVal = titles[row!];
            destViewController.imageVal = images[row!];
            destViewController.contentVal = fullContents[row!];
            destViewController.dateVal = dates[row!];
        }
    }
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return titles.count
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }

}
