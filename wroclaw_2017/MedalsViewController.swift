//
//  MedalsViewController.swift
//  wroclaw_2017
//
//  Created by Adam Mateja on 25.11.2014.
//  Copyright (c) 2014 pl.wroclaw. All rights reserved.
//

import UIKit

class MedalsViewController: UIViewController {

    @IBOutlet weak var revealButton: UIBarButtonItem!
    @IBOutlet weak var medalsIcon: UITabBarItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        customSetup();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        
    }
    
    func customSetup(){
        var revealViewController = self.revealViewController();
        if(revealViewController != nil){
            self.revealButton.target = revealViewController;
            self.revealButton.action = "revealToggle:";
            self.navigationController?.navigationBar.addGestureRecognizer(revealViewController.panGestureRecognizer());
            view.addGestureRecognizer(revealViewController.panGestureRecognizer());
        }
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
