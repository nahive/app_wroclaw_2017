//
//  SelectFollowTableViewController.swift
//  wroclaw_2017
//
//  Created by Adam Mateja on 22.11.2014.
//  Copyright (c) 2014 pl.wroclaw. All rights reserved.
//

import UIKit

class SelectFollowTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    
    //System variables
    var screen =  UIScreen.mainScreen().bounds;
    var userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults();
    
    //Type of content view
    var contentValue: String = "";
    
    //Tables
    var follows: [String: [String]] = ["" : []];
    var imagesDictionary: [String: [UIImage]] = ["" : []];
    var icons: [UIImage] = [];
    var followsSectionTitles: [String] = [];
    var followIndexTitles: [String] = [];
    var names: [String] = [];
    var shortNames: [String] = [];
    var searchResults: [String] = [];
    var selectedDisciplies: [NSString] = [];
    var selectedShort: [NSString] = [];
    
    // loading icon
    var loader = UIActivityIndicatorView();
    
    ///////////////////////////////////// System functions /////////////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // loading icon
        loader = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray);
        loader.frame = CGRectMake(0,0,80,80);
        loader.center = self.view.center;
        self.view.addSubview(loader);
        loader.bringSubviewToFront(self.view);
        loader.startAnimating();
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
    }
    
    override func viewDidAppear(animated: Bool) {
        if (contentValue == "disciplines") {
            getDisciplineJSON();
        } else if (contentValue == "countries") {
            getCountiresJSON();
        }
        self.tableView.reloadData();
        if (contentValue == "disciplines" && (userDefaults.objectForKey("disciplinesToFollow")) != nil) {
            selectedDisciplies = userDefaults.objectForKey("disciplinesToFollow") as [NSString];
        } else if (contentValue == "countries" && (userDefaults.objectForKey("countriesToFollow")) != nil) {
            selectedShort = userDefaults.objectForKey("countriesToFollow") as [NSString];
            for short in selectedShort {
                var index = find(shortNames,short)!;
                selectedDisciplies.append(names[index]);
            }
        }
        loader.stopAnimating();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    ///////////////////////////////////// View functions ///////////////////////////////////////
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if(tableView == self.searchDisplayController!.searchResultsTableView){
            return 1;
        } else {
            return followsSectionTitles.count;
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == self.searchDisplayController!.searchResultsTableView) {
            return searchResults.count;
        } else {
            var sectionTitle: String = followsSectionTitles[section];
            var sectionEvents: [String] = follows[sectionTitle]!;
            return sectionEvents.count;
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //section header view for search results
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
        
        //normal section header view
        sectionHeaderView.frame = CGRectMake(10, 10, screen.width, 30);
        sectionHeaderView.backgroundColor = Utils.colorize(0xffffff);
        var title: String = followsSectionTitles[section];
        var label: UILabel = UILabel();
        label.text = title;
        label.textColor = Utils.colorize(0xFF0000);
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
        let tableId = "FollowCell";
        var cell = tableView.dequeueReusableCellWithIdentifier(tableId) as? UITableViewCell;
        if !(cell != nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: tableId);
        }
        var followName: UILabel? = cell!.viewWithTag(102) as? UILabel;
        var image: UIImageView? = cell!.viewWithTag(101) as? UIImageView;
        if (contentValue == "disciplines") {
            image?.backgroundColor = Utils.colorize(0xFF0000);
            image?.layer.cornerRadius = 8;
        }
        var sectionTitle : String;
        var event : String;
        var ind : Int;
        var currentImage : UIImage;
        
        //return cell for search results
        if (tableView == self.searchDisplayController!.searchResultsTableView) {
            event = searchResults[indexPath.row];
            ind = find(names, event)!;
            currentImage = icons[ind];
            var numberOfSubviews: Int = cell?.subviews.count as Int!;
            for index in 0...numberOfSubviews-1 {
                if (index > -1) {
                    if (cell?.subviews[index] is UILabel) {
                        cell?.subviews[index].removeFromSuperview();
                        break;
                    }
                }
            }
            if (contentValue == "countries") {
                var label: UILabel = UILabel();
                label.text = event;
                label.font = UIFont(name: "HelveticaNeue-Thin", size: 21);
                label.frame = CGRectMake(screen.width/2 - 100, 10, 200, 30);
                label.textAlignment = NSTextAlignment.Left;
                cell?.addSubview(label);
                var imageView: UIImageView = UIImageView();
                imageView.frame = CGRectMake(19, 10, 30, 30);
                imageView.image = currentImage;
                cell?.addSubview(imageView);
            } else if (contentValue == "disciplines") {
                var label: UILabel = UILabel();
                label.text = event;
                label.font = UIFont(name: "HelveticaNeue-Thin", size: 21);
                label.frame = CGRectMake(screen.width/2 - 100, 5, 200, 30);
                label.textAlignment = NSTextAlignment.Left;
                cell?.addSubview(label);
                var imageView: UIImageView = UIImageView();
                imageView.frame = CGRectMake(19, 5, 30, 30);
                imageView.image = currentImage;
                imageView.backgroundColor = Utils.colorize(0xFF0000);
                imageView.layer.cornerRadius = 8;
                cell?.addSubview(imageView);
            }
        } else {
            sectionTitle = followsSectionTitles[indexPath.section];
            var sectionEvents: [String] = follows[sectionTitle]!;
            var sectionImages: [UIImage] = imagesDictionary[sectionTitle]!;
            event = sectionEvents[indexPath.row];
            currentImage = sectionImages[indexPath.row];
            image?.image = currentImage;
            followName?.text = event;
            followName?.font = UIFont(name: "HelveticaNeue-Light", size: 22);
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.None;
        if (contains(selectedDisciplies, event)) {
            cell?.accessoryType = UITableViewCellAccessoryType.Checkmark;
        } else {
            cell?.accessoryType = UITableViewCellAccessoryType.None;
        }
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var followName: UILabel = UILabel();
        if (tableView == self.searchDisplayController!.searchResultsTableView) {
            var cell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!;
            var numberOfSubviews: Int = cell.subviews.count as Int!;
            for index in 0...numberOfSubviews-1 {
                if (index > -1) {
                    if (cell.subviews[index] is UILabel) {
                        followName = cell.subviews[index] as UILabel;
                        break;
                    }
                }
            }
        } else {
            var cell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!;
            followName = cell.viewWithTag(102) as UILabel;
        }
        if (contentValue == "disciplines") {
            if (contains(selectedDisciplies, followName.text!)) {
                var indexToRemove: Int = find(selectedDisciplies, followName.text!)!;
                selectedDisciplies.removeAtIndex(indexToRemove);
            } else {
                selectedDisciplies.append(followName.text!);
            }
            userDefaults.setObject(selectedDisciplies, forKey: "disciplinesToFollow");
        } else if (contentValue == "countries") {
            if (contains(selectedDisciplies, followName.text!)) {
                var indexToRemove: Int = find(selectedDisciplies, followName.text!)!;
                selectedShort.removeAtIndex(indexToRemove);
                selectedDisciplies.removeAtIndex(indexToRemove);
            } else {
                var indexToAdd = find(names,followName.text!)!;
                selectedShort.append(shortNames[indexToAdd]);
                selectedDisciplies.append(followName.text!);
            }
            userDefaults.setObject(selectedShort, forKey: "countriesToFollow");
        }
        tableView.reloadData();
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
    
    ///////////////////////////////////// Server functions /////////////////////////////////////
    
    func getDisciplineJSON() {
        var url = "https://2017.wroclaw.pl/mobile/discipline"
        let json = JSON(url:url);
        
        //JSON helpers
        var categoryDisciplines: [String] = [];
        var categoryIcons: [UIImage] = [];
        var firstIconNotNull = true;
        var lastCategory: String = "";
        
        for (k, v) in json {
            for (i,j) in v {
                switch i as NSString {
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
                    //Diffrent If for diffrent json
                    if (categoryIcons.count != 0 && firstIconNotNull == true) {
                        if (!(followsSectionTitles.last == j.toString(pretty: true))) {
                            followsSectionTitles.append(j.toString(pretty: true));
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
                        if (!(followsSectionTitles.last == j.toString(pretty: true))) {
                            followsSectionTitles.append(j.toString(pretty: true));
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
                    }
                    follows.updateValue(categoryDisciplines, forKey: j.toString(pretty: true));
                    break;
                default:
                    break;
                }
            }
        }
        if (firstIconNotNull == false) {
            imagesDictionary.updateValue(categoryIcons, forKey: lastCategory);
        }
        followsSectionTitles = followsSectionTitles.sorted { $0.localizedCaseInsensitiveCompare($1) == NSComparisonResult.OrderedAscending }
    }
    
    func getCountiresJSON() {
        var url = "";
        if (NSUserDefaults.standardUserDefaults().boolForKey("PolishLanguage")) {
            url = "https://2017:twg2017wroclaw@2017.wroclaw.pl/mobile/country";
        } else {
            url = "https://2017:twg2017wroclaw@2017.wroclaw.pl/mobile/country?lang=en_US";
        }
        let json = JSON(url:url);
        
        //JOSN helpers
        var categoryLanguages: [String] = [];
        var lastCategory: String = "";
        var ifRemove: Bool = false;
        var ifRemoveInNames = true;
        var previousCategory: String = "";
        var categoryDisciplines: [String] = [];
        var categoryIcons: [UIImage] = [];
        var firstIconNotNull = true;
        var whatsFirst = "";
        
        for (k, v) in json {
            for (i,j) in v {
                switch i as NSString {
                case "flag":
                    var url: NSURL = NSURL(string: "https://2017.wroclaw.pl/"+j.toString(pretty: true))!;
                    var data: NSData = NSData(contentsOfURL: url)!;
                    icons.append(UIImage(data: data)!);
                    categoryIcons.append(UIImage(data: data)!);
                    break;
                case "short_name":
                    shortNames.append(j.toString(pretty: true));
                    break;
                case "name":
                    if (whatsFirst == "") {
                        whatsFirst = "name";
                    }
                    names.append(j.toString(pretty: true));
                    categoryLanguages.append(j.toString(pretty: true));
                    break;
                case "first_letter":
                    if (whatsFirst == "") {
                        whatsFirst = "first_letter";
                    }
                    //Diffrent If for diffrent json
                    if (whatsFirst == "first_letter") {
                        if (!(contains(followsSectionTitles, j.toString(pretty: true)))) {
                            followsSectionTitles.append(j.toString(pretty: true));
                            followIndexTitles.append(j.toString(pretty: true));
                            var lastImage: UIImage = categoryIcons.last!;
                            categoryIcons.removeAll(keepCapacity: true);
                            categoryIcons.append(lastImage);
                            imagesDictionary.updateValue(categoryIcons, forKey: j.toString(pretty: true));
                            ifRemove = true;
                        } else {
                            imagesDictionary.updateValue(categoryIcons, forKey: j.toString(pretty: true));
                        }
                        if (!(categoryLanguages.isEmpty) && previousCategory != "null") {
                            println(categoryLanguages);
                            follows.updateValue(categoryLanguages, forKey: previousCategory);
                        }
                        if ifRemove {
                            categoryLanguages.removeAll(keepCapacity: true);
                            ifRemove = false;
                        }
                        lastCategory = j.toString(pretty: true);
                        previousCategory = j.toString(pretty: true);
                        break;
                    } else if (whatsFirst == "name") {
                        if (!(contains(followsSectionTitles, j.toString(pretty: true)))) {
                            followsSectionTitles.append(j.toString(pretty: true));
                            followIndexTitles.append(j.toString(pretty: true));
                            var lastImage: UIImage = categoryIcons.last!;
                            categoryIcons.removeAll(keepCapacity: true);
                            categoryIcons.append(lastImage);
                            ifRemove = true;
                            imagesDictionary.updateValue(categoryIcons, forKey: j.toString(pretty: true));
                        } else {
                            imagesDictionary.updateValue(categoryIcons, forKey: j.toString(pretty: true));
                        }
                        if (!(categoryLanguages.isEmpty) && ifRemove == false) {
                            follows.updateValue(categoryLanguages, forKey: j.toString(pretty: true));
                        } else {
                            var lastCategory = categoryLanguages.last;
                            categoryLanguages.removeAll(keepCapacity: true);
                            categoryLanguages.append(lastCategory!);
                            follows.updateValue(categoryLanguages, forKey: j.toString(pretty: true));
                            ifRemove = false;
                        }
                        break;
                    }
                default:
                    break;
                }
            }
        }
        follows.updateValue(categoryLanguages, forKey: lastCategory);
        followsSectionTitles = followsSectionTitles.sorted { $0.localizedCaseInsensitiveCompare($1) == NSComparisonResult.OrderedAscending }
    }
}