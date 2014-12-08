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
    var icons: [String : [UIImage]] = ["" : []];
    var events: [String: [String : [[String : String]]]] = ["" : ["" : []]];
    
    
    var allTimes: [String] = [];
    var allEvents: [String] = [];
    var allSubevents: [String] = [];
    var allNames: [String] = [];
    var allId: [String] = [];
   
    
    
    
    
    
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
            self.title = "Kalendarz";
        } else {
            url = "https://2017:twg2017wroclaw@2017.wroclaw.pl/mobile/schedule?lang=en_US";
            self.title = "Calendar";
        }
        
        
        
        // if (NSUserDefaults.standardUserDefaults().objectForKey("newsJSON") != nil) {
        //  var json = NSUserDefaults.standardUserDefaults().objectForKey("newsJSON");
        //} else {
        let json = JSON(url:url);
        //}
        
        //NSUserDefaults.standardUserDefaults().setObject(json, forKey: "newsJSON");
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
        formatter.dateFormat = NSDateFormatter.dateFormatFromTemplate("EEEddMMM", options: 0, locale: nil)
        tableView.reloadData();
        Utils.fadeIn(tableView,duration: 0.6);
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "showCalendarDetail"){
            let row = self.tableView.indexPathForSelectedRow()?.row;
            var destViewController : CalendarDetailViewController = segue.destinationViewController as CalendarDetailViewController;
            var cell: UITableViewCell = tableView.cellForRowAtIndexPath(self.tableView.indexPathForSelectedRow()!)!;
            var id: UILabel = cell.viewWithTag(203) as UILabel;
            println(id.text);
            println(allId);
            var index: Int = find(allId, id.text!)!;
            println(index);
            
            
            destViewController.titleVal = allEvents[index];
            destViewController.timeVal = allTimes[index];
            var dateFormat = NSDateFormatter();
            var dateStr = dateFormat.stringFromDate(datePicker.selectedDate);
            destViewController.dateVal = dateStr;
        }
    }
    
    
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
        
        
        
        var imageView: UIImageView = UIImageView(image: icon);
        imageView.frame = CGRectMake(10, 5, 30, 30);
        imageView.backgroundColor = Utils.colorize(0x888888);
        imageView.layer.cornerRadius = 8;
        sectionHeaderView.addSubview(imageView);
        
        
        
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
        
        println(id?.text);
        
        title?.font = UIFont(name: "HelveticaNeue-Light", size: 15);
        time?.font = UIFont(name: "HelveticaNeue-Thin", size: 12);
        
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
