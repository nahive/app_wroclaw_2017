//
//  NewsViewController.swift
//  wroclaw_2017
//
//  Created by nahive on 22/10/14.
//  Copyright (c) 2014 pl.wroclaw. All rights reserved.
//

import UIKit

public class NewsViewController: UITableViewController {
    
    // menu button
    @IBOutlet weak var revealButtonItem: UIBarButtonItem!
    var screen =  UIScreen.mainScreen().bounds;
    
    // data arrays for news content
    var images: [UIImage] = [];
    var authors: [String] = [];
    var titles: [String] = [];
    var dates: [String] = [];
    var id: [String] = [];
    
    // loading icon
    var loader = UIActivityIndicatorView();
    
    //helper
    var noInternetView: UIView = UIView();
    
    var first = true;
    
    ///////////////////////////////////// System functions /////////////////////////////////////
    
    override public func viewDidLoad() {
        super.viewDidLoad();
        
        // view customization
        customSetup();
        var bgView = UIImageView(image: UIImage(named:"bg_all.png"));
        bgView.alpha = 0.5
        tableView.backgroundView = bgView;
        
        // loading icon
        loader = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge);
        loader.frame = CGRectMake(0,0,80,80);
        loader.center = self.view.center;
        self.view.addSubview(loader);
        loader.bringSubviewToFront(self.view);
        loader.startAnimating();
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
        
        //Test internet connection
        if Reachability.isConnectedToNetwork() {
            revealButtonItem.image = UIImage(named: "reveal-icon.png");
            revealButtonItem.enabled = true;
            noInternetView.removeFromSuperview();
        } else {
            noInternetView.frame = CGRectMake(10, (screen.height/2)-50, screen.width-20, 50);
            noInternetView.backgroundColor = UIColor.whiteColor();
            var noInternetLabel: UILabel = UILabel();
            noInternetLabel.frame = CGRectMake(10, 10, screen.width-40, 30);
            if (NSUserDefaults.standardUserDefaults().boolForKey("PolishLanguage")) {
                noInternetLabel.text = "Brak połączenia z internetem.";
            } else if (NSUserDefaults.standardUserDefaults().boolForKey("EnglishLanguage")){
                noInternetLabel.text = "No internet connection.";
            }
            noInternetLabel.textAlignment = NSTextAlignment.Center;
            noInternetLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 21);
            noInternetView.addSubview(noInternetLabel);
            view.addSubview(noInternetView);
            revealButtonItem.style = UIBarButtonItemStyle.Plain;
            revealButtonItem.enabled = false;
            revealButtonItem.image = nil;
        }
    }
    
    
    // download data, reload table and hide loading icon
    public override func viewDidAppear(animated: Bool) {
        println("back");
        if(first){
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                self.getJSON();
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData();
                    self.loader.stopAnimating();
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
                }
            }
            first = false;
        }
        
    }
    
    // language customizations
    public override func viewWillAppear(animated: Bool) {
        if (NSUserDefaults.standardUserDefaults().boolForKey("PolishLanguage")) {
            self.title = "Aktualności";
        } else if (NSUserDefaults.standardUserDefaults().boolForKey("EnglishLanguage")){
            self.title = "News";
        }
    }
    
    public override func didReceiveMemoryWarning() {
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
        
        // pull down to refresh init
        self.refreshControl =  UIRefreshControl();
        self.refreshControl?.backgroundColor = UIColor.whiteColor();
        self.refreshControl?.tintColor = UIColor.grayColor();
        self.refreshControl?.addTarget(self, action: "updateData:", forControlEvents: UIControlEvents.ValueChanged);
        
    }
    
    // pull down to refresh function - get new data from server and refresh view
    func updateData(sender : UIRefreshControl!){
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            self.getJSON();
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData();
                self.loader.stopAnimating();
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
            }
        }

        if ((self.refreshControl) != nil) {
            // add date to refresh view
            var formatter : NSDateFormatter = NSDateFormatter();
            formatter.dateFormat = "MMM d, h:mm a";
            var date = formatter.stringFromDate(NSDate());
            var title = "Updated \(date)";
            var attrs = NSDictionary(object: UIColor.grayColor(), forKey: NSForegroundColorAttributeName);
            var attrTit = NSAttributedString(string: title, attributes: attrs);
            self.refreshControl?.attributedTitle = attrTit;
            self.refreshControl?.endRefreshing();
        }
        
        //Test internet connection
        if Reachability.isConnectedToNetwork() {
            revealButtonItem.image = UIImage(named: "reveal-icon.png");
            revealButtonItem.enabled = true;
            noInternetView.removeFromSuperview();
        } else {
            noInternetView.frame = CGRectMake(10, (screen.height/2)-50, screen.width-20, 50);
            noInternetView.backgroundColor = UIColor.whiteColor();
            var noInternetLabel: UILabel = UILabel();
            noInternetLabel.frame = CGRectMake(10, 10, screen.width-40, 30);
            if (NSUserDefaults.standardUserDefaults().boolForKey("PolishLanguage")) {
                noInternetLabel.text = "Brak połączenia z internetem.";
            } else if (NSUserDefaults.standardUserDefaults().boolForKey("EnglishLanguage")){
                noInternetLabel.text = "No internet connection.";
            }
            noInternetLabel.textAlignment = NSTextAlignment.Center;
            noInternetLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 21);
            noInternetView.addSubview(noInternetLabel);
            view.addSubview(noInternetView);
            revealButtonItem.style = UIBarButtonItemStyle.Plain;
            revealButtonItem.enabled = false;
            revealButtonItem.image = nil;
        }
    }

    ///////////////////////////////////// View functions ///////////////////////////////////////
    
    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // assign cell to view
        let tableId = "NewsCell";
        var cell = tableView.dequeueReusableCellWithIdentifier(tableId) as? UITableViewCell;
        if !(cell != nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: tableId);
        }
        
        // assign data to views
        var image: UIImageView? = cell!.viewWithTag(101) as? UIImageView;
        image?.image = images[indexPath.row];
        var date: UILabel? = cell!.viewWithTag(102) as? UILabel;
        date?.text = dates[indexPath.row];
        var title: UITextView? = cell!.viewWithTag(103) as? UITextView;
        title?.text = titles[indexPath.row];
        title?.font = UIFont(name: "HelveticaNeue-Light", size: 17);
        
        // clear background
        cell?.backgroundColor = UIColor.clearColor()
        cell?.selectionStyle = UITableViewCellSelectionStyle.None;
        return cell!
    }
    
    // news clicked to show details
    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "showNewsDetail"){
            let row = self.tableView.indexPathForSelectedRow()?.row;
            var destViewController : NewsDetailViewController = segue.destinationViewController as NewsDetailViewController;
            
            // pass data to detailed view
            destViewController.idVal = id[row!];
            destViewController.photoVal = images[row!];
            destViewController.titleVal = titles[row!];
            destViewController.dateVal = dates[row!];
        }
    }

    override public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }

    override public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 110
    }
    
    ///////////////////////////////////// Server functions /////////////////////////////////////
    
    public func getJSON() -> Int {
        
        // clear arrays
        images.removeAll(keepCapacity: true);
        authors.removeAll(keepCapacity: true);
        titles.removeAll(keepCapacity: true);
        dates.removeAll(keepCapacity: true);
        id.removeAll(keepCapacity: true);
        
        // lannguage check
        var url = "";
        if (NSUserDefaults.standardUserDefaults().boolForKey("PolishLanguage")) {
            url = "https://2017:twg2017wroclaw@2017.wroclaw.pl/mobile/news";
            self.title = "Aktualności";
        } else {
            url = "https://2017:twg2017wroclaw@2017.wroclaw.pl/mobile/news?lang=en_US";
            self.title = "News";
        }
        
        // parse json to arrays
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
        return json.length;
    }
    

    
}
