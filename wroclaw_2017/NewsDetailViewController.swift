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
        
       
      //  newsImage.frame.origin.x = 0;
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        
//        var scrollViewHeight: CGFloat = 0.0;
//        for view in scrollView.subviews{
//            scrollViewHeight += view.frame.size.height
//        }
//        scrollView.contentSize = CGSizeMake(320, scrollViewHeight);
        
        newsImage.frame = CGRectMake(87,0,view.frame.size.width,view.frame.size.height/3);
        newsDate.frame = CGRectMake(95, view.frame.size.height/3+2, view.frame.size.width/2, newsDate.frame.size.height);
        newsTitle.frame = CGRectMake(95, newsDate.frame.origin.y + newsDate.frame.size.height, view.frame.size.width/2, newsTitle.frame.size.height*3);
        newsContent.frame = CGRectMake(95, newsTitle.frame.origin.y + newsTitle.frame.size.height, view.frame.size.width,newsContent.frame.size.height*100);
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        //
        
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
