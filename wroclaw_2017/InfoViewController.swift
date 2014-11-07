//
//  InfoViewController.swift
//  wroclaw_2017
//
//  Created by Szy Mas on 05/11/14.
//  Copyright (c) 2014 pl.wroclaw. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    var infoHeaders : [String] = [];
    var infoContents : [String] = [];
    var infoTitle : String = "";
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var insideView: UIView!
    
    @IBOutlet weak var scrollViewH: NSLayoutConstraint!
    @IBOutlet weak var insideViewH: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = infoTitle;
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        loadContents();
    }
    
    func loadContents(){
        for var i = 0; i < infoHeaders.count; i++ {
            var height = countViewsHeight();
            var label = UILabel(frame: CGRectMake(0, 0, view.frame.width - 10, 100));
            label.font = UIFont(name: "HelveticaNeue-Bold", size: 25);
            label.numberOfLines = 3;
            label.text = infoHeaders[i];
            label.sizeToFit();
            label.frame = CGRect(x: 5, y: height+10, width: view.frame.width-10, height: label.frame.height);
            insideView.addSubview(label);
            var content = UILabel(frame: CGRectMake(0, 0, view.frame.width - 10, 100));
            content.font = UIFont(name: "HelveticaNeue-Light", size: 15);
            content.numberOfLines = 100;
            content.text = infoContents[i];
            content.sizeToFit();
            content.frame = CGRect(x: 5, y: label.frame.origin.y + label.frame.height-20, width: view.frame.width-10, height: content.frame.height+80);
            insideView.addSubview(content);
        }
        
        insideViewH.constant = countViewsHeight();
        scrollViewH.constant = view.frame.size.height;
        scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, insideViewH.constant);
        
    }
    
    func countViewsHeight() -> CGFloat {
        var h : CGFloat = 0;
        for v in insideView.subviews {
            h += v.frame.size.height;
        }
        return h;
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
