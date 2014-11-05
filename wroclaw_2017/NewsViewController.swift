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
    
    
    
    var images: [String] = ["news1.jpg","news2.jpg","news3.jpg","jujitsu2.jpg","power.jpg","wroclaw2.jpg"];
    var authors: [String] = ["Piotr Laboga","Marcin Zachorny","Łukasz Pałka","Adam Nowak","Filip Kowal","Marcin Pietraszko"];
    var titles: [String] = ["NBC produce brilliant promo ahead of Liverpool v Chelsea, set to ‘You’ll Never Walk Alone’.","African Cup of Nations - Senzo Meyiwa: South Africa star killed when...","Football has to return to its roots, or it will die. Football has to return to its roots. ","Alexis Sanchez increasingly crucial to Arsenal's title hopes","African Cup of Nations - Senzo Meyiwa: South Africa star killed when...","Football has to return to its roots, or it will die. Football has to return to its roots. "];
    var dates: [String] = ["2014-06-16","2014-06-15","2014-06-14","2014-06-13","2014-06-12","2014-06-11"];
    var fullContents: [String] = ["The Frenchman's stance puts him in direct opposition to some of Europe's biggest leagues and clubs, who want the event to be staged in May. The World Cup June and July, but Fifa has been told that Qatar's searing summer temperatures will put players' health at risk. Platini said:It'll never be in April, May or June. It will be in winter. He added the 2022 Champions League semi-finals and final could be moved to June if necessary, saying the clubs would accept whatever decision was made. \n\n It's not the clubs that are playing, it's the players and it's not possible to play in May when it's 40 degrees, said Platini, 59. The Frenchman's stance puts him in direct opposition to some of Europe's biggest leagues and clubs, who want the event to be staged in May. The World Cup June and July, but Fifa has been told that Qatar's searing summer temperatures will put players' health at risk. \n\n Platini said:It'll never be in April, May or June. It will be in winter. He added the 2022 Champions League semi-finals and final could be moved to June if necessary, saying the clubs would accept whatever decision was made. It's not the clubs that are playing, it's the players and it's not possible to play in May when it's 40 degrees, said Platini, 59.",
        "The Frenchman's stance puts him in direct opposition to some of Europe's biggest leagues and clubs, who want the event to be staged in May. The World Cup June and July, but Fifa has been told that Qatar's searing summer temperatures will put players' health at risk. Platini said:It'll never be in April, May or June. It will be in winter. He added the 2022 Champions League semi-finals and final could be moved to June if necessary, saying the clubs would accept whatever decision was made. \n\n It's not the clubs that are playing, it's the players and it's not possible to play in May when it's 40 degrees, said Platini, 59. The Frenchman's stance puts him in direct opposition to some of Europe's biggest leagues and clubs, who want the event to be staged in May. The World Cup June and July, but Fifa has been told that Qatar's searing summer temperatures will put players' health at risk. \n\n Platini said:It'll never be in April, May or June. It will be in winter. He added the 2022 Champions League semi-finals and final could be moved to June if necessary, saying the clubs would accept whatever decision was made. It's not the clubs that are playing, it's the players and it's not possible to play in May when it's 40 degrees, said Platini, 59.",
        "The Frenchman's stance puts him in direct opposition to some of Europe's biggest leagues and clubs, who want the event to be staged in May. The World Cup June and July, but Fifa has been told that Qatar's searing summer temperatures will put players' health at risk. Platini said:It'll never be in April, May or June. It will be in winter. He added the 2022 Champions League semi-finals and final could be moved to June if necessary, saying the clubs would accept whatever decision was made. \n\n It's not the clubs that are playing, it's the players and it's not possible to play in May when it's 40 degrees, said Platini, 59. The Frenchman's stance puts him in direct opposition to some of Europe's biggest leagues and clubs, who want the event to be staged in May. The World Cup June and July, but Fifa has been told that Qatar's searing summer temperatures will put players' health at risk. \n\n Platini said:It'll never be in April, May or June. It will be in winter. He added the 2022 Champions League semi-finals and final could be moved to June if necessary, saying the clubs would accept whatever decision was made. It's not the clubs that are playing, it's the players and it's not possible to play in May when it's 40 degrees, said Platini, 59.",
        "The Frenchman's stance puts him in direct opposition to some of Europe's biggest leagues and clubs, who want the event to be staged in May. The World Cup June and July, but Fifa has been told that Qatar's searing summer temperatures will put players' health at risk. Platini said:It'll never be in April, May or June. It will be in winter. He added the 2022 Champions League semi-finals and final could be moved to June if necessary, saying the clubs would accept whatever decision was made. \n\n It's not the clubs that are playing, it's the players and it's not possible to play in May when it's 40 degrees, said Platini, 59. The Frenchman's stance puts him in direct opposition to some of Europe's biggest leagues and clubs, who want the event to be staged in May. The World Cup June and July, but Fifa has been told that Qatar's searing summer temperatures will put players' health at risk. \n\n Platini said:It'll never be in April, May or June. It will be in winter. He added the 2022 Champions League semi-finals and final could be moved to June if necessary, saying the clubs would accept whatever decision was made. It's not the clubs that are playing, it's the players and it's not possible to play in May when it's 40 degrees, said Platini, 59.",
        "The Frenchman's stance puts him in direct opposition to some of Europe's biggest leagues and clubs, who want the event to be staged in May. The World Cup June and July, but Fifa has been told that Qatar's searing summer temperatures will put players' health at risk. Platini said:It'll never be in April, May or June. It will be in winter. He added the 2022 Champions League semi-finals and final could be moved to June if necessary, saying the clubs would accept whatever decision was made. \n\n It's not the clubs that are playing, it's the players and it's not possible to play in May when it's 40 degrees, said Platini, 59. The Frenchman's stance puts him in direct opposition to some of Europe's biggest leagues and clubs, who want the event to be staged in May. The World Cup June and July, but Fifa has been told that Qatar's searing summer temperatures will put players' health at risk. \n\n Platini said:It'll never be in April, May or June. It will be in winter. He added the 2022 Champions League semi-finals and final could be moved to June if necessary, saying the clubs would accept whatever decision was made. It's not the clubs that are playing, it's the players and it's not possible to play in May when it's 40 degrees, said Platini, 59.", "The Frenchman's stance puts him in direct opposition to some of Europe's biggest leagues and clubs, who want the event to be staged in May. The World Cup June and July, but Fifa has been told that Qatar's searing summer temperatures will put players' health at risk. Platini said:It'll never be in April, May or June. It will be in winter. He added the 2022 Champions League semi-finals and final could be moved to June if necessary, saying the clubs would accept whatever decision was made. \n\n It's not the clubs that are playing, it's the players and it's not possible to play in May when it's 40 degrees, said Platini, 59. The Frenchman's stance puts him in direct opposition to some of Europe's biggest leagues and clubs, who want the event to be staged in May. The World Cup June and July, but Fifa has been told that Qatar's searing summer temperatures will put players' health at risk. \n\n Platini said:It'll never be in April, May or June. It will be in winter. He added the 2022 Champions League semi-finals and final could be moved to June if necessary, saying the clubs would accept whatever decision was made. It's not the clubs that are playing, it's the players and it's not possible to play in May when it's 40 degrees, said Platini, 59."];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customSetup();
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        var bgView = UIImageView(image: UIImage(named:"bg_news.jpg"));
        bgView.alpha = 0.5;
        tableView.backgroundView = bgView;
        
    }
    
    
    func customSetup(){
        var revealViewController = self.revealViewController();
        if(revealViewController != nil){
            self.revealButtonItem.target = revealViewController;
            self.revealButtonItem.action = "revealToggle:";
            self.navigationController?.navigationBar.addGestureRecognizer(revealViewController.panGestureRecognizer());
            view.addGestureRecognizer(revealViewController.panGestureRecognizer());
        }
        
        self.refreshControl =  UIRefreshControl();
        self.refreshControl?.backgroundColor = UIColor.whiteColor();
        self.refreshControl?.tintColor = UIColor.grayColor();
        self.refreshControl?.addTarget(self, action: "updateData:", forControlEvents: UIControlEvents.ValueChanged);
        
    }
    
    func updateData(sender : UIRefreshControl!){
        // Reload table data
        self.tableView.reloadData();
        
        // End the refreshing
        if ((self.refreshControl) != nil) {
            
            var formatter : NSDateFormatter = NSDateFormatter();
            formatter.dateFormat = "MMM d, h:mm a";
            var date = formatter.stringFromDate(NSDate());
            var title = "Updated \(date)";
            var attrs = NSDictionary(object: UIColor.grayColor(), forKey: NSForegroundColorAttributeName);
            var attrTit = NSAttributedString(string: title, attributes: attrs);
            self.refreshControl?.attributedTitle = attrTit;
            self.refreshControl?.endRefreshing();
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
        cell?.backgroundColor = UIColor.clearColor()
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
            destViewController.authorVal = authors[row!];
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
    
//    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 10
//    }
    
//    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        var h_view : UIView = UIView();
//        h_view.backgroundColor = UIColor.lightGrayColor();
//        return h_view
//    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 110
    }

}
