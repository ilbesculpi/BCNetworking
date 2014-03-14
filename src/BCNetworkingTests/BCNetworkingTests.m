//
//  BCNetworkingTests.m
//  BCNetworkingTests
//
//  Created by Ilbert Esculpi on 3/14/14.
//  Copyright (c) 2014 Ilbert Esculpi. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "BCNetworking.h"

@interface BCNetworkingTests : XCTestCase

@end


@implementation BCNetworkingTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


-(void)testSimpleGet {
	__block BOOL done = NO;
	BCConnection *connection = [[BCConnection alloc] init];
	[connection GET:@"http://localhost/simple-text.txt" parameters:nil success:^(HTTPResponse *response) {
		XCTAssertEqual(200, response.response.statusCode, @"HTTP statusCode is not 200");
		XCTAssertNotNil(response.data, @"HTTP response.data is nil");
		XCTAssertEqualObjects(@"SIMPLE TEXT SAMPLE!", response.responseText, @"HTTP responseText failed.");
		done = YES;
	} error:^(NSError *error) {
		done = YES;
	}];
	
	while(!done) {
		[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
	}	
}

@end
