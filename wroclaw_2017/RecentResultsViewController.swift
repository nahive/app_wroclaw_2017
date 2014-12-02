//
//  RecentResultsViewController.swift
//  wroclaw_2017
//
//  Created by Adam Mateja on 26.11.2014.
//  Copyright (c) 2014 pl.wroclaw. All rights reserved.
//

import UIKit

class RecentResultsViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var revealButton: UIBarButtonItem!
    var screen = UIScreen.mainScreen().bounds;
    var results: [String: [[String]]] = ["" : [[]]];
    var id: [String] = [];
    var icons: [UIImage] = [];
    var eventsName: [String] = [];
    var loader = UIActivityIndicatorView();
    var refreshControl: UIRefreshControl = UIRefreshControl();
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        customSetup();
        getJSON();
        
//        loader = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge);
//        loader.frame = CGRectMake(0,0,80,80);
//        loader.center = self.view.center;
//        self.view.addSubview(loader);
//        loader.bringSubviewToFront(self.view);
//        loader.startAnimating();
//        UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
        
        
        
        
        //var refreshControler: UIRefreshControl = UIRefreshControl();
//        refreshControl.addTarget(self, action: Selector("handleRefresh"), forControlEvents: UIControlEvents.ValueChanged);
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
       // loader.stopAnimating();
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
    }
    
//    func updateData(sender : UIRefreshControl!){
//        // Reload table data
//        getJSON();
//        self.tableView.reloadData();
//        // End the refreshing
//        if ((refreshControl) != nil) {
//            
//            var formatter : NSDateFormatter = NSDateFormatter();
//            formatter.dateFormat = "MMM d, h:mm a";
//            var date = formatter.stringFromDate(NSDate());
//            var title = "Updated \(date)";
//            var attrs = NSDictionary(object: UIColor.grayColor(), forKey: NSForegroundColorAttributeName);
//            var attrTit = NSAttributedString(string: title, attributes: attrs);
//            self.refreshControl?.attributedTitle = attrTit;
//            self.refreshControl?.endRefreshing();
//        }
//        
//        
//    }
    
    func customSetup(){
        var revealViewController = self.revealViewController();
        if(revealViewController != nil){
            self.revealButton.target = revealViewController;
            self.revealButton.action = "revealToggle:";
            self.navigationController?.navigationBar.addGestureRecognizer(revealViewController.panGestureRecognizer());
            view.addGestureRecognizer(revealViewController.panGestureRecognizer());
        }
        
//        refreshControl =  UIRefreshControl();
//        refreshControl.backgroundColor = UIColor.whiteColor();
//        refreshControl.tintColor = UIColor.grayColor();
//        refreshControl.addTarget(self, action: "updateData:", forControlEvents: UIControlEvents.ValueChanged);
    }
    
    
    
    func getJSON() {
//        images.removeAll(keepCapacity: true);
//        authors.removeAll(keepCapacity: true);
//        titles.removeAll(keepCapacity: true);/
//        dates.removeAll(keepCapacity: true);
//        id.removeAll(keepCapacity: true);
        
        var url = "";
        var resultsForPlace: [String] = [];
        var placeArray: [String] = [];
        var containerPlaceArray: [[String]] = [[]];
        var lastId: String = "";
        
        if (NSUserDefaults.standardUserDefaults().boolForKey("PolishLanguage")) {
            url = "https://2017:twg2017wroclaw@2017.wroclaw.pl/mobile/event";
            self.title = "Ostatnie wyniki";
        } else {
            url = "https://2017:twg2017wroclaw@2017.wroclaw.pl/mobile/event?lang=en_US";
            self.title = "Recent Results";
        }
        
        let json = JSON(url:url);
        
        for (k, v) in json {
            for (i,j) in v {
                if (i as NSString == "first_place") {
                    for (l, m) in j {
                    }
                }
                switch i as NSString {
                case "isTeam":
                    //titles.append(j.toString(pretty: true));
                    break;
                case "sport":
                    //authors.append(j.toString(pretty: true));
                    break;
                case "id":
                    id.append(j.toString(pretty: true));
                    lastId = j.toString(pretty: true);
                    break;
                case "name":
                    eventsName.append(j.toString(pretty: true));
                    break;
               case "icon":
                    var url: NSURL = NSURL(string: "https://2017.wroclaw.pl/"+j.toString(pretty: true))!;
                    var data: NSData = NSData(contentsOfURL: url)!;
                    icons.append(UIImage(data: data)!);
                    break;
                case "first_place":
                    placeArray.removeAll(keepCapacity: true);
                    for (l,m) in j {
                        switch l as NSString {
                            case "name":
                                placeArray.append(m.toString(pretty: true));
                                break;
                            case "country":
                                placeArray.append(m.toString(pretty: true));
                                break;
                            case "flag":
                                placeArray.append(m.toString(pretty: true));
                                break;
                            default:
                                break;
                        }
                    }
                    containerPlaceArray.append(placeArray);
                    results.updateValue(containerPlaceArray, forKey: lastId);
                    break;
                case "second_place":
                    placeArray.removeAll(keepCapacity: true);
                    for (l,m) in j {
                        switch l as NSString {
                        case "name":
                            placeArray.append(m.toString(pretty: true));
                            break;
                        case "country":
                            placeArray.append(m.toString(pretty: true));
                            break;
                        case "flag":
                            placeArray.append(m.toString(pretty: true));
                            break;
                        default:
                            break;
                        }
                    }
                    containerPlaceArray.append(placeArray);
                    results.updateValue(containerPlaceArray, forKey: lastId);
                    break;
                case "third_place":
                    containerPlaceArray.removeAll(keepCapacity: true);
                    placeArray.removeAll(keepCapacity: true);
                    for (l,m) in j {
                        switch l as NSString {
                        case "name":
                            placeArray.append(m.toString(pretty: true));
                            break;
                        case "country":
                            placeArray.append(m.toString(pretty: true));
                            break;
                        case "flag":
                            placeArray.append(m.toString(pretty: true));
                            break;
                        default:
                            break;
                        }
                    }
                    containerPlaceArray.append(placeArray);
                    results.updateValue(containerPlaceArray, forKey: lastId);
                    break;
                default:
                    break;
                }
            }
        }
        id = id.sorted { $0.localizedCaseInsensitiveCompare($1) == NSComparisonResult.OrderedAscending };
        //loader.stopAnimating()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return id.count;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var sectionTitle: String = id[section];
        var sectionPosition = results[sectionTitle];
        var howMany :Int? = sectionPosition?.count;
        return howMany!;
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        //section header view
        var sectionHeaderView: UIView = UIView();
        sectionHeaderView.frame = CGRectMake(10, 10, screen.width, 30);
        sectionHeaderView.backgroundColor = Utils.colorize(0xfafafa);
        
        
        var disciplineIcon: UIImage = icons[section];
        var imageView: UIImageView = UIImageView(image: disciplineIcon);
        imageView.frame = CGRectMake(10, 5, 30, 30);
        imageView.backgroundColor = Utils.colorize(0x888888);
        imageView.layer.cornerRadius = 8;
        sectionHeaderView.addSubview(imageView);
        
        
        var label: UILabel = UILabel();
        label.text = eventsName[section];
        label.font = UIFont(name: "HelveticaNeue-Thin", size: 21);
        label.frame = CGRectMake(screen.width/2 - 100, 5, 200, 30);
        label.textAlignment = NSTextAlignment.Center;
        sectionHeaderView.addSubview(label);
        
        return sectionHeaderView;
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40;
    }
    
        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let tableId = "RecentResultCell";
            var cell = tableView.dequeueReusableCellWithIdentifier(tableId) as? UITableViewCell;
            if !(cell != nil) {
                cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: tableId);
            }
            var iconImage: UIImageView = cell!.viewWithTag(101) as UIImageView;
            var countryLabel: UILabel = cell!.viewWithTag(102) as UILabel;
            var nameLabel: UILabel = cell!.viewWithTag(103) as UILabel;
            var medalIcon: UIImageView = cell!.viewWithTag(104) as UIImageView;
            
            var sectionTitle: String = id[indexPath.section];
            var sectionResults: [[String]] = results[sectionTitle]!;
            var whichResult: Int = sectionResults.count;
            var currentResult: [String] = sectionResults[whichResult - indexPath.row-1];
            
            nameLabel.text = currentResult[0];
            countryLabel.text = currentResult[1];
            
            var url: NSURL = NSURL(string: "https://2017.wroclaw.pl/"+currentResult[2])!;
            var data: NSData = NSData(contentsOfURL: url)!;
            iconImage.image = (UIImage(data: data)!);
            
            if (indexPath.row == 0) {
                medalIcon.image = UIImage(named: "medal-gold.png");
            } else if (indexPath.row == 1) {
                medalIcon.image = UIImage(named: "medal-silver.png");
            } else if (indexPath.row == 2) {
                medalIcon.image = UIImage(named: "medal-bronze.png");
            }
            
            
            
            
            
            return cell!
        }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
