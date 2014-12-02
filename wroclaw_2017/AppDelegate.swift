//
//  AppDelegate.swift
//  wroclaw_2017
//
//  Created by nahive on 21/10/14.
//  Copyright (c) 2014 pl.wroclaw. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        var font: UIFont = UIFont(name: "HelveticaNeue-Thin",size: 20.0)!;
        let navDict: NSDictionary = [NSFontAttributeName: font];
        UINavigationBar.appearance().titleTextAttributes = navDict;
        UINavigationBar.appearance().tintColor = Utils.colorize(0x7f7f7f);
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum);
        let settings = UIUserNotificationSettings(forTypes: .Alert, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        
        return true
    }
    
    func application(application: UIApplication!, performFetchWithCompletionHandler
        completionHandler: ((UIBackgroundFetchResult) -> Void)!) {
            println("updating");
            var news : NewsViewController = NewsViewController();
            var news_count = NSUserDefaults.standardUserDefaults().integerForKey("news_count");
            var new_news_count = news.getJSON();
            if news_count < new_news_count {
                NSUserDefaults.standardUserDefaults().setInteger(new_news_count, forKey: "news_count");
            
                UIApplication.sharedApplication().cancelAllLocalNotifications();
                var notification = UILocalNotification();
                var now = NSDate();
                notification.fireDate = now;
                notification.alertBody = "New news";
                notification.soundName = UILocalNotificationDefaultSoundName;
                notification.applicationIconBadgeNumber = notification.applicationIconBadgeNumber+1;
                UIApplication.sharedApplication().scheduleLocalNotification(notification);
                completionHandler(UIBackgroundFetchResult.NewData);
            } else {
                completionHandler(UIBackgroundFetchResult.NoData);
            }
    }
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

