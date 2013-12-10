//
//  NAKAssertTest.m
//  NeetAssertionKit
//
//  Created by daichi on 2013/12/10.
//  Copyright (c) 2013年 neethouse.org. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "NAKAssertions.h"


@interface NAKAssertTest : XCTestCase

@end

@implementation NAKAssertTest

- (void)setUp {
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown {
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)test {
    
    BOOL falseValue = NO;
    
    BOOL throwed = NO;
    
    @try {
        
        NAKAssertTrue(falseValue, @"str:%@, i:%d", @"ほむほむ", 501);
        
    } @catch (NSException *exception) {
        throwed = YES;
        
        XCTAssertEqualObjects(exception.reason, @"str:ほむほむ, i:501", @"");
        
    } @finally {
        XCTAssertTrue(throwed, @"");
    }

}

@end
