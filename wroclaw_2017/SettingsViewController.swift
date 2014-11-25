//
//  SettingsViewController.swift
//  wroclaw_2017
//
//  Created by Adam Mateja on 22.11.2014.
//  Copyright (c) 2014 pl.wroclaw. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    

    @IBOutlet weak var revealButton: UIBarButtonItem!
    @IBOutlet weak var settingsDone: UIButton!


    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customSetup();
        if (NSUserDefaults.standardUserDefaults().boolForKey("FirstLaunch")) {
            revealButton.image = UIImage(named: "reveal-icon.png");
            revealButton.enabled = true;
            settingsDone.hidden = true;
        } else {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "FirstLaunch");
            NSUserDefaults.standardUserDefaults().synchronize();
            revealButton.style = UIBarButtonItemStyle.Plain;
            revealButton.enabled = false;
            revealButton.image = nil;            
        }
        customSetup();
        
        
            
        
        // Do any additional setup after loading the view.
    }
    
    
    func customSetup(){
        var revealViewController = self.revealViewController();
        if(revealViewController != nil){
            self.revealButton.target = revealViewController;
            self.revealButton.action = "revealToggle:";
            self.navigationController?.navigationBar.addGestureRecognizer(revealViewController.panGestureRecognizer());
            view.addGestureRecognizer(revealViewController.panGestureRecognizer());
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4;
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellId = "Cell";
        switch(indexPath.row){
        case 0:
            cellId = "language";
            break;
        case 1:
            cellId = "follow";
            break;
        case 2:
            cellId = "countries";
            break;
        case 3:
            cellId = "participants";
            break;
        default:
            cellId = "null";
            break;
        }
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as UITableViewCell;
        
        var languageLabel: UILabel? = cell.viewWithTag(101) as? UILabel;
        var numberOfCountries: UILabel? = cell.viewWithTag(102) as? UILabel;
        var numberOfDisciplines: UILabel? = cell.viewWithTag(103) as? UILabel;
        
        if (NSUserDefaults.standardUserDefaults().boolForKey("PolishLanguage")) {
            languageLabel?.text = "Polski";
        } else if (NSUserDefaults.standardUserDefaults().boolForKey("EnglishLanguage")) {
            languageLabel?.text = "English";
        } else {
            languageLabel?.text = "";
        }
        
        if (NSUserDefaults.standardUserDefaults().objectForKey("disciplinesToFollow") != nil) {
            
            var amoutOfDisciplines: String = String((NSUserDefaults.standardUserDefaults().objectForKey("disciplinesToFollow") as [NSString]).count);
            if (amoutOfDisciplines == "0") {
                numberOfDisciplines?.text = "";
            } else {
                numberOfDisciplines?.text = amoutOfDisciplines;
            }
        } else {
            numberOfDisciplines?.text = "";
        }
        
        if (NSUserDefaults.standardUserDefaults().objectForKey("countriesToFollow") != nil) {
            var amoutOfCountries: String = String((NSUserDefaults.standardUserDefaults().objectForKey("countriesToFollow") as [NSString]).count);
            if (amoutOfCountries == "0") {
                numberOfCountries?.text = "";
            } else {
                numberOfCountries?.text = amoutOfCountries;
            }
        } else {
            numberOfCountries?.text = "";
        }
        
        
        
        return cell;
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "countries"){
            //let row = self.tableView.indexPathForSelectedRow()?.row;
            var destViewController : SelectFollowTableViewController = segue.destinationViewController as SelectFollowTableViewController;
            destViewController.contentValue = "countries";
        } else if(segue.identifier == "disciplines") {
            var destViewController : SelectFollowTableViewController = segue.destinationViewController as SelectFollowTableViewController;
            destViewController.contentValue = "disciplines";
        }
        
        
    }
    

}
