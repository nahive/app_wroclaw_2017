//
//  MedalsViewController.swift
//  wroclaw_2017
//
//  Created by Adam Mateja on 25.11.2014.
//  Copyright (c) 2014 pl.wroclaw. All rights reserved.
//

import UIKit

class MedalsViewController: UIViewController, UITableViewDelegate {

    // menu button
    @IBOutlet weak var revealButton: UIBarButtonItem!

    // medals icon
    @IBOutlet weak var medalsIcon: UITabBarItem!
    var screen =  UIScreen.mainScreen().bounds;
    
    // data from server
    var positions: [String] = [];
    var bronze_medals: [String] = [];
    var flags: [UIImage] = [];
    var silver_medals: [String] = [];
    var names: [String] = [];
    var gold_medals: [String] = [];

    ///////////////////////////////////// System functions /////////////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customSetup();
        getJSON();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    ///////////////////////////////////// Custom functions /////////////////////////////////////
    
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
        return 1;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count;
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        //section header view
        var sectionHeaderView: UIView = UIView();
        sectionHeaderView.frame = CGRectMake(10, 5, screen.width, 45);
        sectionHeaderView.backgroundColor = Utils.colorize(0xfafafa);
        
        // image view
        var imgWidth : CGFloat = 38.0;
        var last = screen.width - 50;

        // gold
        var goldMedal: UIImage = UIImage(named: "medal-gold.png")!;
        var imageGoldView: UIImageView = UIImageView(image: goldMedal);
        imageGoldView.frame = CGRectMake(last - imgWidth - imgWidth, 10, 35, 45);
        sectionHeaderView.addSubview(imageGoldView);
        
        // silver
        var silverMedal: UIImage = UIImage(named: "medal-silver.png")!;
        var imageSilverView: UIImageView = UIImageView(image: silverMedal);
        imageSilverView.frame = CGRectMake(last - imgWidth, 10, 35, 45);
        sectionHeaderView.addSubview(imageSilverView);
        
        // bronze
        var bronzeMedal: UIImage = UIImage(named: "medal-bronze.png")!;
        var imageBronzeView: UIImageView = UIImageView(image: bronzeMedal);
        imageBronzeView.frame = CGRectMake(last, 10, 35, 45);
        sectionHeaderView.addSubview(imageBronzeView);
        
        // label
        var label: UILabel = UILabel();
        label.text = "Twg 2017 Wrocław";
        label.font = UIFont(name: "HelveticaNeue-Thin", size: 21);
        label.frame = CGRectMake(10, 10, 250, 35);
        label.textAlignment = NSTextAlignment.Left;
        sectionHeaderView.addSubview(label);
        
        return sectionHeaderView;
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55;
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // assign view to cell
        let tableId = "medalClassificationCell";
        var cell = tableView.dequeueReusableCellWithIdentifier(tableId) as? UITableViewCell;
        if !(cell != nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: tableId);
        }
        
        // assign data to views
        var position: UILabel = cell!.viewWithTag(101) as UILabel;
        var flag: UIImageView = cell!.viewWithTag(102) as UIImageView;
        var name: UILabel = cell!.viewWithTag(103) as UILabel;
        var gold: UILabel = cell!.viewWithTag(104) as UILabel;
        var silver: UILabel = cell!.viewWithTag(105) as UILabel;
        var bronze: UILabel = cell!.viewWithTag(106) as UILabel;
        
        position.text = positions[indexPath.row];
        flag.image = flags[indexPath.row];
        name.text = names[indexPath.row];
        gold.text = gold_medals[indexPath.row];
        gold.textAlignment = NSTextAlignment.Center
        silver.text = silver_medals[indexPath.row];
        silver.textAlignment = NSTextAlignment.Center
        bronze.text = bronze_medals[indexPath.row];
        bronze.textAlignment = NSTextAlignment.Center;

        return cell!
    }

    ///////////////////////////////////// Server functions /////////////////////////////////////
    
    // get data from server
    func getJSON() {
        var url = "";
        var resultsForPlace: [String] = [];
        var placeArray: [String] = [];
        var containerPlaceArray: [[String]] = [[]];
        var lastId: String = "";
        
        if (NSUserDefaults.standardUserDefaults().boolForKey("PolishLanguage")) {
            url = "https://2017:twg2017wroclaw@2017.wroclaw.pl/mobile/result";
            self.title = "Klasyfikacja Medalowa";
        } else {
            url = "https://2017:twg2017wroclaw@2017.wroclaw.pl/mobile/result?lang=en_US";
            self.title = "Medal Classification";
        }
        
        let json = JSON(url:url);
        println(json);
        
        for (k, v) in json {
            for (i,j) in v {
                switch i as NSString {
                case "position":
                    positions.append(j.toString(pretty: true));
                    break;
                case "bronze_medals":
                    bronze_medals.append(j.toString(pretty: true));
                    break;
                case "flag":
                    var url: NSURL = NSURL(string: "https://2017.wroclaw.pl/"+j.toString(pretty: true))!;
                    var data: NSData = NSData(contentsOfURL: url)!;
                    flags.append(UIImage(data: data)!);
                    break;
                case "short_name":
                    break;
                case "silver_medals":
                    silver_medals.append(j.toString(pretty: true));
                    break;
                case "name":
                    names.append(j.toString(pretty: true));
                    break;
                case "gold_medals":
                    gold_medals.append(j.toString(pretty: true));
                    break;
                default:
                    break;
                }
            }
        }
    }

}
