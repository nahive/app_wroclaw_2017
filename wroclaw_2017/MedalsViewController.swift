//
//  MedalsViewController.swift
//  wroclaw_2017
//
//  Created by Adam Mateja on 25.11.2014.
//  Copyright (c) 2014 pl.wroclaw. All rights reserved.
//

import UIKit

class MedalsViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var revealButton: UIBarButtonItem!
    @IBOutlet weak var medalsIcon: UITabBarItem!
    var screen =  UIScreen.mainScreen().bounds;
    var positions: [String] = [];
    var bronze_medals: [String] = [];
    var flags: [UIImage] = [];
    var silver_medals: [String] = [];
    var names: [String] = [];
    var gold_medals: [String] = [];
    override func viewDidLoad() {
        super.viewDidLoad()
        customSetup();
        getJSON();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        
    }
    
    func customSetup(){
        var revealViewController = self.revealViewController();
        if(revealViewController != nil){
            self.revealButton.target = revealViewController;
            self.revealButton.action = "revealToggle:";
            self.navigationController?.navigationBar.addGestureRecognizer(revealViewController.panGestureRecognizer());
            view.addGestureRecognizer(revealViewController.panGestureRecognizer());
        }
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
//        id = id.sorted { $0.localizedCaseInsensitiveCompare($1) == NSComparisonResult.OrderedAscending };
//        loader.stopAnimating()
    }

    

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
        
        
        var goldMedal: UIImage = UIImage(named: "medal-gold.png")!;
        var imageGoldView: UIImageView = UIImageView(image: goldMedal);
        imageGoldView.frame = CGRectMake(250, 10, 35, 45);
        sectionHeaderView.addSubview(imageGoldView);
        
        var silverMedal: UIImage = UIImage(named: "medal-silver.png")!;
        var imageSilverView: UIImageView = UIImageView(image: silverMedal);
        imageSilverView.frame = CGRectMake(290, 10, 35, 45);
        sectionHeaderView.addSubview(imageSilverView);
        
        var bronzeMedal: UIImage = UIImage(named: "medal-bronze.png")!;
        var imageBronzeView: UIImageView = UIImageView(image: bronzeMedal);
        imageBronzeView.frame = CGRectMake(330, 10, 35, 45);
        sectionHeaderView.addSubview(imageBronzeView);
        
        
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
        let tableId = "medalClassificationCell";
        var cell = tableView.dequeueReusableCellWithIdentifier(tableId) as? UITableViewCell;
        if !(cell != nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: tableId);
        }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
