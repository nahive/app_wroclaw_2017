//
//  SelectFollowTableViewController.swift
//  wroclaw_2017
//
//  Created by Adam Mateja on 22.11.2014.
//  Copyright (c) 2014 pl.wroclaw. All rights reserved.
//

import UIKit

class SelectFollowTableViewController: UITableViewController {
    
    var contentValue: String = "";
    var screen =  UIScreen.mainScreen().bounds;
    var follows: [String: [String]] = ["" : []];
    var imagesDictionary: [String: [UIImage]] = ["" : []];
    var icons: [UIImage] = [];
    var followsSectionTitles: [String] = [];
    var followIndexTitles: [String] = [];
    var names: [String] = [];
    var numberOfImage: Int = 0;
    var selectedDisciplies: [NSString] = [];
    var indexPathChanged: Bool = false;
    
    var loader = UIActivityIndicatorView();
    
    var userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults();

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loader = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge);
        loader.frame = CGRectMake(0,0,80,80);
        loader.center = self.view.center;
        self.view.addSubview(loader);
        loader.bringSubviewToFront(self.view);
        loader.color = UIColor.blackColor();
        loader.startAnimating();
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
        
        if (contentValue == "disciplines" && (userDefaults.objectForKey("disciplinesToFollow")) != nil) {
            selectedDisciplies = userDefaults.objectForKey("disciplinesToFollow") as [NSString];
        } else if (contentValue == "countries" && (userDefaults.objectForKey("countriesToFollow")) != nil) {
            selectedDisciplies = userDefaults.objectForKey("countriesToFollow") as [NSString];
        }
    }
    
    
    
    func getDisciplineJSON() {
        var url = "https://2017.wroclaw.pl/mobile/discipline"
        let json = JSON(url:url);
        
        var categoryDisciplines: [String] = [];
        var categoryIcons: [UIImage] = [];
        
        for (k, v) in json {
            for (i,j) in v {
                switch i as NSString {
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
                    if (!(followsSectionTitles.last == j.toString(pretty: true))) {
                        followsSectionTitles.append(j.toString(pretty: true));
                        var lastDiscipline = categoryDisciplines.last;
                        categoryDisciplines.removeAll(keepCapacity: true);
                        categoryDisciplines.append(lastDiscipline!);
                    }
                    if (!(followIndexTitles.last == j.toString(pretty: true))) {
                        followIndexTitles.append(j.toString(pretty: true));
                    }
                    follows.updateValue(categoryDisciplines, forKey: j.toString(pretty: true));
                    if (!(contains(followsSectionTitles, j.toString(pretty: true)))) {
                        followsSectionTitles.append(j.toString(pretty: true));
                        followIndexTitles.append(j.toString(pretty: true));
                        var lastImage: UIImage = categoryIcons.last!;
                        categoryIcons.removeAll(keepCapacity: true);
                        categoryIcons.append(lastImage);
                        imagesDictionary.updateValue(categoryIcons, forKey: j.toString(pretty: true));
                    } else {
                        imagesDictionary.updateValue(categoryIcons, forKey: j.toString(pretty: true));
                    }
                    break;
                default:
                    break;
                }
            }
        }
        
        followsSectionTitles = followsSectionTitles.sorted { $0.localizedCaseInsensitiveCompare($1) == NSComparisonResult.OrderedAscending }
        
    }
    
    func getCountiresJSON() {
        
        var url = "https://2017.wroclaw.pl/mobile/country"
        let json = JSON(url:url);
        
        var categoryLanguages: [String] = [];
        var categoryImages: [UIImage] = [];
        var lastCategory: String = "";
        
        println(json);
        var ifRemove: Bool = false;
        var previousCategory: String = ""
        
        for (k, v) in json {
            for (i,j) in v {
                switch i as NSString {
                case "flag":
                    var url: NSURL = NSURL(string: "https://2017.wroclaw.pl/"+j.toString(pretty: true))!;
                    var data: NSData = NSData(contentsOfURL: url)!;
                    icons.append(UIImage(data: data)!);
                    
                    categoryImages.append(UIImage(data: data)!);
                    
                    
                    break;
                case "name":
                    names.append(j.toString(pretty: true));
                    categoryLanguages.append(j.toString(pretty: true));
                    break;
                case "first_letter":
                    
                    if (!(contains(followsSectionTitles, j.toString(pretty: true)))) {
                        followsSectionTitles.append(j.toString(pretty: true));
                        followIndexTitles.append(j.toString(pretty: true));
                        var lastImage: UIImage = categoryImages.last!;
                        categoryImages.removeAll(keepCapacity: true);
                        categoryImages.append(lastImage);
                        imagesDictionary.updateValue(categoryImages, forKey: j.toString(pretty: true));
                        ifRemove = true;
                    } else {
                        imagesDictionary.updateValue(categoryImages, forKey: j.toString(pretty: true));
                    }
                    if (!(categoryLanguages.isEmpty) && previousCategory != "null") {
                        follows.updateValue(categoryLanguages, forKey: previousCategory);
                    }
                    
                    if (ifRemove) {
                        categoryLanguages.removeAll(keepCapacity: true);
                        ifRemove = false;
                    }
                    lastCategory = j.toString(pretty: true);
                    previousCategory = j.toString(pretty: true);
                default:
                    break;
                }
            }
        }
        follows.updateValue(categoryLanguages, forKey: lastCategory);
        followsSectionTitles = followsSectionTitles.sorted { $0.localizedCaseInsensitiveCompare($1) == NSComparisonResult.OrderedAscending }
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if (contentValue == "disciplines") {
            getDisciplineJSON();
        } else if (contentValue == "countries") {
            getCountiresJSON();
        }
        
        
        self.tableView.reloadData();
        loader.stopAnimating();
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return followsSectionTitles.count;
    }
    
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var sectionTitle: String = followsSectionTitles[section];
        var sectionEvents: [String] = follows[sectionTitle]!;
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
        
        
        var title: String = followsSectionTitles[section];
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
        
        if (!(indexPathChanged)) {
            var previousIndexPath = indexPath;
            indexPathChanged = true;
        }
        
        println(indexPath);
        let tableId = "FollowCell";
        var cell = tableView.dequeueReusableCellWithIdentifier(tableId) as? UITableViewCell;
        if !(cell != nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: tableId);
        }
        var followName: UILabel? = cell!.viewWithTag(102) as? UILabel;
        var image: UIImageView? = cell!.viewWithTag(101) as? UIImageView;
        if (contentValue == "disciplines") {
            image?.backgroundColor = Utils.colorize(0x605196);
            image?.layer.cornerRadius = 8;
        }
//        if (!(numberOfImage > icons.count-1)){
//            image?.image = icons[numberOfImage];
//        }
        
        
        
        //        NSString *sectionTitle = [animalSectionTitles objectAtIndex:indexPath.section];
        //        NSArray *sectionAnimals = [animals objectForKey:sectionTitle];
        //        NSString *animal = [sectionAnimals objectAtIndex:indexPath.row];
        //        cell.textLabel.text = animal;
        
        
        //How to get object at index????
        var sectionTitle: String = followsSectionTitles[indexPath.section];
        
        var sectionEvents: [String] = follows[sectionTitle]!;
        var sectionImages: [UIImage] = imagesDictionary[sectionTitle]!;
        
        var event: String = sectionEvents[indexPath.row];
        var currentImage: UIImage = sectionImages[indexPath.row];
        image?.image = currentImage;
        followName?.text = event;
        followName?.font = UIFont(name: "HelveticaNeue-Light", size: 22);
        cell?.selectionStyle = UITableViewCellSelectionStyle.None;
        
        
        
        if (contains(selectedDisciplies, event)) {
            cell?.accessoryType = UITableViewCellAccessoryType.Checkmark;
        } else {
            cell?.accessoryType = UITableViewCellAccessoryType.None;
        }
        
        
        return cell!
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var cell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!;
        var followName: UILabel = cell.viewWithTag(102) as UILabel;
        
        
        if (contentValue == "disciplines") {
            if (contains(selectedDisciplies, followName.text!)) {
                var indexToRemove: Int = find(selectedDisciplies, followName.text!)!;
                selectedDisciplies.removeAtIndex(indexToRemove);
            } else {
                selectedDisciplies.append(followName.text!);
            }
            userDefaults.setObject(selectedDisciplies, forKey: "disciplinesToFollow");
        } else if (contentValue == "countries") {
            println(selectedDisciplies.count);
            if (contains(selectedDisciplies, followName.text!)) {
                var indexToRemove: Int = find(selectedDisciplies, followName.text!)!;
                selectedDisciplies.removeAtIndex(indexToRemove);
            } else {
                selectedDisciplies.append(followName.text!);
            }
            userDefaults.setObject(selectedDisciplies, forKey: "countriesToFollow");
        }
        
        
        
        
        tableView.reloadData();
        
    }

    
}
