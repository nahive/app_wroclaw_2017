//
//  CalendarViewController.swift
//  wroclaw_2017
//
//  Created by Szy Mas on 28/10/14.
//  Copyright (c) 2014 pl.wroclaw. All rights reserved.
//

import UIKit


class CalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //  @IBOutlet weak var label: UILabel!
    @IBOutlet weak var datePicker: DIDatepicker!
    @IBOutlet weak var revealButtonItem: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var datePickerW: NSLayoutConstraint!
    
    
    var screen =  UIScreen.mainScreen().bounds;
    var times: [String] = ["08:00","09:00","10:00","11:00","12:00","13:00","14:00","15:00","16:00","16:15","17:00","18:15"];
    var titles: [String] = ["Dance Sport Women's eliminations","Men's Squash Final","Ju-jitsu Men's 1st round","Archery Women's Semifinal","Tug of War Men's eliminations","Women's Duathlon","Rugby Sevens Men's Quarterfinal","Women's Air Sports","Men's Softball 2sd round","Canoe Polo Women's 3rd round","Billard Sports Men's eliminations","Korfball Women's Final"];
    var fullContents: [String] = ["Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam eleifend malesuada arcu, tincidunt feugiat leo lacinia at. Nam felis metus, scelerisque ultrices metus quis, vulputate ultricies quam. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam eleifend malesuada arcu, tincidunt feugiat leo lacinia at. Nam felis metus, scelerisque ultrices metus quis, vulputate ultricies quam. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam eleifend malesuada arcu, tincidunt feugiat leo lacinia at. Nam felis metus, scelerisque ultrices metus quis, vulputate ultricies quam. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam eleifend malesuada arcu, tincidunt feugiat leo lacinia at. Nam felis metus, scelerisque ultrices metus quis, vulputate ultricies quam. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam eleifend malesuada arcu, tincidunt feugiat leo lacinia at. Nam felis metus, scelerisque ultrices metus quis, vulputate ultricies quam.",
        "Sed eros lacus, tincidunt luctus pulvinar a, ornare quis ante. Praesent sed nibh nisi. Donec tempor sit amet sapien a euismod. Proin tempus purus gravida condimentum tempor. Sed eros lacus, tincidunt luctus pulvinar a, ornare quis ante. Praesent sed nibh nisi. Donec tempor sit amet sapien a euismod. Proin tempus purus gravida condimentum tempor. Sed eros lacus, tincidunt luctus pulvinar a, ornare quis ante. Praesent sed nibh nisi. Donec tempor sit amet sapien a euismod. Proin tempus purus gravida condimentum tempor.",
        "Duis ut nulla interdum, malesuada justo nec, posuere purus. Mauris ac porta eros. Nulla finibus nisi sit amet commodo ullamcorper. Cras mollis tempor commodo. Integer quam tellus. Duis ut nulla interdum, malesuada justo nec, posuere purus. Mauris ac porta eros. Nulla finibus nisi sit amet commodo ullamcorper. Cras mollis tempor commodo. Integer quam tellus. Duis ut nulla interdum, malesuada justo nec, posuere purus. Mauris ac porta eros. Nulla finibus nisi sit amet commodo ullamcorper. Cras mollis tempor commodo. Integer quam tellus."];
    
    
    //How to add many values for one key?
    var events: [String: [String]] = ["Softball": ["Men's Squash Final", "Men's SemiFinal", "Women's q"], "Tug of War": ["Men's Final"], "Squash": ["Men's Semifinal"]];
    var eventsSectionTitles: [String] = ["Softball", "Tug of War", "Squash"];
    var eventIndexTitles: [String] = ["Softball", "Tug of War", "Squash", "Dance Sport"];
    
    
    
    func backwards(s1: String, s2: String) -> Bool {
        return s1 > s2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customSetup();
        initDatePicker();
        self.tableView.alpha = 0.0;
        var scroll: UIScrollView! = datePicker.subviews[0] as UIScrollView;
        scroll.frame = CGRectMake(0, 0, view.frame.width, datePicker.frame.height);
        getJSON();
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        if (NSUserDefaults.standardUserDefaults().boolForKey("PolishLanguage")) {
            self.title = "Kalendarz";
        } else if (NSUserDefaults.standardUserDefaults().boolForKey("EnglishLanguage")){
            self.title = "Calendar";
        }
    }
    
    func prepareTable() {
    }
    
    override func viewDidAppear(animated: Bool) {
        var scroll: UIScrollView! = datePicker.subviews[0] as UIScrollView;
        scroll.frame = CGRectMake(0, 0, view.frame.width, datePicker.frame.height);
        Utils.fadeIn(tableView,duration: 0.6);
    }
    
    func getJSON() {
//        images.removeAll(keepCapacity: true);
//        authors.removeAll(keepCapacity: true);
//        titles.removeAll(keepCapacity: true);
//        dates.removeAll(keepCapacity: true);
//        id.removeAll(keepCapacity: true);
        
        var url = "";
        
        
        if (NSUserDefaults.standardUserDefaults().boolForKey("PolishLanguage")) {
            url = "https://2017:twg2017wroclaw@2017.wroclaw.pl/mobile/schedule";
            self.title = "Aktualności";
        } else {
            url = "https://2017:twg2017wroclaw@2017.wroclaw.pl/mobile/schedule?lang=en_US";
            self.title = "News";
        }
        
        
        
        // if (NSUserDefaults.standardUserDefaults().objectForKey("newsJSON") != nil) {
        //  var json = NSUserDefaults.standardUserDefaults().objectForKey("newsJSON");
        //} else {
        let json = JSON(url:url);
        //}
        
        //NSUserDefaults.standardUserDefaults().setObject(json, forKey: "newsJSON");
        
        for (k, v) in json {
            for (i,j) in v {
                println(i);
            }
        }
        
        
    }
    
    
    func initDatePicker(){
        datePickerW.constant = view.frame.width;
        datePicker.addTarget(self, action: "updateDate:", forControlEvents: UIControlEvents.ValueChanged);
        var datesrc = "20170803";
        var dateformat = NSDateFormatter();
        dateformat.dateFormat = "yyyyMMdd";
        var date = dateformat.dateFromString(datesrc);
        datePicker.fillDatesFromDate(date, numberOfDays: 14);
        datePicker.selectDateAtIndex(0);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func customSetup(){
        var revealViewController = self.revealViewController();
        if(revealViewController != nil){
            self.revealButtonItem.target = revealViewController;
            self.revealButtonItem.action = "revealToggle:";
            self.navigationController?.navigationBar.addGestureRecognizer(revealViewController.panGestureRecognizer());
            view.addGestureRecognizer(revealViewController.panGestureRecognizer());
        }
    }
    
    func updateDate(sender: DIDatepicker!){
        Utils.fadeOut(tableView,duration: 0.6);
        var formatter = NSDateFormatter();
        formatter.dateFormat = NSDateFormatter.dateFormatFromTemplate("EEEddMMM", options: 0, locale: nil);
        titles = Utils.arrayShuffle(titles);
        tableView.reloadData();
        Utils.fadeIn(tableView,duration: 0.6);
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "showCalendarDetail"){
            let row = self.tableView.indexPathForSelectedRow()?.row;
            var destViewController : CalendarDetailViewController = segue.destinationViewController as CalendarDetailViewController;
            destViewController.titleVal = titles[row!];
            destViewController.timeVal = times[row!];
            destViewController.contentVal = fullContents[row!%3];
            var dateFormat = NSDateFormatter();
            var dateStr = dateFormat.stringFromDate(datePicker.selectedDate);
            println(dateStr);
            destViewController.dateVal = dateStr;
        }
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return eventsSectionTitles.count;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var sectionTitle: String = eventsSectionTitles[section];
        var sectionEvents: [String] = events[sectionTitle]!;
        return sectionEvents.count;
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title: String = eventsSectionTitles.removeAtIndex(section);
        eventsSectionTitles.insert(title, atIndex: section);
        return title;
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        //section header view
        var sectionHeaderView: UIView = UIView();
        sectionHeaderView.frame = CGRectMake(10, 10, screen.width, 30);
        sectionHeaderView.backgroundColor = Utils.colorize(0xfafafa);
        
        
        var disciplineIcon: UIImage = UIImage(named: "wushu.png")!;
        var imageView: UIImageView = UIImageView(image: disciplineIcon);
        imageView.frame = CGRectMake(10, 5, 30, 30);
        imageView.backgroundColor = Utils.colorize(0x888888);
        imageView.layer.cornerRadius = 8;
        sectionHeaderView.addSubview(imageView);
        
        
        var title: String = eventsSectionTitles.removeAtIndex(section);
        eventsSectionTitles.insert(title, atIndex: section);
        var label: UILabel = UILabel();
        label.text = title;
        label.font = UIFont(name: "HelveticaNeue-Thin", size: 21);
        label.frame = CGRectMake(screen.width/2 - 50, 5, 100, 30);
        label.textAlignment = NSTextAlignment.Center;
        sectionHeaderView.addSubview(label);
        
        return sectionHeaderView;
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40;
    }
    
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tableId = "CalendarCell";
        var cell = tableView.dequeueReusableCellWithIdentifier(tableId) as? UITableViewCell;
        if !(cell != nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: tableId);
        }
        var title: UILabel? = cell!.viewWithTag(201) as? UILabel;
        // title?.text = titles[indexPath.row];
        //title?.font = UIFont(name: "HelveticaNeue-Light", size: 17);
        var time: UILabel? = cell!.viewWithTag(202) as? UILabel;
        time?.text = times[indexPath.row];
        time?.font = UIFont(name: "HelveticaNeue-Thin", size: 12);
        
        println(datePicker.selectedDate);
        var components: NSDateComponents = NSCalendar.currentCalendar().components(NSCalendarUnit.DayCalendarUnit, fromDate: datePicker.selectedDate);
        println(components);
        println(components.day);
       // NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
        
        
        //How to get object at index????
        var sectionTitle: String = eventsSectionTitles.removeAtIndex(indexPath.section);
        eventsSectionTitles.insert(sectionTitle, atIndex: indexPath.section);
        
        var sectionEvents: [String] = events.removeValueForKey(sectionTitle)!;
        events.updateValue(sectionEvents, forKey: sectionTitle);
        
        var event: String = sectionEvents[indexPath.row];
        
        title?.text = event;
        title?.font = UIFont(name: "HelveticaNeue-Light", size: 15);
        cell?.selectionStyle = UITableViewCellSelectionStyle.None;
        return cell!
    }
    
    
    //
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
