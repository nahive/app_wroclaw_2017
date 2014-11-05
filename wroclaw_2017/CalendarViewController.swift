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
    var times: [String] = ["08:00","09:00","10:00","11:00","12:00","13:00","14:00","15:00","16:00","16:15","17:00","18:15"];
    var titles: [String] = ["Lorem ipsum dolor sit amet","consectetur adipiscing elit","Suspendisse eu lobortis diam","Donec nulla leo, sollicitudin in metus"," vitae, pulvinar eleifend elit","Maecenas vulputate enim nec turpis feugia","malesuada ac eget felis. Sed ornare lobortis tristique","Praesent consequat dui elit","eget semper mauris elementum id"," In tempus auctor turpis eu varius.","Curabitur pharetra sodales sem","et fringilla tellus semper eget."];
    var fullContents: [String] = ["Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam eleifend malesuada arcu, tincidunt feugiat leo lacinia at. Nam felis metus, scelerisque ultrices metus quis, vulputate ultricies quam. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam eleifend malesuada arcu, tincidunt feugiat leo lacinia at. Nam felis metus, scelerisque ultrices metus quis, vulputate ultricies quam. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam eleifend malesuada arcu, tincidunt feugiat leo lacinia at. Nam felis metus, scelerisque ultrices metus quis, vulputate ultricies quam. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam eleifend malesuada arcu, tincidunt feugiat leo lacinia at. Nam felis metus, scelerisque ultrices metus quis, vulputate ultricies quam. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam eleifend malesuada arcu, tincidunt feugiat leo lacinia at. Nam felis metus, scelerisque ultrices metus quis, vulputate ultricies quam.",
        "Sed eros lacus, tincidunt luctus pulvinar a, ornare quis ante. Praesent sed nibh nisi. Donec tempor sit amet sapien a euismod. Proin tempus purus gravida condimentum tempor. Sed eros lacus, tincidunt luctus pulvinar a, ornare quis ante. Praesent sed nibh nisi. Donec tempor sit amet sapien a euismod. Proin tempus purus gravida condimentum tempor. Sed eros lacus, tincidunt luctus pulvinar a, ornare quis ante. Praesent sed nibh nisi. Donec tempor sit amet sapien a euismod. Proin tempus purus gravida condimentum tempor.",
        "Duis ut nulla interdum, malesuada justo nec, posuere purus. Mauris ac porta eros. Nulla finibus nisi sit amet commodo ullamcorper. Cras mollis tempor commodo. Integer quam tellus. Duis ut nulla interdum, malesuada justo nec, posuere purus. Mauris ac porta eros. Nulla finibus nisi sit amet commodo ullamcorper. Cras mollis tempor commodo. Integer quam tellus. Duis ut nulla interdum, malesuada justo nec, posuere purus. Mauris ac porta eros. Nulla finibus nisi sit amet commodo ullamcorper. Cras mollis tempor commodo. Integer quam tellus."];
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customSetup();
        initDatePicker();
        self.tableView.alpha = 0.0;
        var scroll: UIScrollView! = datePicker.subviews[0] as UIScrollView;
        scroll.frame = CGRectMake(0, 0, view.frame.width, datePicker.frame.height);
      
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        var scroll: UIScrollView! = datePicker.subviews[0] as UIScrollView;
        scroll.frame = CGRectMake(0, 0, view.frame.width, datePicker.frame.height);
        Utils.fadeIn(tableView,duration: 0.6);
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
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tableId = "CalendarCell";
        var cell = tableView.dequeueReusableCellWithIdentifier(tableId) as? UITableViewCell;
        if !(cell != nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: tableId);
        }
        var title: UILabel? = cell!.viewWithTag(201) as? UILabel;
        title?.text = titles[indexPath.row];
        title?.font = UIFont(name: "HelveticaNeue-Light", size: 17);
        var time: UILabel? = cell!.viewWithTag(202) as? UILabel;
        time?.text = times[indexPath.row];
        time?.font = UIFont(name: "HelveticaNeue-Thin", size: 15);
        
        
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
