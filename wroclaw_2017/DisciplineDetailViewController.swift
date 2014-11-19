//
//  DisciplineDetailViewController.swift
//  wroclaw_2017
//
//  Created by Adam Mateja on 11.11.2014.
//  Copyright (c) 2014 pl.wroclaw. All rights reserved.
//

import UIKit

class DisciplineDetailViewController: UIViewController {
    
    @IBOutlet weak var disImage: UIImageView!
    @IBOutlet weak var disPlace: UILabel!
    @IBOutlet weak var disTitle: UILabel!
    @IBOutlet weak var disContent: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewH: NSLayoutConstraint!
    @IBOutlet weak var insideViewH: NSLayoutConstraint!
    
    var screen = UIScreen.mainScreen().bounds;
    var titleVal = "";
    var contentVal = "";
    var placeVal = "";
    var imageVal = "";
    var idVal = "";
    var locationVal = "";

    override func viewDidLoad() {
        super.viewDidLoad()
        fillFromSegue();
        hideElements();
//        contentLabel.text =

        // Do any additional setup after loading the view.
    }
    
    func fillFromSegue(){
        self.title = titleVal;
        disTitle.text = titleVal;
        disPlace.text = placeVal;
        
        getJSON();
        
    }
    
    override func viewDidAppear(animated: Bool) {
        customSetup()
        showElements();
    }
    
    
    func hideElements() {
        disImage.alpha = 0.0;
        disTitle.alpha = 0.0;
        disContent.alpha = 0.0;

    }
    
    func showElements() {
        Utils.fadeIn(disImage,duration: 0.3, delay: 0.0);
        Utils.fadeIn(disTitle,duration: 0.5, delay: 0.5);
        Utils.fadeIn(disContent,duration: 0.5, delay: 0.5);
    }

    
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

    
    func getJSON(){
        var url = "https://2017.wroclaw.pl/mobile/discipline/view/"+idVal;
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
