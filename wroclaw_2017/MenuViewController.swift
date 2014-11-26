//
//  MenuViewController.swift
//  wroclaw_2017
//
//  Created by nahive on 21/10/14.
//  Copyright (c) 2014 pl.wroclaw. All rights reserved.
//

import UIKit

public class MenuViewController: UITableViewController {
    
    override public func
        viewDidLoad() {
            super.viewDidLoad()
            customSetup();
            // Uncomment the following line to preserve selection between presentations
            // self.clearsSelectionOnViewWillAppear = false
            
            // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
            // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    public func getTableView() -> UITableView {
        return tableView;
    }
    
    public override func viewWillAppear(animated: Bool) {
        tableView.reloadData();
    }
    
    func customSetup(){
        self.tableView.backgroundColor = Utils.colorize(0x7f7f7f);
        self.tableView.tableFooterView = UIView(frame: CGRectZero);
        var view: UIView = UIView(frame: CGRectMake(0,-1000,320,1000));
        view.backgroundColor = UIColor.whiteColor();
        self.view.addSubview(view);
        
        
    }
    
    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if((sender?.isKindOfClass(UITableView)) != nil){
            
        }
    }
    
    
    public override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.row == 0){
            return 95
        }
        return 55
    }
    
    override public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
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
    
    override public func viewDidLayoutSubviews() {
        if(self.tableView.respondsToSelector("setSeparatorInset:")){
            self.tableView.separatorInset = UIEdgeInsetsZero;
        }
        if(self.tableView.respondsToSelector("setLayoutMargins:")){
            self.tableView.layoutMargins = UIEdgeInsetsZero;
        }
    }
    
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
            newsLabel?.text = "aktualności";
            var disciplineLabel: UILabel? = cell.viewWithTag(2) as? UILabel;
            disciplineLabel?.text = "dyscypliny";
            var calendarLabel: UILabel? = cell.viewWithTag(3) as? UILabel;
            calendarLabel?.text = "kalendarz";
            var infoLabel: UILabel? = cell.viewWithTag(4) as? UILabel;
            infoLabel?.text = "informacje";
            var locationLabel: UILabel? = cell.viewWithTag(5) as? UILabel;
            locationLabel?.text = "obiekty";
            var resultLabel: UILabel? = cell.viewWithTag(6) as? UILabel;
            resultLabel?.text = "wyniki";
            var settingsLabel: UILabel? = cell.viewWithTag(7) as? UILabel;
            settingsLabel?.text = "ustawienia";
        } else if (NSUserDefaults.standardUserDefaults().boolForKey("EnglishLanguage")) {
            var newsLabel: UILabel? = cell.viewWithTag(1) as? UILabel;
            newsLabel?.text = "news";
            var disciplineLabel: UILabel? = cell.viewWithTag(2) as? UILabel;
            disciplineLabel?.text = "disciplines";
            var calendarLabel: UILabel? = cell.viewWithTag(3) as? UILabel;
            calendarLabel?.text = "calendar";
            var infoLabel: UILabel? = cell.viewWithTag(4) as? UILabel;
            infoLabel?.text = "info";
            var locationLabel: UILabel? = cell.viewWithTag(5) as? UILabel;
            locationLabel?.text = "locations";
            var resultLabel: UILabel? = cell.viewWithTag(6) as? UILabel;
            resultLabel?.text = "results";
            var settingsLabel: UILabel? = cell.viewWithTag(7) as? UILabel;
            settingsLabel?.text = "settings";
        }
        
        
        return cell;
    }
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell
    
    // Configure the cell...
    
    return cell
    }
    */
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}
