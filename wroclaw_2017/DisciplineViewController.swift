//
//  DisciplineViewController.swift
//  wroclaw_2017
//
//  Created by Adam Mateja on 11.11.2014.
//  Copyright (c) 2014 pl.wroclaw. All rights reserved.
//

import UIKit

class DisciplineViewController: UITableViewController, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate {
    
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
    var searchResults: [String] = [];
    
    // loader icon
    var loader = UIActivityIndicatorView();
    
    //helper
    var searchRowSelected: String = "";
    
    ///////////////////////////////////// System functions /////////////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customSetup();
        
        loader = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray);
        loader.frame = CGRectMake(0,0,80,80);
        loader.center = self.view.center;
        self.view.addSubview(loader);
        loader.bringSubviewToFront(self.view);
        loader.startAnimating();
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
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
    
    // pass info to detailed view
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "showDisciplineDetail"){
            var index: Int = 0;
            if (self.tableView.indexPathForSelectedRow() != nil) {
                let row = self.tableView.indexPathForSelectedRow()?.row;
                var cell: UITableViewCell = tableView.cellForRowAtIndexPath(self.tableView.indexPathForSelectedRow()!)!;
                var followName: UILabel = cell.viewWithTag(102) as UILabel;
                index = find(names, followName.text!)!;
            } else {
                index = find(names, searchRowSelected)!;
            }
            var destViewController : DisciplineDetailViewController = segue.destinationViewController as DisciplineDetailViewController;
            destViewController.idVal = id[index];
            println(id[index]);
            destViewController.locationVal = locations[index];
            destViewController.titleVal = names[index];
            println(names[index]);
        }
    }
    
    ///////////////////////////////////// View functions ///////////////////////////////////////
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if(tableView == self.searchDisplayController!.searchResultsTableView){
            return 1;
        } else {
            return disciplinesSectionTitles.count;
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == self.searchDisplayController!.searchResultsTableView) {
            return searchResults.count;
        } else {
            var sectionTitle: String = disciplinesSectionTitles[section];
            var sectionEvents: [String] = disciplines[sectionTitle]!;
            return sectionEvents.count;
        }
    }
    
    // header view
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var sectionHeaderView: UIView = UIView();
        if (tableView == self.searchDisplayController!.searchResultsTableView) {
            var title: UILabel = UILabel();
            title.frame = CGRectMake(5, 0, 300, 30);
            title.backgroundColor = UIColor.whiteColor();
            if (NSUserDefaults.standardUserDefaults().boolForKey("PolishLanguage")) {
                title.text = "Wyniki wyszukiwania:";
            } else {
                title.text = "Search results:";
            }
            sectionHeaderView.addSubview(title);
            return sectionHeaderView;
        }
        
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
        var disciplineName: UILabel? = cell!.viewWithTag(102) as? UILabel;
        var image: UIImageView? = cell!.viewWithTag(101) as? UIImageView;
        var index : Int;
        var imageView: UIImageView = UIImageView();
        imageView.frame = CGRectMake(19, 5, 30, 30);
        imageView.backgroundColor = Utils.colorize(0x1756a3);
        imageView.layer.cornerRadius = 8;
        
        //return cell for search results
        if (tableView == self.searchDisplayController!.searchResultsTableView) {
            var event: String = searchResults[indexPath.row];
            index = find(names, event)!;
            var currentImage: UIImage = icons[index];
            var numberOfSubviews: Int = cell?.subviews.count as Int!;
            for index in 0...numberOfSubviews-1 {
                if (index > -1) {
                    if (cell?.subviews[index] is UILabel) {
                        cell?.subviews[index].removeFromSuperview();
                        break;
                    }
                }
            }
            var label: UILabel = UILabel();
            label.text = event;
            label.font = UIFont(name: "HelveticaNeue-Thin", size: 21);
            label.frame = CGRectMake(60, 5, 300, 30);
            label.textAlignment = NSTextAlignment.Left;
            cell?.addSubview(label);
            imageView.image = currentImage;
            cell?.addSubview(imageView);
        } else {
            // assign data to views
            
            var sectionTitle: String = disciplinesSectionTitles[indexPath.section];
            var sectionImages: [UIImage] = imagesDictionary[sectionTitle]!;
            var sectionEvents: [String] = disciplines[sectionTitle]!;
            var event: String = sectionEvents[indexPath.row];
            var currentImage: UIImage = sectionImages[indexPath.row];
            imageView.image = currentImage;
            cell?.addSubview(imageView);
            disciplineName?.text = event;
            disciplineName?.font = UIFont(name: "HelveticaNeue-Light", size: 22);
            cell?.selectionStyle = UITableViewCellSelectionStyle.None;
        }
        return cell!
    }
    
    func filterContentForSearchText(searchText: String) {
        searchResults = names.filter({(name: String) -> Bool in
            let stringMatch = name.lowercaseString.rangeOfString(searchText.lowercaseString)
            return stringMatch != nil
        })
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
        return true
    }
    
    func searchDisplayControllerDidEndSearch(controller: UISearchDisplayController) {
        tableView.reloadData();
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (tableView == self.searchDisplayController!.searchResultsTableView) {
            var cell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!;
            var numberOfSubviews: Int = cell.subviews.count as Int!;
            for index in 0...numberOfSubviews-1 {
                if (index > -1) {
                    if (cell.subviews[index] is UILabel) {
                        var label: UILabel = cell.subviews[index] as UILabel;
                        searchRowSelected = label.text!;
                        break;
                    }
                }
            }
            performSegueWithIdentifier("showDisciplineDetail", sender: self);
        }
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
                        icons.append(img!);
                    } else {
                        categoryIcons.append(UIImage(named: "aikido.png")!);
                        icons.append(UIImage(named: "aikido.png")!);
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