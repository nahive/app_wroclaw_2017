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
        UIApplication.sharedApplication().cancelAllLocalNotifications();
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0;
        return true
    }
    
    func application(application: UIApplication!, performFetchWithCompletionHandler
        completionHandler: ((UIBackgroundFetchResult) -> Void)!) {
            println("updating");
            var isUpdate = false;
            var news_count = NSUserDefaults.standardUserDefaults().integerForKey("news_count");
            var new_news_count = NotificationJSON.getNewsCount();
            var events_count = NSUserDefaults.standardUserDefaults().integerForKey("events_count");
            var new_events_count = NotificationJSON.getEventsForAllDisciplines();
            var results_count = NSUserDefaults.standardUserDefaults().integerForKey("medals_all_count");
            var new_results_count = NotificationJSON.getResultsForAllCountries();
             println("updating news");
            if news_count != new_news_count {
                 println("new news");
                NSUserDefaults.standardUserDefaults().setInteger(new_news_count, forKey: "news_count");
             
                var notification = UILocalNotification();
                var now = NSDate();
                notification.fireDate = now;
                notification.alertBody = "There are new news waiting for you";
                notification.soundName = UILocalNotificationDefaultSoundName;
                notification.applicationIconBadgeNumber = notification.applicationIconBadgeNumber+1;
                UIApplication.sharedApplication().scheduleLocalNotification(notification);
                isUpdate = true;
            }
             println("updating events");
            if events_count != new_events_count {
                 println("new events");
                NSUserDefaults.standardUserDefaults().setInteger(new_events_count, forKey: "events_count");
                var disciplines : [String] = NSUserDefaults.standardUserDefaults().objectForKey("disciplinesToFollow") as [String];
                for disci in disciplines {
                    if NotificationJSON.getEventsForDiscipline(disci, eventsNum: new_events_count - events_count) > 0 {
                    var notification = UILocalNotification();
                    var now = NSDate();
                    notification.fireDate = now;
                    notification.alertBody = "New event for " + disci;
                    notification.soundName = UILocalNotificationDefaultSoundName;
                    notification.applicationIconBadgeNumber = notification.applicationIconBadgeNumber+1;
                    UIApplication.sharedApplication().scheduleLocalNotification(notification);
                    isUpdate = true;
                    }
                }
            }
            println(results_count);
            println(new_results_count);
             println("updating medals");
            if results_count != new_results_count {
                 println("new medals");
                NSUserDefaults.standardUserDefaults().setInteger(new_results_count, forKey: "medals_all_count");
                var countries : [String] = NSUserDefaults.standardUserDefaults().objectForKey("countriesToFollow") as [String];
                var medals : [String: Int] = NSUserDefaults.standardUserDefaults().objectForKey("medals_count") as [String: Int];
                for disci in countries {
                    if medals[disci] == nil {
                        println("nil for" + disci);
                    } else {
                    if NotificationJSON.getResultsForCountry(disci) > medals[disci]! {
                        var notification = UILocalNotification();
                        var now = NSDate();
                        notification.fireDate = now;
                        notification.alertBody = "New medal for " + disci;
                        notification.soundName = UILocalNotificationDefaultSoundName;
                        notification.applicationIconBadgeNumber = notification.applicationIconBadgeNumber+1;
                        UIApplication.sharedApplication().scheduleLocalNotification(notification);
                        isUpdate = true;
                        }
                    }
                }
            }
            println("done");
            if isUpdate {
                completionHandler(UIBackgroundFetchResult.NewData);
            }
            else {
                completionHandler(UIBackgroundFetchResult.NoData);
            }
    }
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        println("entered bg");
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        NSUserDefaults.standardUserDefaults().setInteger(NotificationJSON.getNewsCount(), forKey: "news_count");
        NSUserDefaults.standardUserDefaults().setInteger(NotificationJSON.getEventsForAllDisciplines(), forKey: "events_count");
        NSUserDefaults.standardUserDefaults().setInteger(NotificationJSON.getResultsForAllCountries(), forKey: "medals_all_count");
        var countries = NSUserDefaults.standardUserDefaults().objectForKey("countriesToFollow") as [String];
        var medals : [String: Int] = [:];
        for country in countries {
            medals.updateValue(NotificationJSON.getResultsForCountry(country), forKey: country);
        }
        NSUserDefaults.standardUserDefaults().setObject(medals, forKey: "medals_count");
        
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

