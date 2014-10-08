//
//  pl_wroclaw_2017Tests.m
//  pl.wroclaw.2017Tests
//
//  Created by Szy Mas on 08/10/14.
//  Copyright (c) 2014 pl.wroclaw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface pl_wroclaw_2017Tests : XCTestCase

@end

@implementation pl_wroclaw_2017Tests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
