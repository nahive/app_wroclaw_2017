//
//  wroclaw_2017Tests.swift
//  wroclaw_2017Tests
//
//  Created by nahive on 21/10/14.
//  Copyright (c) 2014 pl.wroclaw. All rights reserved.
//

import UIKit
import XCTest
import wroclaw_2017

class wroclaw_2017Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testJSON() {
        // This is an example of a functional test case.
        let json = NewsViewController();
        XCTAssertFalse(json.didDownload(), "not yet downloaded");
        json.getJSON();
        XCTAssertTrue(json.didDownload(), "downloaded");
    }
    
    func testJSONPerformance() {
        // This is an example of a performance test case.
        let json = NewsViewController();
        self.measureBlock() {
           // json.getJSON();
        }
    }
    
    func testNews(){
        let news = NewsViewController();
        XCTAssertNotNil(news.view, "view did load");
    }
    
    func testMenu(){
        let menu = MenuViewController();
        var index = NSIndexPath(forItem: 0, inSection: 0);
        menu.getTableView().selectRowAtIndexPath(index, animated: true, scrollPosition: UITableViewScrollPosition.Middle);
        XCTAssertNotNil(menu.view, "loaded");    }
    
}
