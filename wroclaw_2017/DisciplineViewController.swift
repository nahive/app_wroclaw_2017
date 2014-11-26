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
    var imagesDictionary: [String: [UIImage]] = ["" : []];
    //sort this array
    var disciplinesSectionTitles: [String] = [];
    var disciplineIndexTitles: [String] = [];
    var names: [String] = [];
    var locations: [String] = [];
    var id: [String] = [];
    var numberOfImage: Int = 0;
    
    var loader = UIActivityIndicatorView();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customSetup();
        
        loader = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge);
        loader.frame = CGRectMake(0,0,80,80);
        loader.center = self.view.center;
        self.view.addSubview(loader);
        loader.bringSubviewToFront(self.view);
        loader.startAnimating();
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        getJSON();
        self.tableView.reloadData();
        loader.stopAnimating();
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
        
    }
    
    override func viewWillAppear(animated: Bool) {
        if (NSUserDefaults.standardUserDefaults().boolForKey("PolishLanguage")) {
            self.title = "Dyscypliny";
        } else if (NSUserDefaults.standardUserDefaults().boolForKey("EnglishLanguage")){
            self.title = "Disciplines";
        }
    }
    
    
    func getJSON() {
        var url = "https://2017.wroclaw.pl/mobile/discipline"
        let json = JSON(url:url);
        var categoryDisciplines: [String] = [];
        var categoryIcons: [UIImage] = [];
        locations.removeAll(keepCapacity: true);
        id.removeAll(keepCapacity: true);
        names.removeAll(keepCapacity: true);
        disciplineIndexTitles.removeAll(keepCapacity: true);
        disciplinesSectionTitles.removeAll(keepCapacity: true);
        disciplines.removeAll(keepCapacity: true);
        
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
                    var str = j.toString(pretty: true);
                    str = str.substringWithRange(Range<String.Index>(start: advance(str.startIndex, 31), end: advance(str.endIndex, 0)))
                    var img = UIImage(named: str);
                    if img != nil {
                        categoryIcons.append(img!);
                    } else {
                        categoryIcons.append(UIImage(named: "aikido.png")!);
                    }
                    break;
                case "name":
                    categoryDisciplines.append(j.toString(pretty: true));
                    names.append(j.toString(pretty: true));
                    break;
                case "category":
                    if (!(disciplinesSectionTitles.last == j.toString(pretty: true))) {
                        disciplinesSectionTitles.append(j.toString(pretty: true));
                        var lastDiscipline = categoryDisciplines.last;
                        categoryDisciplines.removeAll(keepCapacity: true);
                        categoryDisciplines.append(lastDiscipline!);
                        var lastImage: UIImage = categoryIcons.last!;
                        categoryIcons.removeAll(keepCapacity: true);
                        categoryIcons.append(lastImage);
                        imagesDictionary.updateValue(categoryIcons, forKey: j.toString(pretty: true));
                    } else {
                        imagesDictionary.updateValue(categoryIcons, forKey: j.toString(pretty: true));
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
        
        disciplinesSectionTitles = disciplinesSectionTitles.sorted { $0.localizedCaseInsensitiveCompare($1) == NSComparisonResult.OrderedAscending };
        
    }
    
    func customSetup(){
        var revealViewController = self.revealViewController();
        if(revealViewController != nil){
            self.barButtonItem.target = revealViewController;
            self.barButtonItem.action = "revealToggle:";
        }
        view.addGestureRecognizer(revealViewController.panGestureRecognizer());
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "showDisciplineDetail"){
            let row = self.tableView.indexPathForSelectedRow()?.row;
            var cell: UITableViewCell = tableView.cellForRowAtIndexPath(self.tableView.indexPathForSelectedRow()!)!;
            var followName: UILabel = cell.viewWithTag(102) as UILabel;
            var index: Int = find(names, followName.text!)!;
            var destViewController : DisciplineDetailViewController = segue.destinationViewController as DisciplineDetailViewController;
            destViewController.idVal = id[index];
            destViewController.locationVal = locations[index];
            destViewController.titleVal = names[index];
        }
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
        
        
        
        //        NSString *sectionTitle = [animalSectionTitles objectAtIndex:indexPath.section];
        //        NSArray *sectionAnimals = [animals objectForKey:sectionTitle];
        //        NSString *animal = [sectionAnimals objectAtIndex:indexPath.row];
        //        cell.textLabel.text = animal;
        
        
        //How to get object at index????
        var sectionTitle: String = disciplinesSectionTitles[indexPath.section];
        
        var sectionImages: [UIImage] = imagesDictionary[sectionTitle]!;
        var sectionEvents: [String] = disciplines[sectionTitle]!;
        
        var event: String = sectionEvents[indexPath.row];
        var currentImage: UIImage = sectionImages[indexPath.row];
        image?.image = currentImage;
        
        disciplineName?.text = event;
        disciplineName?.font = UIFont(name: "HelveticaNeue-Light", size: 22);
        cell?.selectionStyle = UITableViewCellSelectionStyle.None;
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
    
    
    


}
