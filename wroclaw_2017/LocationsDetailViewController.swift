//
//  MapDetailViewController.swift
//  wroclaw_2017
//
//  Created by Szy Mas on 19/11/14.
//  Copyright (c) 2014 pl.wroclaw. All rights reserved.
//

import UIKit

class LocationsDetailViewController: UIViewController {
    @IBOutlet weak var mapImage: UIImageView!
    @IBOutlet weak var mapPlace: UILabel!
    @IBOutlet weak var mapTitle: UILabel!
    @IBOutlet weak var mapContent: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewH: NSLayoutConstraint!
    @IBOutlet weak var insideViewH: NSLayoutConstraint!
    
    var screen = UIScreen.mainScreen().bounds;
    var titleVal = "";
    var contentVal = "";
    var placeVal = "";
    var idVal = "";
    var imageVal = UIImage();
    
    
    var lat: Double = 0;
    var lng: Double = 0;
    var myLng: Double = 0;
    var myLat: Double = 0;
    
    @IBAction func openMap(sender: AnyObject) {
        println("A");
        println(lng);
        println(lat);
        println(myLng);
        println(myLat);
        
        var lngString: String = NSString(format: "%.5f", lng);
        var latString: String = NSString(format: "%.5f", lat);
        var myLngString: String = NSString(format: "%.5f", myLng);
        var myLatString: String = NSString(format: "%.5f", myLat);
        
        
        var link: NSURL = NSURL(string: "http://maps.apple.com/?sll="+myLatString+","+myLngString+",ll="+latString+","+lngString)!;
        //UIApplication.sharedApplication().openURL(link);
        println(link);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillFromSegue();
        
        //        contentLabel.text =
        
        // Do any additional setup after loading the view.
    }
    
    func fillFromSegue(){
        self.title = titleVal;
        mapTitle.text = titleVal;
        mapPlace.text = placeVal;
        mapImage.image = imageVal;
        getJSON();
    }
    
    override func viewDidAppear(animated: Bool) {
       customSetup()
    }
    
    func getJSON(){
        var url = "https://2017.wroclaw.pl/mobile/location/view/"+idVal;
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
