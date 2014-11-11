//
//  DisciplineViewController.swift
//  wroclaw_2017
//
//  Created by Adam Mateja on 11.11.2014.
//  Copyright (c) 2014 pl.wroclaw. All rights reserved.
//

import UIKit

class DisciplineViewController: UITableViewController, UITableViewDelegate {

@IBOutlet weak var barButtonItem: UIBarButtonItem!
    
    var screen =  UIScreen.mainScreen().bounds;
    var disciplines: [String: [String]] = ["Ball Sports": ["Beach Handball", "Fistball", "Canoe Polo"], "Trend Sports": ["Ju-jitsu", "Sumo", "Karate"], "Artistic and Dance Sports": ["Dance Sports", "Roller Skating Artistic", "Gymnastics Rythmic"]];
    
    var images: [String] = ["wushu.png","aikido.png","air-sports.png","archery.png","beach-handball.png","billard-sports.png", "bodybuiliding.png","archery.png","aikido.png"];
    
    //sort this array
    var disciplinesSectionTitles: [String] = ["Ball Sports", "Trend Sports", "Artistic and Dance Sports"];
    
    var disciplineIndexTitles: [String] = ["Ball Sports", "Trend Sports", "Artistic and Dance Sports"];
    
    
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
            self.barButtonItem.target = revealViewController;
            self.barButtonItem.action = "revealToggle:";
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return disciplinesSectionTitles.count;
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var sectionTitle: String = disciplinesSectionTitles[section];
        println(sectionTitle);
        var sectionEvents: [String] = disciplines[sectionTitle]!;
        return sectionEvents.count;
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //section header view
        var sectionHeaderView: UIView = UIView();
        sectionHeaderView.frame = CGRectMake(10, 10, screen.width, 30);
        sectionHeaderView.backgroundColor = Utils.colorize(0xffffff);
        //sectionHeaderView.layer.borderColor = Utils.colorize(0xd64691, alpha: 0.5).CGColor;
        //sectionHeaderView.layer.borderWidth = 1;
        
        
//        var disciplineIcon: UIImage = UIImage(named: "wushu.png")!;
//        var imageView: UIImageView = UIImageView(image: disciplineIcon);
//        imageView.frame = CGRectMake(10, 5, 30, 30);
//        imageView.backgroundColor = Utils.colorize(0x888888);
//        imageView.layer.cornerRadius = 8;
//        sectionHeaderView.addSubview(imageView);
        
        
        var title: String = disciplinesSectionTitles[section];
        var label: UILabel = UILabel();
        label.text = title;
        label.textColor = Utils.colorize(0xd64691);
        label.font = UIFont(name: "HelveticaNeue-Thin", size: 13);
        label.font = UIFont.boldSystemFontOfSize(13);
        label.frame = CGRectMake(10, 5, 300, 30);
        label.textAlignment = NSTextAlignment.Left;
        sectionHeaderView.addSubview(label);
        
        return sectionHeaderView;
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40;
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tableId = "DisciplineCell";
        var cell = tableView.dequeueReusableCellWithIdentifier(tableId) as? UITableViewCell;
        if !(cell != nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: tableId);
        }
        var disciplineName: UILabel? = cell!.viewWithTag(102) as? UILabel;
        // title?.text = titles[indexPath.row];
        //title?.font = UIFont(name: "HelveticaNeue-Light", size: 17);
        var image: UIImageView? = cell!.viewWithTag(101) as? UIImageView;
        image?.backgroundColor = Utils.colorize(0x605196);
        image?.layer.cornerRadius = 8;
        image?.image = UIImage(named: images[indexPath.row]);
        
        //        NSString *sectionTitle = [animalSectionTitles objectAtIndex:indexPath.section];
        //        NSArray *sectionAnimals = [animals objectForKey:sectionTitle];
        //        NSString *animal = [sectionAnimals objectAtIndex:indexPath.row];
        //        cell.textLabel.text = animal;
        
        
        //How to get object at index????
        var sectionTitle: String = disciplinesSectionTitles[indexPath.section];
        
        var sectionEvents: [String] = disciplines[sectionTitle]!;
        
        var event: String = sectionEvents[indexPath.row];
        
        disciplineName?.text = event;
        disciplineName?.font = UIFont(name: "HelveticaNeue-Light", size: 22);
        
        return cell!
    }


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
