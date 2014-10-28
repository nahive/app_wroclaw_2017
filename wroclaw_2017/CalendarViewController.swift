//
//  CalendarViewController.swift
//  wroclaw_2017
//
//  Created by Szy Mas on 28/10/14.
//  Copyright (c) 2014 pl.wroclaw. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController {

  //  @IBOutlet weak var label: UILabel!
    @IBOutlet weak var datePicker: DIDatepicker!
    @IBOutlet weak var revealButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customSetup();
        initDatePicker();
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        var scroll: UIScrollView! = datePicker.subviews[0] as UIScrollView;
        scroll.frame = CGRectMake(0, 0, view.frame.width, datePicker.frame.height);
    }
    
    func initDatePicker(){
        //        datePicker.addTarget(self, action: "updateSelectedDate:", forControlEvents: UIControlEvents.ValueChanged);
        var datesrc = "20170701";
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
        }
    }
    
    func updateSelectedDate(){
        var formatter = NSDateFormatter();
        formatter.dateFormat = NSDateFormatter.dateFormatFromTemplate("EEEddMMM", options: 0, locale: nil);
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
