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
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var revealButtonItem: UIBarButtonItem!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mapW: NSLayoutConstraint!
    @IBOutlet weak var mapH: NSLayoutConstraint!
    
    var locationManager: CLLocationManager!
    var seenError : Bool = false
    var locationFixAchieved : Bool = false
    var locationStatus : NSString = "Not Started"

    var locationImages: [UIImage] = [];
    var locationNames: [String] = [];
    var locationsAddress: [String] = [];
    var locationLat: [Double] = [];
    var locationLng: [Double] = [];
    var locationId: [String] = [];
    var locationContent: [String] = [];
    
    var myLat: Double = 0;
    var myLng: Double = 0;
    
    var clickedAnnotation = "";
    var pageControl: UIPageControl = UIPageControl();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customSetup();
        getJSON();
        setMarkers();
        setScrollView();
        initLocationManager();
        setPageControl();
        
        //var bgImage: UIImage = UIImage(named: "wakepark_blur.jpg")!;
        //self.view.backgroundColor = UIColor(patternImage: bgImage);
        
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

    func initLocationManager() {
        mapView.showsUserLocation = true;
        seenError = false
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func setScrollView() {
        scrollView.frame = CGRectMake(view.frame.width/2 - (view.frame.width*(2/3))/2, view.frame.height*(2/3) + 20, view.frame.width*(2/3), view.frame.height*(1/3) - 50);
        scrollView.pagingEnabled = true;
        scrollView.alwaysBounceVertical = false;
        scrollView.backgroundColor = UIColor.whiteColor();
        
        // * amount of array items
        var multi : CGFloat = CGFloat(locationImages.count);
        scrollView.contentSize = CGSizeMake(view.frame.width*(2/3)*multi, view.frame.height*(1/3) - 50);
        scrollView.userInteractionEnabled = true;
        
        var numberOfImages: Int = locationImages.count - 1;
        var xPoistion: CGFloat = 0;
        
        for index in 0...numberOfImages {
            println(index);
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
    
    func imageTap(sender: UITapGestureRecognizer!){
        var orx = Int(sender.view!.frame.origin.x);
        var index =  orx / 250;
        var x : CLLocationDegrees = locationLat[index];
        var y : CLLocationDegrees = locationLng[index];
        var coords = CLLocationCoordinate2DMake(x, y);
        mapView.setCenterCoordinate(coords, animated: true)
    }

    func getJSON() {
        var url = "https://2017.wroclaw.pl/mobile/location"
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
                    var data: NSData;
                    if (NSData(contentsOfURL: url) != nil) {
                        data = NSData(contentsOfURL: url)!;
                    } else {
                        var url2: NSURL = NSURL(string: "https://2017.wroclaw.pl/upload/images/ikony-dyscyplin/powerlifting.png")!
                        data = NSData(contentsOfURL: url2)!;
                    }
                    locationImages.append(UIImage(data: data)!);
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
    
    func setPageControl(){
        pageControl.frame = CGRectMake(view.frame.width/2 - 50, view.frame.height*(2/3) + scrollView.frame.height + 20, 100, 30);
        pageControl.numberOfPages = locationNames.count;
        pageControl.currentPage = 0;
        view.addSubview(pageControl);
        pageControl.backgroundColor = UIColor.clearColor();
        pageControl.pageIndicatorTintColor = Utils.colorize(0x66ae1a);
        pageControl.currentPageIndicatorTintColor = Utils.colorize(0xf6e719);
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
                let pageW: CGFloat = scrollView.frame.width;
                let floatPageW = Float(pageW);
                let contentSize: CGFloat = self.scrollView.contentOffset.x;
                let floatContentSize = Float(contentSize);
                var fractionalPage: Float = floatContentSize / floatPageW;
                var page: Int = lroundf(fractionalPage);
                self.pageControl.currentPage = page;
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if annotation is MKUserLocation {
            return nil; }
        var myPin: MKPinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Current");
        myPin.pinColor = MKPinAnnotationColor.Red;
        myPin.backgroundColor = UIColor.clearColor();
        var detail: UIButton = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as UIButton;
        myPin.rightCalloutAccessoryView = detail;
        myPin.canShowCallout = true;
        
        return myPin;
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        var bla = view.annotation.title;
        clickedAnnotation = bla!;
        performSegueWithIdentifier("showMapDetails", sender: self);
    }
    
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
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error while updating location \(error.localizedDescription)");
    }
    
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
    
    func setMapToLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees, scale50KM: CLLocationDegrees?){
        var center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude);
        var span = MKCoordinateSpan(latitudeDelta: scale50KM!, longitudeDelta: scale50KM!);
        var region = MKCoordinateRegion(center: center, span: span);
        mapView.setRegion(region, animated: true);
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
       // mapView.frame.origin =  CGPoint(x:0, y:0);
        mapH.constant = view.frame.height*(2/3);
        mapW.constant = view.frame.width;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        locationManager.stopUpdatingLocation();
    }
    
//    func testMarkers(){
//        var point1 = MKAnnotation();
//        mapView.addAnnotation(<#annotation: MKAnnotation!#>)
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
