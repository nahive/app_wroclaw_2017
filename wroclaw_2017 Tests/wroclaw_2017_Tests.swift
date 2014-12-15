//
//  wroclaw_2017_Tests.swift
//  wroclaw_2017 Tests
//
//  Created by Szy Mas on 10/12/14.
//  Copyright (c) 2014 pl.wroclaw. All rights reserved.
//

import UIKit
import XCTest
import wroclaw_2017

class wroclaw_2017_Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
//    func testJSON() {
//        // This is an example of a functional test case.
//        let json = NewsViewController();
//        XCTAssertFalse(json.didDownload(), "not yet downloaded");
//        json.getJSON();
//        XCTAssertTrue(json.didDownload(), "downloaded");
//    }
//    
//    func testJSONPerformance() {
//        // This is an example of a performance test case.
//        let json = NewsViewController();
//        self.measureBlock() {
//            var bla = json.getJSON();
//        }
//    }
//    
//    func testNews(){
//        let news = NewsViewController();
//        XCTAssertNotNil(news.view, "view did load");
//    }
//    
//    func testMenu(){
//        let menu = MenuViewController();
//        var index = NSIndexPath(forItem: 0, inSection: 0);
//        menu.getTableView().selectRowAtIndexPath(index, animated: true, scrollPosition: UITableViewScrollPosition.Middle);
//        XCTAssertNotNil(menu.view, "loaded");    }
////    
//    func testJSONNotifications(){
//        let view = NewsViewController();
//    }
//
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
}
