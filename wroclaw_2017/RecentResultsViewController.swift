//
//  RecentResultsViewController.swift
//  wroclaw_2017
//
//  Created by Adam Mateja on 26.11.2014.
//  Copyright (c) 2014 pl.wroclaw. All rights reserved.
//

import UIKit

class RecentResultsViewController: UIViewController, UITableViewDelegate {

    // menu button
    @IBOutlet weak var revealButton: UIBarButtonItem!
    var screen = UIScreen.mainScreen().bounds;

    // data from server
    var results: [String: [String : [String: String]]] = ["" : ["" : ["" : ""]]];
    var id: [String] = [];
    var icons: [String : UIImage] = ["" : UIImage()];
    var eventsName: [String: String] = ["" : ""];
    var sportName: [String: String] = ["" : ""];
    var loader = UIActivityIndicatorView();
    
    // pull down to refresh
    var refreshControl: UIRefreshControl = UIRefreshControl();
    
    @IBOutlet weak var tableView: UITableView!
    
    ///////////////////////////////////// System functions /////////////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customSetup();
        getJSON();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
    }
    
    ///////////////////////////////////// Custom functions /////////////////////////////////////
    
    // menu button setup
    func customSetup(){
        var revealViewController = self.revealViewController();
        if(revealViewController != nil){
            self.revealButton.target = revealViewController;
            self.revealButton.action = "revealToggle:";
            self.navigationController?.navigationBar.addGestureRecognizer(revealViewController.panGestureRecognizer());
            view.addGestureRecognizer(revealViewController.panGestureRecognizer());
        }
    }
    
    
    ///////////////////////////////////// View functions ///////////////////////////////////////
    
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
        sectionHeaderView.frame = CGRectMake(10, 10, screen.width, 60);
        sectionHeaderView.backgroundColor = Utils.colorize(0xfafafa);
        
        // icon
        var disciplineIcon: UIImage = icons[id[section]]!;
        var imageView: UIImageView = UIImageView(image: disciplineIcon);
        imageView.frame = CGRectMake(10, 12, 30, 30);
        imageView.backgroundColor = Utils.colorize(0x888888);
        imageView.layer.cornerRadius = 8;
        sectionHeaderView.addSubview(imageView);
        
        // label
        var label: UILabel = UILabel();
        label.text = eventsName[id[section]];
        label.font = UIFont(name: "HelveticaNeue-Thin", size: 19);
        label.frame = CGRectMake(screen.width/2 - 150, 5, 300, 30);
        label.textAlignment = NSTextAlignment.Center;
        sectionHeaderView.addSubview(label);
        
        // sport label
        var sportLabel: UILabel = UILabel();
        sportLabel.text = sportName[id[section]];
        sportLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 15);
        sportLabel.frame = CGRectMake(screen.width/2 - 150, 30, 300, 20);
        sportLabel.textAlignment = NSTextAlignment.Center;
        sectionHeaderView.addSubview(sportLabel);
        
        return sectionHeaderView;
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // assign view to cell
        let tableId = "RecentResultCell";
        var cell = tableView.dequeueReusableCellWithIdentifier(tableId) as? UITableViewCell;
        if !(cell != nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: tableId);
        }

        // assign data to views
        var iconImage: UIImageView = cell!.viewWithTag(101) as UIImageView;
        var countryLabel: UILabel = cell!.viewWithTag(102) as UILabel;
        var nameLabel: UILabel = cell!.viewWithTag(103) as UILabel;
        var medalIcon: UIImageView = cell!.viewWithTag(104) as UIImageView;
        
        var sectionTitle: String = id[indexPath.section];
        var sectionResults: [String : [String: String]] = results[sectionTitle]!;
        var whichResult: Int = sectionResults.count;
        
        var currentResult: [String: String] = sectionResults["first_place"]!;
        
        if (indexPath.row == 0) {
            currentResult = sectionResults["first_place"]!;
        } else if (indexPath.row == 1) {
            currentResult = sectionResults["second_place"]!;
        } else {
            currentResult = sectionResults["third_place"]!;
        }

        nameLabel.text = currentResult["name"];
        countryLabel.text = currentResult["country"];
        
        var url: NSURL = NSURL(string: "https://2017.wroclaw.pl/"+currentResult["flag"]!)!;
        println(url);
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

    
    ///////////////////////////////////// Server functions /////////////////////////////////////
    
    // get data from server
    func getJSON() {
        var url = "";
        
        // clear arrays
        var resultsForPlace: [String] = [];
        var placeArray: [String: String] = ["" : ""];
        var containerPlaceArray: [String : [String: String]] = ["" : ["" : ""]];
        var lastId: String = "";
        
        if (NSUserDefaults.standardUserDefaults().boolForKey("PolishLanguage")) {
            url = "https://2017:twg2017wroclaw@2017.wroclaw.pl/mobile/event";
            self.title = "Ostatnie wyniki";
        } else {
            url = "https://2017:twg2017wroclaw@2017.wroclaw.pl/mobile/event?lang=en_US";
            self.title = "Recent Results";
        }
        results.removeAll(keepCapacity: true);
        let json = JSON(url:url);
        
        var first = false;
        var whichFirst = 0;
        var lastSport: String = "";
        var idFirst: Bool = true;
        
        println(json);
        
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
                    if (idFirst == true && lastId != "") {
                        sportName.updateValue(j.toString(pretty: true), forKey: lastId);
                    } else {
                        idFirst = false;
                    }
                    lastSport = j.toString(pretty: true);
                    break;
                case "id":
                    id.append(j.toString(pretty: true));
                    lastId = j.toString(pretty: true);
                    if (idFirst == false) {
                        sportName.updateValue(lastSport, forKey: j.toString(pretty: true));
                    }
                    break;
                case "name":
                    eventsName.updateValue(j.toString(pretty: true), forKey: lastId);
                    break;
                case "icon":
                    var url: NSURL = NSURL(string: "https://2017.wroclaw.pl/"+j.toString(pretty: true))!;
                    var data: NSData = NSData(contentsOfURL: url)!;
                    icons.updateValue(UIImage(data: data)!, forKey: lastId);
                    break;
                case "first_place":
                    if (first == false || whichFirst == 1) {
                        first = true;
                        containerPlaceArray.removeAll(keepCapacity: true);
                        whichFirst = 1;
                    }
                    placeArray.removeAll(keepCapacity: true);
                    for (l,m) in j {
                        switch l as NSString {
                        case "name":
                            placeArray.updateValue(m.toString(pretty: true), forKey: l as String);
                            break;
                        case "country":
                            placeArray.updateValue(m.toString(pretty: true), forKey: l as String);
                            break;
                        case "flag":
                            placeArray.updateValue(m.toString(pretty: true), forKey: l as String);
                            break;
                        default:
                            break;
                        }
                    }
                    containerPlaceArray.updateValue(placeArray, forKey: i as String);
                    results.updateValue(containerPlaceArray, forKey: lastId);
                    break;
                case "second_place":
                    if (first == false || whichFirst == 2) {
                        first = true;
                        containerPlaceArray.removeAll(keepCapacity: true);
                        whichFirst = 2;
                    }
                    placeArray.removeAll(keepCapacity: true);
                    for (l,m) in j {
                        switch l as NSString {
                        case "name":
                            placeArray.updateValue(m.toString(pretty: true), forKey: l as String);
                            break;
                        case "country":
                            placeArray.updateValue(m.toString(pretty: true), forKey: l as String);
                            break;
                        case "flag":
                            placeArray.updateValue(m.toString(pretty: true), forKey: l as String);
                            break;
                        default:
                            break;
                        }
                    }
                    containerPlaceArray.updateValue(placeArray, forKey: i as String);
                    results.updateValue(containerPlaceArray, forKey: lastId);
                    break;
                case "third_place":
                    if (first == false || whichFirst == 3) {
                        first = true;
                        containerPlaceArray.removeAll(keepCapacity: true);
                        whichFirst = 3;
                    }
                    placeArray.removeAll(keepCapacity: true);
                    for (l,m) in j {
                        switch l as NSString {
                        case "name":
                            placeArray.updateValue(m.toString(pretty: true), forKey: l as String);
                            break;
                        case "country":
                            placeArray.updateValue(m.toString(pretty: true), forKey: l as String);
                            break;
                        case "flag":
                            placeArray.updateValue(m.toString(pretty: true), forKey: l as String);
                            break;
                        default:
                            break;
                        }
                    }
                    containerPlaceArray.updateValue(placeArray, forKey: i as String);
                    results.updateValue(containerPlaceArray, forKey: lastId);
                    break;
                default:
                    break;
                }
            }
        }
        id = id.sorted { $0.localizedCaseInsensitiveCompare($1) == NSComparisonResult.OrderedAscending };
    }

}
