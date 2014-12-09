//
//  LocationsViewController.swift
//  wroclaw_2017
//
//  Created by Szy Mas on 05/11/14.
//  Copyright (c) 2014 pl.wroclaw. All rights reserved.
//

import UIKit
import MapKit

class LocationsViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UIScrollViewDelegate {
    
    // views
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var revealButtonItem: UIBarButtonItem!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mapW: NSLayoutConstraint!
    @IBOutlet weak var mapH: NSLayoutConstraint!
    
    // location services
    var locationManager: CLLocationManager!
    var seenError : Bool = false
    var locationFixAchieved : Bool = false
    var locationStatus : NSString = "Not Started"

    // locations server data
    var locationImages: [UIImage] = [];
    var locationNames: [String] = [];
    var locationsAddress: [String] = [];
    var locationLat: [Double] = [];
    var locationLng: [Double] = [];
    var locationId: [String] = [];
    var locationContent: [String] = [];
    
    // current location
    var myLat: Double = 0;
    var myLng: Double = 0;
    
    // loading icon
    var loader = UIActivityIndicatorView();
    var clickedAnnotation = "";
    var pageControl: UIPageControl = UIPageControl();
    
    ///////////////////////////////////// System functions /////////////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customSetup();
        
        // loader icon init
        loader = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray);
        loader.frame = CGRectMake(0,0,80,80);
        loader.center = self.view.center;
        self.view.addSubview(loader);
        loader.bringSubviewToFront(self.view);
        loader.startAnimating();
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
    }
    
    // get data from server and set positions and sizes
    override func viewDidAppear(animated: Bool) {
        mapH.constant = view.frame.height*(2/3);
        mapW.constant = view.frame.width;
        getJSON();
        setMarkers();
        setScrollView();
        initLocationManager();
        setPageControl();
        loader.stopAnimating();
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        locationManager.stopUpdatingLocation();
    }
    
    ///////////////////////////////////// Custom functions /////////////////////////////////////

    // check language
    override func viewWillAppear(animated: Bool) {
        if (NSUserDefaults.standardUserDefaults().boolForKey("PolishLanguage")) {
            self.title = "Obiekty";
        } else if (NSUserDefaults.standardUserDefaults().boolForKey("EnglishLanguage")){
            self.title = "Locations";
        }
    }
    
    // menu button setup
    func customSetup(){
        var revealViewController = self.revealViewController();
        if(revealViewController != nil){
            self.revealButtonItem.target = revealViewController;
            self.revealButtonItem.action = "revealToggle:";
            self.navigationController?.navigationBar.addGestureRecognizer(revealViewController.panGestureRecognizer());
            view.addGestureRecognizer(revealViewController.panGestureRecognizer());
        }
        
    }
    
    // start location services and settings
    func initLocationManager() {
        mapView.showsUserLocation = true;
        seenError = false
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    // scrollview with places on bottom
    func setScrollView() {
        
        //scrollview settings
        scrollView.frame = CGRectMake(view.frame.width/2 - (view.frame.width*(2/3))/2, view.frame.height*(2/3) + 20, view.frame.width*(2/3), view.frame.height*(1/3) - 50);
        scrollView.pagingEnabled = true;
        scrollView.alwaysBounceVertical = false;
        scrollView.backgroundColor = UIColor.whiteColor();
        
        // amount of array items
        var multi : CGFloat = CGFloat(locationImages.count);
        scrollView.contentSize = CGSizeMake(view.frame.width*(2/3)*multi, view.frame.height*(1/3) - 50);
        scrollView.userInteractionEnabled = true;
        
        var numberOfImages: Int = locationImages.count - 1;
        var xPoistion: CGFloat = 0;
        
        // add subviews to scrollview
        for index in 0...numberOfImages {
            var imageView: UIImageView = UIImageView(frame: CGRectMake(xPoistion, 0, view.frame.width*(2/3), view.frame.height*(1/3) - 100));
            imageView.image = locationImages[index];
            scrollView.addSubview(imageView);
            
            var singleTap = UITapGestureRecognizer(target: self, action: "imageTap:");
            singleTap.numberOfTapsRequired = 1;
            imageView.userInteractionEnabled = true;
            imageView.addGestureRecognizer(singleTap);
            
            var locationName: UILabel = UILabel(frame: CGRectMake(xPoistion + (view.frame.width*(2/3))/2 - 100, view.frame.height*(1/3) - 95, 200, 20));
            locationName.text = locationNames[index];
            locationName.font = UIFont(name: "HelveticaNeue-Thin", size: 21);
            locationName.textAlignment = NSTextAlignment.Center;
            scrollView.addSubview(locationName);
            
            var locationAddress: UILabel = UILabel(frame: CGRectMake(xPoistion + (view.frame.width*(2/3))/2 - 100, view.frame.height*(1/3) - 75, 200, 20));
            locationAddress.text = "ul. " + locationsAddress[index];
            locationAddress.font = UIFont(name: "HelveticaNeue-Thin", size: 14);
            locationAddress.textAlignment = NSTextAlignment.Center;
            scrollView.addSubview(locationAddress);
            
            xPoistion += view.frame.width*(2/3);
        }
    }
    
    // event when image tapped
    func imageTap(sender: UITapGestureRecognizer!){
        var orx = sender.view!.frame.origin.x;
        var index =  Int(orx / (view.frame.width * (2/3)));
        var x : CLLocationDegrees = locationLat[index];
        var y : CLLocationDegrees = locationLng[index];
        var coords = CLLocationCoordinate2DMake(x, y);
        mapView.setCenterCoordinate(coords, animated: true)
    }

    // set markers for locations
    func setMarkers() {
        var address: [String: String] = [:]
        var location: CLLocationCoordinate2D;
        var placeMark: MKPointAnnotation;
        for i in 0...locationId.count-1 {
            address = ["address" : locationsAddress[i]];
            location = CLLocationCoordinate2DMake(locationLat[i], locationLng[i]);
            placeMark = MKPointAnnotation();
            placeMark.setCoordinate(location);
            placeMark.title = locationNames[i];
            mapView.addAnnotation(placeMark);
        }
    }
    
    // set scrollview page control
    func setPageControl(){
        pageControl.frame = CGRectMake(view.frame.width/2 - 50, view.frame.height*(2/3) + scrollView.frame.height + 20, 100, 30);
        pageControl.numberOfPages = locationNames.count;
        pageControl.currentPage = 0;
        view.addSubview(pageControl);
        pageControl.backgroundColor = UIColor.clearColor();
        pageControl.pageIndicatorTintColor = Utils.colorize(0x66ae1a);
        pageControl.currentPageIndicatorTintColor = Utils.colorize(0xf6e719);
    }
    
    // scroll to next page function
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let pageW: CGFloat = scrollView.frame.width;
        let floatPageW = Float(pageW);
        let contentSize: CGFloat = self.scrollView.contentOffset.x;
        let floatContentSize = Float(contentSize);
        var fractionalPage: Float = floatContentSize / floatPageW;
        var page: Int = lroundf(fractionalPage);
        self.pageControl.currentPage = page;
    }
    
    // mapview settings
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        //return nil if annotation is user
        if annotation is MKUserLocation {
            return nil;
        }
        
        // annotations settings
        var myPin: MKPinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Current");
        myPin.pinColor = MKPinAnnotationColor.Red;
        myPin.backgroundColor = UIColor.clearColor();
        var detail: UIButton = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as UIButton;
        myPin.rightCalloutAccessoryView = detail;
        myPin.canShowCallout = true;
        myPin.animatesDrop = true;
        return myPin;
    }
    
    // annotation click to detailed view
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        var bla = view.annotation.title;
        clickedAnnotation = bla!;
        performSegueWithIdentifier("showMapDetails", sender: self);
    }
    
    // scroll to annotation on click and center
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        println(view.annotation.title);
        let row = find(locationNames,view.annotation.title!);
        println(UIScreen.mainScreen().bounds.width*(2/3));
        let index: CGFloat = CGFloat(row!);
        let scrollXPosition: CGFloat = UIScreen.mainScreen().bounds.width*(2/3)*index;
        scrollView.scrollRectToVisible(CGRect(x: scrollXPosition, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height), animated: true);
    }
    
    // pass data to detailed view
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "showMapDetails"){
            let row = find(locationNames,clickedAnnotation);
            println(row);
            var destViewController : LocationsDetailViewController = segue.destinationViewController as LocationsDetailViewController;
          
            destViewController.imageVal = locationImages[row!];
            destViewController.titleVal = locationNames[row!];
            destViewController.placeVal = locationsAddress[row!];
            destViewController.idVal = locationId[row!];
            destViewController.myLat = myLat;
            destViewController.myLng = myLng;
            
            
        }
    }
    
    // method if fail
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error while updating location \(error.localizedDescription)");
    }
    
    // method if updated location
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if (locationFixAchieved == false) {
            locationFixAchieved = true
            var locationArray = locations as NSArray
            var locationObj = locationArray.lastObject as CLLocation
            var coord = locationObj.coordinate
            
            myLat = coord.latitude;
            myLng = coord.longitude;
            
            setMapToLocation(coord.latitude, longitude: coord.longitude, scale50KM: 0.025)
        }
    }

    // authorize location services
    func locationManager(manager: CLLocationManager!,
        didChangeAuthorizationStatus status: CLAuthorizationStatus) {
            var shouldIAllow = false
            switch status {
            case CLAuthorizationStatus.Restricted:
                locationStatus = "Restricted Access to location"
            case CLAuthorizationStatus.Denied:
                locationStatus = "User denied access to location"
            case CLAuthorizationStatus.NotDetermined:
                locationStatus = "Status not determined"
            default:
                locationStatus = "Allowed to location Access"
                shouldIAllow = true
            }
            if (shouldIAllow == true) {
                NSLog("Location to Allowed")
                // Start location services
                locationManager.startUpdatingLocation()
            } else {
                NSLog("Denied access: \(locationStatus)")
            }
    }
    
    // animate map to location with 50km zoom
    func setMapToLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees, scale50KM: CLLocationDegrees?){
        var center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude);
        var span = MKCoordinateSpan(latitudeDelta: scale50KM!, longitudeDelta: scale50KM!);
        var region = MKCoordinateRegion(center: center, span: span);
        mapView.setRegion(region, animated: true);
    }
    
    ///////////////////////////////////// Server functions /////////////////////////////////////
    
    func getJSON() {
        
        // lannguage check
        var url = "";
        if (NSUserDefaults.standardUserDefaults().boolForKey("PolishLanguage")) {
            url = "https://2017:twg2017wroclaw@2017.wroclaw.pl/mobile/location";
        } else {
            url = "https://2017:twg2017wroclaw@2017.wroclaw.pl/mobile/location?lang=en_US";
        }
        
        let json = JSON(url:url);
        var categoryDisciplines: [String] = [];
        
        for (k, v) in json {
            for (i,j) in v {
                switch i as NSString {
                case "lat":
                    var lats : NSString  = NSString(string: j.toString(pretty: true));
                    var lat = lats.doubleValue;
                    locationLat.append(lat);
                    break;
                case "lng":
                    var lngs : NSString  = NSString(string: j.toString(pretty: true));
                    var lng = lngs.doubleValue;
                    locationLng.append(lng);
                    break;
                case "id":
                    locationId.append(j.toString(pretty: true));
                    break;
                case "photo":
                    var url: NSURL = NSURL(string: "https://2017.wroclaw.pl/"+j.toString(pretty: true))!;
                    var data: NSData? = NSData(contentsOfURL: url);
                    locationImages.append(UIImage(data: data!)!);
                    break;
                case "title":
                    locationNames.append(j.toString(pretty: true));
                    break;
                case "address":
                    locationsAddress.append(j.toString(pretty: true));
                    break;
                case "content":
                    locationContent.append(j.toString(pretty: true));
                    break;
                default:
                    break;
                }
            }
        }
    }
}
