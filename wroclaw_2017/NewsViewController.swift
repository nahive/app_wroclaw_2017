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
    var titles: [String] = ["Jasiu szedl po mleko i nie doszedl w ogole","Ipsum","Dolor"];
    var dates: [String] = ["2014-06-16","2014-06-15","2014-06-14"];
    var shortContents: [String] = ["Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam eleifend malesuada arcu, tincidunt feugiat leo lacinia at. Nam felis metus, scelerisque ultrices metus quis, vulputate ultricies quam.",
    "Sed eros lacus, tincidunt luctus pulvinar a, ornare quis ante. Praesent sed nibh nisi. Donec tempor sit amet sapien a euismod. Proin tempus purus gravida condimentum tempor.",
    "Duis ut nulla interdum, malesuada justo nec, posuere purus. Mauris ac porta eros. Nulla finibus nisi sit amet commodo ullamcorper. Cras mollis tempor commodo. Integer quam tellus."];
    var fullContents: [String] = ["Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam eleifend malesuada arcu, tincidunt feugiat leo lacinia at. Nam felis metus, scelerisque ultrices metus quis, vulputate ultricies quam. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam eleifend malesuada arcu, tincidunt feugiat leo lacinia at. Nam felis metus, scelerisque ultrices metus quis, vulputate ultricies quam. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam eleifend malesuada arcu, tincidunt feugiat leo lacinia at. Nam felis metus, scelerisque ultrices metus quis, vulputate ultricies quam. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam eleifend malesuada arcu, tincidunt feugiat leo lacinia at. Nam felis metus, scelerisque ultrices metus quis, vulputate ultricies quam. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam eleifend malesuada arcu, tincidunt feugiat leo lacinia at. Nam felis metus, scelerisque ultrices metus quis, vulputate ultricies quam.",
    "Sed eros lacus, tincidunt luctus pulvinar a, ornare quis ante. Praesent sed nibh nisi. Donec tempor sit amet sapien a euismod. Proin tempus purus gravida condimentum tempor. Sed eros lacus, tincidunt luctus pulvinar a, ornare quis ante. Praesent sed nibh nisi. Donec tempor sit amet sapien a euismod. Proin tempus purus gravida condimentum tempor. Sed eros lacus, tincidunt luctus pulvinar a, ornare quis ante. Praesent sed nibh nisi. Donec tempor sit amet sapien a euismod. Proin tempus purus gravida condimentum tempor.",
    "Duis ut nulla interdum, malesuada justo nec, posuere purus. Mauris ac porta eros. Nulla finibus nisi sit amet commodo ullamcorper. Cras mollis tempor commodo. Integer quam tellus. Duis ut nulla interdum, malesuada justo nec, posuere purus. Mauris ac porta eros. Nulla finibus nisi sit amet commodo ullamcorper. Cras mollis tempor commodo. Integer quam tellus. Duis ut nulla interdum, malesuada justo nec, posuere purus. Mauris ac porta eros. Nulla finibus nisi sit amet commodo ullamcorper. Cras mollis tempor commodo. Integer quam tellus."];
    
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
        var title: UILabel? = cell!.viewWithTag(103) as? UILabel;
        title?.text = titles[indexPath.row];
        var content: UILabel? = cell!.viewWithTag(104) as? UILabel;
        content?.text = shortContents[indexPath.row];
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

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
