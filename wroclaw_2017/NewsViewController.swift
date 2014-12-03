//
//  NewsViewController.swift
//  wroclaw_2017
//
//  Created by nahive on 22/10/14.
//  Copyright (c) 2014 pl.wroclaw. All rights reserved.
//

import UIKit

public class NewsViewController: UITableViewController {
    @IBOutlet weak var revealButtonItem: UIBarButtonItem!
    
    
    
    var images: [UIImage] = [];
    var authors: [String] = [];
    var titles: [String] = [];
    var dates: [String] = [];
    var id: [String] = [];
    var loader = UIActivityIndicatorView();
    override public func viewDidLoad() {
        super.viewDidLoad()

        
        
        customSetup();
        var bgView = UIImageView(image: UIImage(named:"bg_news.jpg"));
        bgView.alpha = 0.5;
        tableView.backgroundView = bgView;
        
        loader = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge);
        loader.frame = CGRectMake(0,0,80,80);
        loader.center = self.view.center;
        self.view.addSubview(loader);
        loader.bringSubviewToFront(self.view);
        loader.startAnimating();
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
    }
    
    public func didItLoad() -> UIViewController {
        return self;
    }
    
    public func didDownload() -> Bool {
        return id.count != 0;
    }
    
    public override func viewDidAppear(animated: Bool) {
        if (NSUserDefaults.standardUserDefaults().boolForKey("FirstLaunch")) {
        } else {performSegueWithIdentifier("showSettings", sender: nil);}
        
        getJSON();
        self.tableView.reloadData();
        loader.stopAnimating();
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
        
        }
    
    public override func viewWillAppear(animated: Bool) {
        if (NSUserDefaults.standardUserDefaults().boolForKey("PolishLanguage")) {
            self.title = "Aktualności";
        } else if (NSUserDefaults.standardUserDefaults().boolForKey("EnglishLanguage")){
            self.title = "News";
        }
    }
    
    public func getJSON() -> Int {
        images.removeAll(keepCapacity: true);
        authors.removeAll(keepCapacity: true);
        titles.removeAll(keepCapacity: true);
        dates.removeAll(keepCapacity: true);
        id.removeAll(keepCapacity: true);
        
        var url = "";
        
        
        if (NSUserDefaults.standardUserDefaults().boolForKey("PolishLanguage")) {
            url = "https://2017:twg2017wroclaw@2017.wroclaw.pl/mobile/news";
            self.title = "Aktualności";
        } else {
            url = "https://2017:twg2017wroclaw@2017.wroclaw.pl/mobile/news?lang=en_US";
            self.title = "News";
        }
        let json = JSON(url:url);
        for (k, v) in json {
            for (i,j) in v {
                switch i as NSString {
                case "title":
                    titles.append(j.toString(pretty: true));
                    break;
                case "author":
                    authors.append(j.toString(pretty: true));
                    break;
                case "photo":
                    var url: NSURL = NSURL(string: "https://2017:twg2017wroclaw@2017.wroclaw.pl/"+j.toString(pretty: true))!;
                    var data: NSData = NSData(contentsOfURL: url)!;
                    images.append(UIImage(data: data)!);
                    break;
                case "date":
                    dates.append(j.toString(pretty: true));
                    break;
                case "id":
                    id.append(j.toString(pretty: true));
                    break;
                default:
                    break;
                }
            }
        }
        loader.stopAnimating()
        
        return json.length;
        
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
        getJSON();
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
    
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tableId = "NewsCell";
        var cell = tableView.dequeueReusableCellWithIdentifier(tableId) as? UITableViewCell;
        if !(cell != nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: tableId);
        }
        var image: UIImageView? = cell!.viewWithTag(101) as? UIImageView;
        image?.image = images[indexPath.row];
        var date: UILabel? = cell!.viewWithTag(102) as? UILabel;
        date?.text = dates[indexPath.row];
        var title: UITextView? = cell!.viewWithTag(103) as? UITextView;
        title?.text = titles[indexPath.row];
        title?.font = UIFont(name: "HelveticaNeue-Light", size: 17);
        cell?.backgroundColor = UIColor.clearColor()
        cell?.selectionStyle = UITableViewCellSelectionStyle.None;
        return cell!
    }
    
    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "showNewsDetail"){
            let row = self.tableView.indexPathForSelectedRow()?.row;
            var destViewController : NewsDetailViewController = segue.destinationViewController as NewsDetailViewController;
            destViewController.idVal = id[row!];
            destViewController.photoVal = images[row!];
            destViewController.titleVal = titles[row!];
            destViewController.dateVal = dates[row!];
        }
    }
    // MARK: - Table view data source
    
    override public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    
    
    override public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    override public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 110
    }
    
}
