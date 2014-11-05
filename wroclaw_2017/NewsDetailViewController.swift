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
    @IBOutlet weak var clockImage: UIImageView!
    
    @IBOutlet weak var author: UILabel!
    
    @IBOutlet weak var newsDate: UILabel!
    @IBOutlet weak var newsContent: UILabel!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var insideView: UIView!
    
    @IBOutlet weak var scrollViewH: NSLayoutConstraint!
    @IBOutlet weak var insideViewH: NSLayoutConstraint!
    
    var screen =  UIScreen.mainScreen().bounds;
    var imageVal = "";
    var dateVal = "";
    var titleVal = "";
    var contentVal = "";
    var authorVal = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillFromSegue();
        hideElements();
    }
    
    func fillFromSegue(){
        var image : UIImage = UIImage(named: imageVal)!;
        newsImage.image = image;
        newsDate.text = dateVal;
        newsTitle.text = titleVal;
        newsContent.text = contentVal;
        author.text = "By, " + authorVal;
    }
    
    func hideElements() {
        newsImage.alpha = 0.0;
        clockImage.alpha = 0.0;
        newsDate.alpha = 0.0;
        newsTitle.alpha = 0.0;
        newsContent.alpha = 0.0;
        author.alpha = 0.0;
    }
    
    func showElements() {
        Utils.fadeIn(newsImage,duration: 0.3, delay: 0.0);
        Utils.fadeIn(newsDate,duration: 0.5, delay: 0.5);
        Utils.fadeIn(newsTitle,duration: 0.5, delay: 0.5);
        Utils.fadeIn(newsContent,duration: 0.5, delay: 0.5);
        Utils.fadeIn(clockImage,duration: 0.3, delay: 0.5);
        Utils.fadeIn(author,duration: 0.3, delay: 0.5);
    }
    
    func customSetup(){
        newsImage.frame = CGRectMake(0,-44,screen.size.width,screen.size.height/3+44);
        newsDate.frame = CGRectMake(25, screen.size.height/3+2, screen.size.width/2, newsDate.frame.size.height);
        clockImage.frame = CGRectMake(5, screen.size.height/3+6, 15, 15);
        newsContent.frame.size.width = view.frame.width-10;
        newsTitle.frame.size.width = view.frame.width*2/3;
        author.frame.size.width = view.frame.width-10;
        newsTitle.sizeToFit();
        newsContent.sizeToFit();
        newsTitle.frame.origin = CGPointMake(5, newsDate.frame.origin.y + newsDate.frame.size.height + 5);
        author.frame = CGRectMake(5, newsTitle.frame.origin.y+newsTitle.frame.size.height, screen.size.width/2, author.frame.height);
        newsContent.frame.origin = CGPointMake(5, newsTitle.frame.origin.y+newsTitle.frame.size.height+40);
        insideViewH.constant = newsImage.frame.height+newsDate.frame.height+newsTitle.frame.height+newsContent.frame.height+75;
        scrollViewH.constant = view.frame.size.height;
        scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, insideViewH.constant);
        
    }
    
    override func viewDidLayoutSubviews() {
        customSetup();
        
    }
    
    override func viewDidAppear(animated: Bool) {
        showElements();
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
