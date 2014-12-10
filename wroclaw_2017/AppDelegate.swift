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
        
        // custom font and view
        var font: UIFont = UIFont(name: "HelveticaNeue-Thin",size: 20.0)!;
        let navDict: NSDictionary = [NSFontAttributeName: font];
        UINavigationBar.appearance().titleTextAttributes = navDict;
        UINavigationBar.appearance().tintColor = Utils.colorize(0xffffff);
        UINavigationBar.appearance().backgroundColor = Utils.colorize(0x9e2175);
        var titleAttr = NSDictionary(objectsAndKeys: UIColor.whiteColor(), NSForegroundColorAttributeName);
        UINavigationBar.appearance().titleTextAttributes = titleAttr;
        
        // background refresh & notifications
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum);
        let settings = UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings);
        
        // default language
        if NSUserDefaults.standardUserDefaults().boolForKey("PolishLanguage") && NSUserDefaults.standardUserDefaults().boolForKey("EnglishLanguage") {
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "PolishLanguage");
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "EnglishLanguage");
        }
        
        // tab bar
        UITabBar.appearance().tintColor = Utils.colorize(0x43A417);
        return true
    }
    
    // background refresh function
    func application(application: UIApplication!, performFetchWithCompletionHandler
        completionHandler: ((UIBackgroundFetchResult) -> Void)!) {
            
            // old data counts + gathered new data counts
            var isUpdate = false;
            var news_count = NSUserDefaults.standardUserDefaults().integerForKey("news_count");
            var new_news_count = NotificationJSON.getNewsCount();
            var events_count = NSUserDefaults.standardUserDefaults().integerForKey("events_count");
            var new_events_count = NotificationJSON.getEventsForAllDisciplines();
            var results_count = NSUserDefaults.standardUserDefaults().integerForKey("medals_all_count");
            var new_results_count = NotificationJSON.getResultsForAllCountries();
            
            // news update
            if news_count < new_news_count {
                NSUserDefaults.standardUserDefaults().setInteger(new_news_count, forKey: "news_count");
                var notification = UILocalNotification();
                var now = NSDate();
                notification.fireDate = now;
                notification.alertBody = "There are new news waiting for you";
                notification.soundName = UILocalNotificationDefaultSoundName;
                notification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber+1;
                UIApplication.sharedApplication().scheduleLocalNotification(notification);
                isUpdate = true;
            }
            
            // events update for followed disciplines
            if events_count < new_events_count {
                NSUserDefaults.standardUserDefaults().setInteger(new_events_count, forKey: "events_count");
                var disciplines : [String] = NSUserDefaults.standardUserDefaults().objectForKey("disciplinesToFollow") as [String];
                for disci in disciplines {
                    if NotificationJSON.getEventsForDiscipline(disci, eventsNum: new_events_count - events_count) > 0 {
                    var notification = UILocalNotification();
                    var now = NSDate();
                    notification.fireDate = now;
                    notification.alertBody = "New event for " + disci;
                    notification.soundName = UILocalNotificationDefaultSoundName;
                    notification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber+1;
                    UIApplication.sharedApplication().scheduleLocalNotification(notification);
                    isUpdate = true;
                    }
                }
            }

            // medals update for followed countries
            if results_count < new_results_count {
                NSUserDefaults.standardUserDefaults().setInteger(new_results_count, forKey: "medals_all_count");
                var countries : [String] = NSUserDefaults.standardUserDefaults().objectForKey("countriesToFollow") as [String];
                var medals : [String: Int] = NSUserDefaults.standardUserDefaults().objectForKey("medals_count") as [String: Int];
                for disci in countries {
                    if medals[disci] == nil {
                        
                    } else {
                    if NotificationJSON.getResultsForCountry(disci) > medals[disci]! {
                        var notification = UILocalNotification();
                        var now = NSDate();
                        notification.fireDate = now;
                        notification.alertBody = "New medal for " + disci;
                        notification.soundName = UILocalNotificationDefaultSoundName;
                        notification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber+1;
                        UIApplication.sharedApplication().scheduleLocalNotification(notification);
                        isUpdate = true;
                        }
                    }
                }
            }
            
            // result if new data
            if isUpdate {
                completionHandler(UIBackgroundFetchResult.NewData);
            }
            else {
                completionHandler(UIBackgroundFetchResult.NoData);
            }
    }
    

    func applicationWillResignActive(application: UIApplication) {
    }

    // method called when app enters bg
    func applicationDidEnterBackground(application: UIApplication) {
        NSUserDefaults.standardUserDefaults().setInteger(NotificationJSON.getNewsCount(), forKey: "news_count");
        NSUserDefaults.standardUserDefaults().setInteger(NotificationJSON.getEventsForAllDisciplines(), forKey: "events_count");
        NSUserDefaults.standardUserDefaults().setInteger(NotificationJSON.getResultsForAllCountries(), forKey: "medals_all_count");
        
        // update medals for all countries
        if NSUserDefaults.standardUserDefaults().objectForKey("countriesToFollow") != nil {
            var countries = NSUserDefaults.standardUserDefaults().objectForKey("countriesToFollow") as [String];
            var medals : [String: Int] = [:];
            for country in countries {
                medals.updateValue(NotificationJSON.getResultsForCountry(country), forKey: country);
            }
            NSUserDefaults.standardUserDefaults().setObject(medals, forKey: "medals_count");
        }

    }
    
    
    func applicationWillEnterForeground(application: UIApplication) {
        UIApplication.sharedApplication().cancelAllLocalNotifications();
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0;
    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    func applicationWillTerminate(application: UIApplication) {
    }


}

