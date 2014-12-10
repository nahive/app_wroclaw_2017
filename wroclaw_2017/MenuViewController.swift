//
//  MenuViewController.swift
//  wroclaw_2017
//
//  Created by nahive on 21/10/14.
//  Copyright (c) 2014 pl.wroclaw. All rights reserved.
//

import UIKit

public class MenuViewController: UITableViewController {
    
    ///////////////////////////////////// System functions /////////////////////////////////////
    
    override public func viewDidLoad() {
            super.viewDidLoad()
            customSetup();
    }
    
    public override func viewWillAppear(animated: Bool) {
        tableView.reloadData();
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override public func viewDidLayoutSubviews() {
        if(self.tableView.respondsToSelector("setSeparatorInset:")){
            self.tableView.separatorInset = UIEdgeInsetsZero;
        }
        if(self.tableView.respondsToSelector("setLayoutMargins:")){
            self.tableView.layoutMargins = UIEdgeInsetsZero;
        }
    }
    
    ///////////////////////////////////// Custom functions /////////////////////////////////////
    
    func customSetup(){
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "menu_bg.png"));
        self.tableView.tableFooterView = UIView(frame: CGRectZero);
        var view: UIView = UIView(frame: CGRectMake(0,-1000,320,1000));
        view.backgroundColor = UIColor.whiteColor();
        self.view.addSubview(view);
    }
    
    public override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
    
    
   ///////////////////////////////////// View functions ///////////////////////////////////////
    
    public func getTableView() -> UITableView {
        return tableView;
    }
    
    
    override public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.row == 0){
            return 95
        }
        return 55
    }
    
    override public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    override public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    override public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor();
        if(cell.respondsToSelector("setSeparatorInset:")){
            cell.separatorInset = UIEdgeInsetsZero;
        }
        if(cell.respondsToSelector("setLayoutMargins:")){
            cell.layoutMargins = UIEdgeInsetsZero;
        }
    }

    // Menu configuration + localizations
    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellId = "Cell";
        switch(indexPath.row){
        case 0:
            cellId = "logo";
            break;
        case 1:
            cellId = "news";
            break;
        case 2:
            cellId = "info";
            break;
        case 3:
            cellId = "disciplines";
            break;
        case 4:
            cellId = "calendar";
            break;
        case 5:
            cellId = "locations";
            break;
        case 6:
            cellId = "results";
            break;
        case 7:
            cellId = "settings";
            break;
        default:
            cellId = "null";
            break;
        }
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as UITableViewCell;
        
        if (NSUserDefaults.standardUserDefaults().boolForKey("PolishLanguage")) {
            var newsLabel: UILabel? = cell.viewWithTag(1) as? UILabel;
            newsLabel?.text = "Aktualności";
            var disciplineLabel: UILabel? = cell.viewWithTag(2) as? UILabel;
            disciplineLabel?.text = "Dyscypliny";
            var calendarLabel: UILabel? = cell.viewWithTag(3) as? UILabel;
            calendarLabel?.text = "Kalendarz";
            var infoLabel: UILabel? = cell.viewWithTag(4) as? UILabel;
            infoLabel?.text = "Informacje";
            var locationLabel: UILabel? = cell.viewWithTag(5) as? UILabel;
            locationLabel?.text = "Obiekty";
            var resultLabel: UILabel? = cell.viewWithTag(6) as? UILabel;
            resultLabel?.text = "Wyniki";
            var settingsLabel: UILabel? = cell.viewWithTag(7) as? UILabel;
            settingsLabel?.text = "Ustawienia";
        } else if (NSUserDefaults.standardUserDefaults().boolForKey("EnglishLanguage")) {
            var newsLabel: UILabel? = cell.viewWithTag(1) as? UILabel;
            newsLabel?.text = "News";
            var disciplineLabel: UILabel? = cell.viewWithTag(2) as? UILabel;
            disciplineLabel?.text = "Disciplines";
            var calendarLabel: UILabel? = cell.viewWithTag(3) as? UILabel;
            calendarLabel?.text = "Calendar";
            var infoLabel: UILabel? = cell.viewWithTag(4) as? UILabel;
            infoLabel?.text = "Info";
            var locationLabel: UILabel? = cell.viewWithTag(5) as? UILabel;
            locationLabel?.text = "Locations";
            var resultLabel: UILabel? = cell.viewWithTag(6) as? UILabel;
            resultLabel?.text = "Results";
            var settingsLabel: UILabel? = cell.viewWithTag(7) as? UILabel;
            settingsLabel?.text = "Settings";
        }
        return cell;
    }
}
