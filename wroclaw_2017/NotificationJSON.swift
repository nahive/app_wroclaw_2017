//
//  NotificationJSON.swift
//  wroclaw_2017
//
//  Created by Szy Mas on 02/12/14.
//  Copyright (c) 2014 pl.wroclaw. All rights reserved.
//

import Foundation

public class NotificationJSON {
    
    public class func getNewsCount() -> Int {
        var dates: [String] = [];
        var url = "";
        if (NSUserDefaults.standardUserDefaults().boolForKey("PolishLanguage")) {
            url = "https://2017:twg2017wroclaw@2017.wroclaw.pl/mobile/news";
        } else {
            url = "https://2017:twg2017wroclaw@2017.wroclaw.pl/mobile/news?lang=en_US";
        }
        let json = JSON(url:url);
        return json.length;
    }
    
    public class func getEventsForDiscipline(discipline: String, eventsNum: Int) -> Int {
        var url = "";
        var events: [String] = [];
        
        if (NSUserDefaults.standardUserDefaults().boolForKey("PolishLanguage")) {
            url = "https://2017:twg2017wroclaw@2017.wroclaw.pl/mobile/event";
        } else {
            url = "https://2017:twg2017wroclaw@2017.wroclaw.pl/mobile/event?lang=en_US";
        }
        
        let json = JSON(url:url);
        
        for (k, v) in json {
            for (i,j) in v {
                switch i as NSString {
                case "sport":
                    events.append(j.toString(pretty: true));
                    break;
                default:
                    break;
                }
            }
        }
        var lastEventsCount = 0;
        for var i = events.count - 1; i > events.count - 1 - eventsNum; i-- {
            if events[i] == discipline {
                lastEventsCount++;
            }
        }
        return lastEventsCount;
    }
    
    public class func getEventsForAllDisciplines() -> Int {
        var url = "";
        if (NSUserDefaults.standardUserDefaults().boolForKey("PolishLanguage")) {
            url = "https://2017:twg2017wroclaw@2017.wroclaw.pl/mobile/event";
        } else {
            url = "https://2017:twg2017wroclaw@2017.wroclaw.pl/mobile/event?lang=en_US";
        }
        
        let json = JSON(url:url);
       return json.length
    }

    
    public class func getResultsForCountry(country: String) -> Int {
        var url = "";
    
        if (NSUserDefaults.standardUserDefaults().boolForKey("PolishLanguage")) {
            url = "https://2017:twg2017wroclaw@2017.wroclaw.pl/mobile/result";
        } else {
            url = "https://2017:twg2017wroclaw@2017.wroclaw.pl/mobile/result?lang=en_US";
        }
        
        let json = JSON(url:url);
        
        var currentCountry = "";
        var medalsCount = 0;
        for (k, v) in json {
            for (i,j) in v {
                switch i as NSString {
                case "short_name":
                    currentCountry = j.toString(pretty: true);
                    break;
                case "gold_medals":
                    if currentCountry == country {
                        medalsCount += j.asInt!;
                    }
                    break;
                case "silver_medals":
                    if currentCountry == country {
                        medalsCount += j.asInt!;
                    }
                    break;
                case "bronze_medals":
                    if currentCountry == country {
                        medalsCount += j.asInt!;
                    }
                    break;
                default:
                    break;
                }
            }
        }
        return medalsCount;
    }
    
    public class func getResultsForAllCountries() -> Int {
        var url = "";
        if (NSUserDefaults.standardUserDefaults().boolForKey("PolishLanguage")) {
            url = "https://2017:twg2017wroclaw@2017.wroclaw.pl/mobile/result";
        } else {
            url = "https://2017:twg2017wroclaw@2017.wroclaw.pl/mobile/result?lang=en_US";
        }
        
        let json = JSON(url:url);
        var medalsCount = 0;
        
        for (k, v) in json {
            for (i,j) in v {
                switch i as NSString {
                case "gold_medals":
                    medalsCount += j.asInt!;
                    break;
                case "silver_medals":
                    medalsCount += j.asInt!;
                    break;
                case "bronze_medals":
                    medalsCount += j.asInt!;
                    break;
                default:
                    break;
                }
            }
        }
        return medalsCount;
    }
}