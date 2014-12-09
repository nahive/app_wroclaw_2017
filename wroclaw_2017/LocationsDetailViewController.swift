//
//  MapDetailViewController.swift
//  wroclaw_2017
//
//  Created by Szy Mas on 19/11/14.
//  Copyright (c) 2014 pl.wroclaw. All rights reserved.
//

import UIKit

class LocationsDetailViewController: UIViewController {
    
    // views
    @IBOutlet weak var mapImage: UIImageView!
    @IBOutlet weak var mapPlace: UILabel!
    @IBOutlet weak var mapTitle: UILabel!
    @IBOutlet weak var mapContent: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // constraints
    @IBOutlet weak var scrollViewH: NSLayoutConstraint!
    @IBOutlet weak var insideViewH: NSLayoutConstraint!
    
    // data from segue
    var screen = UIScreen.mainScreen().bounds;
    var titleVal = "";
    var contentVal = "";
    var placeVal = "";
    var idVal = "";
    var imageVal = UIImage();
    
    // latitude of object
    var lat: Double = 0;
    var lng: Double = 0;

    // latitude of my location
    var myLng: Double = 0;
    var myLat: Double = 0;
    
    // open navigation to location
    @IBAction func openMap(sender: AnyObject) {
        
        // convert locations to strings
        var lngString: String = NSString(format: "%.5f", lng);
        var latString: String = NSString(format: "%.5f", lat);
        var myLngString: String = NSString(format: "%.5f", myLng);
        var myLatString: String = NSString(format: "%.5f", myLat);
        
        // url to navigation
        var url: String = "http://maps.apple.com/?daddr=%28"+latString;
        url += ",%20";
        url += lngString;
        url += "%29&saddr=%28";
        url += myLatString;
        url += ",%20";
        url += myLngString;
        url += "%29";
        var link: NSURL = NSURL(string: url)!;
        UIApplication.sharedApplication().openURL(link);
        
    }
    
    ///////////////////////////////////// System functions /////////////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillFromSegue();
    }
    
    override func viewDidAppear(animated: Bool) {
       customSetup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    ///////////////////////////////////// Custom functions /////////////////////////////////////
    
    // fill data from segue
    func fillFromSegue(){
        self.title = titleVal;
        mapTitle.text = titleVal;
        mapPlace.text = placeVal;
        mapImage.image = imageVal;
        getJSON();
    }
    
    // position views
    func customSetup(){
        mapImage.frame = CGRectMake(0,0,screen.size.width, screen.size.height/3);
        mapPlace.frame = CGRectMake(5, mapImage.frame.origin.y + mapImage.frame.height + 2, screen.size.width/2, mapPlace.frame.height);
        mapTitle.frame.size.width = view.frame.width*2/3;
        mapContent.frame.size.width = view.frame.width - 10;
        mapTitle.sizeToFit();
        mapContent.sizeToFit();
        mapTitle.frame.origin = CGPointMake(5, mapPlace.frame.origin.y + mapPlace.frame.size.height+2);
        mapContent.frame.origin = CGPointMake(5, mapTitle.frame.origin.y+mapTitle.frame.size.height+2);
        insideViewH.constant = mapImage.frame.height + mapTitle.frame.height+mapContent.frame.height + mapPlace.frame.height + 30;
        scrollViewH.constant = view.frame.size.height;
        scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, insideViewH.constant);
    }


    ///////////////////////////////////// Server functions /////////////////////////////////////
    
    // get data from server
    func getJSON(){
        
        // language check
        var url = "";
        if (NSUserDefaults.standardUserDefaults().boolForKey("PolishLanguage")) {
            url = "https://2017:twg2017wroclaw@2017.wroclaw.pl/mobile/location/view/"+idVal;
        } else {
            url = "https://2017:twg2017wroclaw@2017.wroclaw.pl/mobile/location/view/" + idVal + "?lang=en_US";
        }
        let json = JSON(url:url);
        
        for (k, v) in json {
            switch k as NSString {
            case "content":
                mapContent.text = v.toString(pretty: true);
                break;
            case "lat":
                lat = v.asNumber!;
                break;
            case "lng":
                lng = v.asNumber!;
                break;
            default:
                break;
            }
        }
        
    }


}
