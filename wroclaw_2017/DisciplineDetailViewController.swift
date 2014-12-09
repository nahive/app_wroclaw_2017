//
//  DisciplineDetailViewController.swift
//  wroclaw_2017
//
//  Created by Adam Mateja on 11.11.2014.
//  Copyright (c) 2014 pl.wroclaw. All rights reserved.
//

import UIKit

class DisciplineDetailViewController: UIViewController {
    
    // views
    @IBOutlet weak var disImage: UIImageView!
    @IBOutlet weak var disPlace: UILabel!
    @IBOutlet weak var disTitle: UILabel!
    @IBOutlet weak var disContent: UILabel!
    @IBOutlet weak var followSwitch: UISwitch!

    // constraints
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewH: NSLayoutConstraint!
    @IBOutlet weak var insideViewH: NSLayoutConstraint!
    
    // follow button init
    @IBAction func changeFollow(sender: AnyObject) {
        if(followSwitch.on) {
            if(NSUserDefaults.standardUserDefaults().objectForKey("disciplinesToFollow") != nil) {
                    var selectedDisciplines: [NSString] = NSUserDefaults.standardUserDefaults().objectForKey("disciplinesToFollow") as [NSString];
                    selectedDisciplines.append(titleVal);
                    NSUserDefaults.standardUserDefaults().setObject(selectedDisciplines, forKey: "disciplinesToFollow");
            } else {
                var selectedDisciplines: [NSString] = [titleVal];
                NSUserDefaults.standardUserDefaults().setObject(selectedDisciplines, forKey: "disciplinesToFollow");
            }
        } else if (followSwitch.on == false) {
            if(NSUserDefaults.standardUserDefaults().objectForKey("disciplinesToFollow") != nil) {
                if (contains(NSUserDefaults.standardUserDefaults().objectForKey("disciplinesToFollow") as [NSString], titleVal)) {
                    var index: Int = find(NSUserDefaults.standardUserDefaults().objectForKey("disciplinesToFollow") as [NSString], titleVal)!;
                    var selectedDisciplines: [NSString] = NSUserDefaults.standardUserDefaults().objectForKey("disciplinesToFollow") as [NSString];
                    selectedDisciplines.removeAtIndex(index);
                    NSUserDefaults.standardUserDefaults().setObject(selectedDisciplines, forKey: "disciplinesToFollow");
                }
            }
        }
    }
    
    
    // loading icon
    var loader = UIActivityIndicatorView();
    
    var screen = UIScreen.mainScreen().bounds;
    
    // discipline info
    var titleVal = "";
    var contentVal = "";
    var placeVal = "";
    var imageVal = "";
    var idVal = "";
    var locationVal = "";
    var followsDisciplines: [NSString] = [];
    
    ///////////////////////////////////// System functions /////////////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillFromSegue();
        hideElements();
        
        // check if discipline followed
        if(NSUserDefaults.standardUserDefaults().objectForKey("disciplinesToFollow") != nil) {
            println(NSUserDefaults.standardUserDefaults().objectForKey("disciplinesToFollow") as [NSString]);
            if (contains(NSUserDefaults.standardUserDefaults().objectForKey("disciplinesToFollow") as [NSString], titleVal)) {
                followSwitch.on = true;
            } else {
                followSwitch.on = false;
            }
        }
        
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
        getJSON();
        customSetup()
        loader.stopAnimating();
        showElements();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    ///////////////////////////////////// Custom functions /////////////////////////////////////
    
    // fill data from segue
    func fillFromSegue(){
        self.title = titleVal;
        disTitle.text = titleVal;
        disPlace.text = placeVal;
    }
    
    // hide views for transition
    func hideElements() {
        disImage.alpha = 0.0;
        disTitle.alpha = 0.0;
        disContent.alpha = 0.0;
    }
    
    // show view with animation
    func showElements() {
        Utils.fadeIn(disImage,duration: 0.3, delay: 0.0);
        Utils.fadeIn(disTitle,duration: 0.5, delay: 0.5);
        Utils.fadeIn(disContent,duration: 0.5, delay: 0.5);
    }
    
    // position views
    func customSetup(){
        disImage.frame = CGRectMake(0,0,screen.size.width, screen.size.height/3);
        disPlace.frame = CGRectMake(5, disImage.frame.origin.y + disImage.frame.height + 2, screen.size.width/2, disPlace.frame.height);
        disTitle.frame.size.width = view.frame.width*2/3;
        disContent.frame.size.width = view.frame.width - 10;
        disTitle.sizeToFit();
        disContent.sizeToFit();
        disTitle.frame.origin = CGPointMake(5, disPlace.frame.origin.y + disPlace.frame.size.height+2);
        disContent.frame.origin = CGPointMake(5, disTitle.frame.origin.y+disTitle.frame.size.height+2);
        insideViewH.constant = disImage.frame.height + disTitle.frame.height+disContent.frame.height + disPlace.frame.height + 30;
        scrollViewH.constant = view.frame.size.height;
        scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, insideViewH.constant);
        
    }
    
    ///////////////////////////////////// Server functions /////////////////////////////////////
    
    // get data from server
    func getJSON(){
        
        // lannguage check
        var url = "";
        if (NSUserDefaults.standardUserDefaults().boolForKey("PolishLanguage")) {
            url = "https://2017.wroclaw.pl/mobile/discipline/view/"+idVal;
        } else {
            url = "https://2017.wroclaw.pl/mobile/discipline/view/"+idVal+"?lang=en_US";
        }
        
        //get data
        let json = JSON(url:url);
        for (k, v) in json {
            switch k as NSString {
            case "photo":
                var url: NSURL = NSURL(string: "https://2017.wroclaw.pl/"+v.toString(pretty: true))!;
                var data: NSData = NSData(contentsOfURL: url)!;
                disImage.image = UIImage(data: data);
                break;
            case "content":
                disContent.text = v.toString(pretty: true);
            default:
                break;
            }
        }
        
    }
}
