//
//  CalendarDetailViewController.swift
//  wroclaw_2017
//
//  Created by Szy Mas on 03/11/14.
//  Copyright (c) 2014 pl.wroclaw. All rights reserved.
//

import UIKit
import MapKit

class CalendarDetailViewController: UIViewController {
    
    // views
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventContent: UILabel!
    @IBOutlet weak var eventPlace: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    // constraints
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewH: NSLayoutConstraint!
    @IBOutlet weak var insideViewH: NSLayoutConstraint!
    
    // data for detailed view from segue
    var screen = UIScreen.mainScreen().bounds;
    var dateVal = "";
    var timeVal = "";
    var titleVal = "";
    var contentVal = "";
    var placeVal = "";
    
    ///////////////////////////////////// System functions /////////////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillFromSegue();
        hideElements();
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        customSetup();
        showElements();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    ///////////////////////////////////// Custom functions /////////////////////////////////////
    
    // hide views for transition
    func hideElements(){
        eventDate.alpha = 0.0;
        eventTime.alpha = 0.0;
        eventTitle.alpha = 0.0;
        eventContent.alpha = 0.0;
        eventPlace.alpha = 0.0;
        mapView.alpha = 0.0;
    }
    
    // show views with animation
    func showElements() {
        Utils.fadeIn(mapView,duration: 0.3, delay: 0.0);
        Utils.fadeIn(eventDate, duration: 0.5, delay: 0.5);
        Utils.fadeIn(eventTime,duration: 0.5, delay: 0.5);
        Utils.fadeIn(eventPlace,duration: 0.5, delay: 0.5);
        Utils.fadeIn(eventTitle,duration: 0.5, delay: 0.5);
        Utils.fadeIn(eventContent,duration: 0.5, delay: 0.5);
    }
    
    // fill data from segue
    func fillFromSegue(){
        self.title = titleVal;
        eventDate.text = "03 Sep";
        eventTime.text = timeVal;
        eventTitle.text = titleVal;
        eventContent.text = contentVal;
        eventPlace.text = "Plac Grunwaldzki 201";
    }
    
    // position views
    func customSetup(){
        mapView.frame = CGRectMake(0,0,screen.size.width, screen.size.height/3);
        eventDate.frame = CGRectMake(5,screen.size.height/3+10, screen.size.width/2, eventDate.frame.height);
        eventTime.frame = CGRectMake(5, eventDate.frame.origin.y +  eventDate.frame.height + 2, screen.size.width/2,eventTime.frame.height);
        eventPlace.frame = CGRectMake(5, eventTime.frame.origin.y + eventTime.frame.height + 2, screen.size.width/2, eventPlace.frame.height);
        eventTitle.frame.size.width = view.frame.width*2/3;
        eventContent.frame.size.width = view.frame.width - 10;
        eventTitle.sizeToFit();
        eventContent.sizeToFit();
        eventTitle.frame.origin = CGPointMake(5, eventPlace.frame.origin.y + eventPlace.frame.size.height+2);
        eventContent.frame.origin = CGPointMake(5, eventTitle.frame.origin.y+eventTitle.frame.size.height+2);
        insideViewH.constant = mapView.frame.height+eventDate.frame.height+eventTitle.frame.height+eventContent.frame.height + eventPlace.frame.height + eventTime.frame.height+30;
        scrollViewH.constant = view.frame.size.height;
        scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, insideViewH.constant);
        
    }
}
