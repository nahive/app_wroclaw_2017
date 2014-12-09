//
//  DisciplineViewController.swift
//  wroclaw_2017
//
//  Created by Adam Mateja on 11.11.2014.
//  Copyright (c) 2014 pl.wroclaw. All rights reserved.
//

import UIKit

class DisciplineViewController: UITableViewController, UITableViewDelegate {
    
    // menu button
    @IBOutlet weak var barButtonItem: UIBarButtonItem!
    
    var screen =  UIScreen.mainScreen().bounds;
    
    // disciplines data from server
    var disciplines: [String: [String]] = ["" : []];
    var images: [UIImage] = [];
    var icons: [UIImage] = [];
    var imagesDictionary: [String: [UIImage]] = ["" : []];
    var disciplinesSectionTitles: [String] = [];
    var disciplineIndexTitles: [String] = [];
    var names: [String] = [];
    var locations: [String] = [];
    var id: [String] = [];
    var numberOfImage: Int = 0;
    
    // loader icon
    var loader = UIActivityIndicatorView();
    
    ///////////////////////////////////// System functions /////////////////////////////////////
    
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
    
    // check language
    override func viewWillAppear(animated: Bool) {
        if (NSUserDefaults.standardUserDefaults().boolForKey("PolishLanguage")) {
            self.title = "Dyscypliny";
        } else if (NSUserDefaults.standardUserDefaults().boolForKey("EnglishLanguage")){
            self.title = "Disciplines";
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    ///////////////////////////////////// Custom functions /////////////////////////////////////
    
    func customSetup(){
        
        // menu button init
        var revealViewController = self.revealViewController();
        if(revealViewController != nil){
            self.barButtonItem.target = revealViewController;
            self.barButtonItem.action = "revealToggle:";
        }
        view.addGestureRecognizer(revealViewController.panGestureRecognizer());
    }
    
    ///////////////////////////////////// View functions ///////////////////////////////////////
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return disciplinesSectionTitles.count;
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var sectionTitle: String = disciplinesSectionTitles[section];
        var sectionEvents: [String] = disciplines[sectionTitle]!;
        return sectionEvents.count;
    }
    
    // pass info to detailed view
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
    
    // header view
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var sectionHeaderView: UIView = UIView();
        sectionHeaderView.frame = CGRectMake(10, 10, screen.width, 30);
        sectionHeaderView.backgroundColor = Utils.colorize(0xffffff);
        
        // header customization
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
        // assign view to cell
        let tableId = "DisciplineCell";
        var cell = tableView.dequeueReusableCellWithIdentifier(tableId) as? UITableViewCell;
        if !(cell != nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: tableId);
        }
        
        // assign data to views
        var disciplineName: UILabel? = cell!.viewWithTag(102) as? UILabel;
        var image: UIImageView? = cell!.viewWithTag(101) as? UIImageView;
        image?.backgroundColor = Utils.colorize(0x605196);
        image?.layer.cornerRadius = 8;

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
    
    ///////////////////////////////////// Server functions /////////////////////////////////////
    
    // get data from server
    func getJSON() {
        
        // clear arrays
        locations.removeAll(keepCapacity: true);
        id.removeAll(keepCapacity: true);
        names.removeAll(keepCapacity: true);
        disciplineIndexTitles.removeAll(keepCapacity: true);
        disciplinesSectionTitles.removeAll(keepCapacity: true);
        disciplines.removeAll(keepCapacity: true);
        imagesDictionary.removeAll(keepCapacity: true);
        
        // lannguage check
        var url = "";
        if (NSUserDefaults.standardUserDefaults().boolForKey("PolishLanguage")) {
            url = "https://2017:twg2017wroclaw@2017.wroclaw.pl/mobile/discipline";
        } else {
            url = "https://2017:twg2017wroclaw@2017.wroclaw.pl/mobile/discipline?lang=en_US";
        }
        
        let json = JSON(url:url);
        var categoryDisciplines: [String] = [];
        var categoryIcons: [UIImage] = [];
        
        // check dependency
        var firstIconNotNull = true;
        var lastCategory: String = "";
    
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
                    if (categoryIcons.count != 0 && firstIconNotNull == true) {
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
                        
                    } else if (categoryIcons.count == 0 || firstIconNotNull == false){
                        firstIconNotNull = false;
                        println(lastCategory);
                        if (!(disciplinesSectionTitles.last == j.toString(pretty: true))) {
                            disciplinesSectionTitles.append(j.toString(pretty: true));
                            var lastDiscipline = categoryDisciplines.last!;
                            categoryDisciplines.removeAll(keepCapacity: true);
                            categoryDisciplines.append(lastDiscipline);
                            if (categoryIcons.count != 0) {
                                imagesDictionary.updateValue(categoryIcons, forKey: lastCategory);
                                categoryIcons.removeAll(keepCapacity: true);
                            }
                            
                        } else {
                            imagesDictionary.updateValue(categoryIcons, forKey: j.toString(pretty: true));
                        }
                        
                        lastCategory = j.toString(pretty: true);
                        
                        if (!(disciplineIndexTitles.last == j.toString(pretty: true))) {
                            disciplineIndexTitles.append(j.toString(pretty: true));
                        }
                    }
                    disciplines.updateValue(categoryDisciplines, forKey: j.toString(pretty: true));
                    break;
                default:
                    break;
                }
            }
        }
        
        if (firstIconNotNull == false) {
            imagesDictionary.updateValue(categoryIcons, forKey: lastCategory);
            
        }
        disciplinesSectionTitles = disciplinesSectionTitles.sorted { $0.localizedCaseInsensitiveCompare($1) == NSComparisonResult.OrderedAscending };
        
    }

}
