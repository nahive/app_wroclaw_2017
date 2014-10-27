//
//  NewsDetailViewController.swift
//  wroclaw_2017
//
//  Created by nahive on 22/10/14.
//  Copyright (c) 2014 pl.wroclaw. All rights reserved.
//

import UIKit

class NewsDetailViewController: UIViewController {
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsDate: UILabel!
    @IBOutlet weak var newsContent: UILabel!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var V: NSLayoutConstraint!
 
    var screen =  UIScreen.mainScreen().bounds;
    var imageVal = "";
    var dateVal = "";
    var titleVal = "";
    var contentVal = "";
    

    override func viewDidLoad() {
        super.viewDidLoad()
        var image : UIImage = UIImage(named: imageVal)!;
        newsImage.image = image;
        newsDate.text = dateVal;
        newsTitle.text = titleVal;
        newsContent.text = contentVal;
       
    }
    
    func customSetup(){
//        view.backgroundColor = UIColor.greenColor()
//        scrollView.backgroundColor = UIColor.redColor()
        
        newsImage.frame = CGRectMake(0,0,screen.size.width,screen.size.height/3);
        newsDate.frame = CGRectMake(5, screen.size.height/3+2, screen.size.width/2, newsDate.frame.size.height);
        newsTitle.frame = CGRectMake(5, newsDate.frame.origin.y + newsDate.frame.size.height, screen.size.width/2, newsTitle.frame.size.height*3);
        newsContent.frame = CGRectMake(5, newsTitle.frame.origin.y + newsTitle.frame.size.height - newsTitle.frame.size.height/4, screen.size.width,newsContent.frame.size.height*25);
        V.constant = newsImage.frame.height+newsDate.frame.height+newsTitle.frame.height+newsContent.frame.height;
        scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, V.constant);
        scrollView.clipsToBounds = false;
    }
    
    override func viewDidLayoutSubviews() {
      
    }
    
    override func viewDidAppear(animated: Bool) {
         customSetup();
    }
    
    override func viewWillAppear(animated: Bool) {
        
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
