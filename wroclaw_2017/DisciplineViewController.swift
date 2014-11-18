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
    var disciplines: [String: [String]] = ["" : []];
    
    var images: [UIImage] = [];
    var icons: [UIImage] = [];
    
    //sort this array
    var disciplinesSectionTitles: [String] = [];
    
    var disciplineIndexTitles: [String] = [];
    var locations: [String] = [];
    var id: [String] = [];
    var numberOfImage: Int = 0;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customSetup();
        getJSON();
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    func getJSON() {
        
       
        
        var url = "https://2017.wroclaw.pl/mobile/discipline"
        let json = JSON(url:url);
        
        var categoryDisciplines: [String] = [];
        
        for (k, v) in json {
            for (i,j) in v {
                switch i as NSString {
                case "location":
                    locations.append(j.toString(pretty: true));
                    break;
                case "id":
                    id.append(j.toString(pretty: true));
                    break;
                case "icon":
                    var url: NSURL = NSURL(string: "https://2017.wroclaw.pl/"+j.toString(pretty: true))!;
                    var data: NSData;
                    if (NSData(contentsOfURL: url) != nil) {
                        data = NSData(contentsOfURL: url)!;
                    } else {
                        var url2: NSURL = NSURL(string: "https://2017.wroclaw.pl/upload/images/ikony-dyscyplin/powerlifting.png")!
                        data = NSData(contentsOfURL: url2)!;
                    }
                    icons.append(UIImage(data: data)!);
                    break;
                case "name":
                    categoryDisciplines.append(j.toString(pretty: true));
                    break;
                case "photo":
                    var url: NSURL = NSURL(string: "https://2017.wroclaw.pl/"+j.toString(pretty: true))!;
                    var data: NSData;
                    if (NSData(contentsOfURL: url) != nil) {
                        data = NSData(contentsOfURL: url)!;
                    } else {
                        var url2: NSURL = NSURL(string: "https://2017.wroclaw.pl/upload/images/ikony-dyscyplin/powerlifting.png")!
                        data = NSData(contentsOfURL: url2)!;
                    }

                    images.append(UIImage(data: data)!);
                    break;
                case "category":
                    if (!(disciplinesSectionTitles.last == j.toString(pretty: true))) {
                        disciplinesSectionTitles.append(j.toString(pretty: true));
                        var lastDiscipline = categoryDisciplines.last;
                        categoryDisciplines.removeAll(keepCapacity: true);
                        categoryDisciplines.append(lastDiscipline!);
                    }
                    if (!(disciplineIndexTitles.last == j.toString(pretty: true))) {
                        disciplineIndexTitles.append(j.toString(pretty: true));
                    }
                    disciplines.updateValue(categoryDisciplines, forKey: j.toString(pretty: true));
                    break;
                default:
                    break;
                }
            }
        }
        
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
        if (!(numberOfImage > images.count-1)){
            image?.image = images[numberOfImage];
        }
        numberOfImage++;
        
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "showDisciplineDetail"){
            let row = self.tableView.indexPathForSelectedRow()?.row;
            var destViewController : DisciplineDetailViewController = segue.destinationViewController as DisciplineDetailViewController;
//            destViewController.titleVal = titles[row!];
//            destViewController.timeVal = times[row!];
//            destViewController.contentVal = fullContents[row!%3];
            
            
        }
    }


}
