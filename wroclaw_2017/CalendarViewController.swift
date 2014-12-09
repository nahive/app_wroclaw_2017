//
//  CalendarViewController.swift
//  wroclaw_2017
//
//  Created by Szy Mas on 28/10/14.
//  Copyright (c) 2014 pl.wroclaw. All rights reserved.
//

import UIKit


class CalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // views
    @IBOutlet weak var datePicker: DIDatepicker!
    @IBOutlet weak var revealButtonItem: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var datePickerW: NSLayoutConstraint!
    
    var screen =  UIScreen.mainScreen().bounds;

    // data for views
    var icons: [String : [UIImage]] = ["" : []];
    var events: [String: [String : [[String : String]]]] = ["" : ["" : []]];
    var allTimes: [String] = [];
    var allEvents: [String] = [];
    var allSubevents: [String] = [];
    var allNames: [String] = [];
    var allId: [String] = [];
    
    // sort function
    func backwards(s1: String, s2: String) -> Bool {
        return s1 > s2
    }
    
    // loading icon
    var loader = UIActivityIndicatorView();
    
    ///////////////////////////////////// System functions /////////////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customSetup();
        
        // slide calendar picker init
        initDatePicker();
        
        // customize slide calendar view
        self.tableView.alpha = 0.0;
        var scroll: UIScrollView! = datePicker.subviews[0] as UIScrollView;
        scroll.frame = CGRectMake(0, 0, view.frame.width, datePicker.frame.height);
        
        // loading icon
        loader = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray);
        loader.frame = CGRectMake(0,0,80,80);
        loader.center = self.view.center;
        self.view.addSubview(loader);
        loader.bringSubviewToFront(self.view);
        loader.startAnimating();
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // check language
        if (NSUserDefaults.standardUserDefaults().boolForKey("PolishLanguage")) {
            self.title = "Kalendarz";
        } else if (NSUserDefaults.standardUserDefaults().boolForKey("EnglishLanguage")){
            self.title = "Calendar";
        }
    }

    override func viewDidAppear(animated: Bool) {
        // get data from view
        getJSON();
        tableView.reloadData();
        
        // init scroll and fade in
        loader.stopAnimating();
        var scroll: UIScrollView! = datePicker.subviews[0] as UIScrollView;
        scroll.frame = CGRectMake(0, 0, view.frame.width, datePicker.frame.height);
        Utils.fadeIn(tableView,duration: 0.6);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    ///////////////////////////////////// Custom functions /////////////////////////////////////
    
    // slide date picker settings and date format
    func initDatePicker(){
        datePickerW.constant = view.frame.width;
        datePicker.addTarget(self, action: "updateDate:", forControlEvents: UIControlEvents.ValueChanged);
        
        // date format and time
        var datesrc = "20170803";
        var dateformat = NSDateFormatter();
        dateformat.dateFormat = "yyyyMMdd";
        var date = dateformat.dateFromString(datesrc);
        datePicker.fillDatesFromDate(date, numberOfDays: 14);
        datePicker.selectDateAtIndex(0);
    }
    
    // menu button setup
    func customSetup(){
        var revealViewController = self.revealViewController();
        if(revealViewController != nil){
            self.revealButtonItem.target = revealViewController;
            self.revealButtonItem.action = "revealToggle:";
            self.navigationController?.navigationBar.addGestureRecognizer(revealViewController.panGestureRecognizer());
            view.addGestureRecognizer(revealViewController.panGestureRecognizer());
        }
    }
    
    // update info for picked date
    func updateDate(sender: DIDatepicker!){
        Utils.fadeOut(tableView,duration: 0.6);
        var formatter = NSDateFormatter();
        formatter.dateFormat = NSDateFormatter.dateFormatFromTemplate("EEEddMMM", options: 0, locale: nil)
        tableView.reloadData();
        Utils.fadeIn(tableView,duration: 0.6);
    }
    
    
    ///////////////////////////////////// View functions ///////////////////////////////////////
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var selectedDay = 0;
        if (datePicker.selectedDate == nil) {
            selectedDay = 3;
        } else {
            var components: NSDateComponents = NSCalendar.currentCalendar().components(NSCalendarUnit.DayCalendarUnit, fromDate: datePicker.selectedDate);
            selectedDay = components.day;
        }
        
        for (k, v) in events {
            var currentDayString: NSString = k as NSString;
            var currentDay: Int = Int(currentDayString.intValue);
            if (currentDay == selectedDay) {
                return (events[currentDayString]?.count)!;
            }
        }
        return 0;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
        
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var selectedDay = 0;
        if (datePicker.selectedDate == nil) {
            selectedDay = 3;
        } else {
            var components: NSDateComponents = NSCalendar.currentCalendar().components(NSCalendarUnit.DayCalendarUnit, fromDate: datePicker.selectedDate);
            selectedDay = components.day;
        }
        
        for (k, v) in events {
            var currentDayString: NSString = k as NSString;
            var currentDay: Int = Int(currentDayString.intValue);
            if (currentDay == selectedDay) {
                var eventsInSection: [String : [[String : String]]] = events[currentDayString]!;
                var counter: Int = 0;
                for (i,j) in v {
                    if (counter == section) {
                        return (eventsInSection[i]?.count)!;
                    } else {
                        counter++;
                    }
                }
            }
        }
        return 0;
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var selectedDay = 0;
        if (datePicker.selectedDate == nil) {
            selectedDay = 3;
        } else {
            var components: NSDateComponents = NSCalendar.currentCalendar().components(NSCalendarUnit.DayCalendarUnit, fromDate: datePicker.selectedDate);
            selectedDay = components.day;
        }
        
        var sectionTitle: String = "";
        var icon: UIImage = UIImage();
        
        for (k, v) in events {
            var currentDayString: NSString = k as NSString;
            var currentDay: Int = Int(currentDayString.intValue);
            if (currentDay == selectedDay) {
                var eventsInSection: [String : [[String : String]]] = events[currentDayString]!;
                var iconsForDay: [UIImage] = icons[currentDayString]!;
                icon = iconsForDay[section];
                var counter: Int = 0;
                for (i,j) in v {
                    if (counter == section) {
                        sectionTitle = i;
                    } else {
                        counter++;
                    }
                }
            }
        }
        
        //section header view
        var sectionHeaderView: UIView = UIView();
        sectionHeaderView.frame = CGRectMake(10, 10, screen.width, 30);
        sectionHeaderView.backgroundColor = Utils.colorize(0xfafafa);
        
        // image view
        var imageView: UIImageView = UIImageView(image: icon);
        imageView.frame = CGRectMake(10, 5, 30, 30);
        imageView.backgroundColor = Utils.colorize(0x888888);
        imageView.layer.cornerRadius = 8;
        sectionHeaderView.addSubview(imageView);
        
        // label view
        var label: UILabel = UILabel();
        label.text = sectionTitle;
        label.font = UIFont(name: "HelveticaNeue-Thin", size: 21);
        label.frame = CGRectMake(screen.width/2 - 100, 5, 200, 30);
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
        
        var selectedDay = 0;
        if (datePicker.selectedDate == nil) {
            selectedDay = 3;
        } else {
            var components: NSDateComponents = NSCalendar.currentCalendar().components(NSCalendarUnit.DayCalendarUnit, fromDate: datePicker.selectedDate);
            selectedDay = components.day;
        }
        
        var sectionTitle: String = "";
        var icon: UIImage = UIImage();
        var title: UILabel? = cell!.viewWithTag(201) as? UILabel;
        var time: UILabel? = cell!.viewWithTag(202) as? UILabel;
        var id: UILabel? = cell!.viewWithTag(203) as? UILabel;
        
        for (k, v) in events {
            var currentDayString: NSString = k as NSString;
            var currentDay: Int = Int(currentDayString.intValue);
            if (currentDay == selectedDay) {
                var eventsInSection: [String : [[String : String]]] = events[currentDayString]!;
                var counter: Int = 0;
                for (i,j) in v {
                    if (counter == indexPath.section) {
                        var currentDisciplineString: NSString = i as NSString;
                        var eventsInDiscipline: [[String : String]] = eventsInSection[currentDisciplineString]!;
                        var particularEvent: [String : String] = eventsInDiscipline[indexPath.row];
                        time?.text = particularEvent["time"];
                        title?.text = particularEvent["event"]! + ", " + particularEvent["name"]!;
                        id?.text = particularEvent["id"];
                    } else {
                        counter++;
                    }
                }
            }
        }
        
        
        title?.font = UIFont(name: "HelveticaNeue-Light", size: 15);
        time?.font = UIFont(name: "HelveticaNeue-Thin", size: 12);
        
        return cell!
    }
    
    ///////////////////////////////////// Server functions /////////////////////////////////////
    
    func getJSON() {
        var url = "";
        if (NSUserDefaults.standardUserDefaults().boolForKey("PolishLanguage")) {
            url = "https://2017:twg2017wroclaw@2017.wroclaw.pl/mobile/schedule";
            self.title = "Kalendarz";
        } else {
            url = "https://2017:twg2017wroclaw@2017.wroclaw.pl/mobile/schedule?lang=en_US";
            self.title = "Calendar";
        }
        
        let json = JSON(url:url);
        
        // clear arrays
        events.removeAll(keepCapacity: true);
        var eventsForDiscipline: [String: String] = ["" : ""];
        var disciplinesContainer: [String : [[String :  String]]] = ["" :[]];
        var oneDisciplineContainer: [[String : String]] = [];
        var iconsForDay: [UIImage] = [];
        for (k, v) in json {
            var currentDayString: NSString = k as NSString;
            var currentDay: Int = Int(currentDayString.intValue);
            for (i,j) in v {
                var currentDiscipline: String = i as NSString;
                disciplinesContainer.removeAll(keepCapacity: true);
                for (l, m) in j {
                    switch l as NSString {
                    case "schedules":
                        for (n, o) in m {
                            for (p, r) in o {
                                switch p as NSString {
                                case "subevent":
                                    eventsForDiscipline.updateValue(r.toString(pretty: true), forKey: p as NSString);
                                    allSubevents.append(r.toString(pretty: true));
                                    break;
                                case "id":
                                    eventsForDiscipline.updateValue(r.toString(pretty: true), forKey: p as NSString);
                                    allId.append(r.toString(pretty: true));
                                    break;
                                case "name":
                                    eventsForDiscipline.updateValue(r.toString(pretty: true), forKey: p as NSString);
                                    allNames.append(r.toString(pretty: true));
                                    break;
                                case "time":
                                    eventsForDiscipline.updateValue(r.toString(pretty: true), forKey: p as NSString);
                                    allTimes.append(r.toString(pretty: true));
                                    break;
                                case "event":
                                    eventsForDiscipline.updateValue(r.toString(pretty: true), forKey: p as NSString);
                                    allEvents.append(r.toString(pretty: true));
                                    break;
                                default:
                                    break;
                                }
                                
                            }
                            println(eventsForDiscipline);
                            oneDisciplineContainer.append(eventsForDiscipline);
                            eventsForDiscipline.removeAll(keepCapacity: true);
                        }
                        
                        break;
                    case "icon":
                        var url: NSURL = NSURL(string: "https://2017.wroclaw.pl/"+m.toString(pretty: true))!;
                        var data: NSData = NSData(contentsOfURL: url)!;
                        iconsForDay.append(UIImage(data: data)!);
                        break;
                    default:
                        break;
                    }
                    
                }
                disciplinesContainer.updateValue(oneDisciplineContainer, forKey: currentDiscipline);
                oneDisciplineContainer.removeAll(keepCapacity: true);
                events.updateValue(disciplinesContainer, forKey: currentDayString);
                icons.updateValue(iconsForDay, forKey: currentDayString);
                iconsForDay.removeAll(keepCapacity: true);
                
            }
            
        }
        
        
    }
    
}
