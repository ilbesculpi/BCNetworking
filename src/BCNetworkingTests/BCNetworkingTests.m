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
	
	[connection GET:@"http://localhost/simple-text.txt" parameters:nil success:^(BCHTTPResponse *response) {
		XCTAssertEqual(200, response.statusCode, @"HTTP statusCode is not 200");
		XCTAssertNotNil(response.data, @"HTTP response.data is nil");
		XCTAssertEqualObjects(@"SIMPLE TEXT SAMPLE!", response.responseText, @"HTTP responseText failed.");
		done = YES;
	} error:^(NSError *error) {
		done = YES;
	}];
	
	// check completion async
	while(!done) {
		[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
	}	
}

-(void)testSimplePost {
	__block BOOL done = NO;
	
	NSDictionary *postData = @{
		@"foo": @"hello",
		@"bar": @"world"
	};
	
	BCConnection *connection = [[BCConnection alloc] init];
	
	[connection POST:@"http://localhost/post.php" parameters:postData success:^(BCHTTPResponse *response) {
		XCTAssertEqual(200, response.statusCode, @"HTTP statusCode is not 200");
		XCTAssertNotNil(response.data, @"HTTP response.data is nil");
		NSDictionary *json = response.responseJSON;
		XCTAssertNotNil(json, @"JSON is nil");
		XCTAssertNotNil(json[@"post"], @"$POST is nil");
		XCTAssertEqualObjects(@"hello", json[@"post"][@"foo"], @"$POST[foo] IS NOT 'hello'");
		XCTAssertEqualObjects(@"world", json[@"post"][@"bar"], @"$POST[bar] IS NOT 'world'");
		done = YES;
	} error:^(NSError *error) {
		done = YES;
	}];
	
	// check completion async
	while(!done) {
		[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
	}
}

-(void)testUploadPNG {
	
	__block BOOL done = NO;
	
	NSDictionary *postData = @{@"param": @"value"};
	NSString *imagePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"google" ofType:@"png"];
	UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
	NSData *imageData = UIImagePNGRepresentation(image);
	
	BCConnection *connection = [[BCConnection alloc] init];
	[connection UPLOAD:@"http://localhost/upload.php"
			parameters:postData
				 image:imageData
				  name:@"pngfile"
				  type:@"image/png"
			   success:^(BCHTTPResponse *response) {

				   NSDictionary *json = response.responseJSON;
				   
				   // test status code
				   XCTAssertEqual(200, response.statusCode, @"HTTP statusCode is not 200");
				   // test post data
				   XCTAssertEqualObjects(json[@"post"][@"param"], @"value", @"$POST[param] IS NOT EQUAL to 'value'");
				   // test file object
				   NSDictionary *file = json[@"files"][@"pngfile"];
				   XCTAssertNotNil(file, @"$FILE is NIL");
				   XCTAssertEqualObjects(@"pngfile.png", file[@"name"], @"$FILE[name] IS NOT 'pngfile.png'");
				   XCTAssertEqualObjects(@"image/png", file[@"type"], @"$FILE[type] IS NOT 'image/png'");
				   XCTAssertEqualObjects([NSNumber numberWithInt:0], file[@"error"], @"$FILE[error] IS NOT '0'");
				   XCTAssertTrue(file[@"size"] > 0, @"$FILE[size] IS NOT > 0");
				   done = YES;
			   }
				error:^(NSError *error) {
					done = YES;
				}
	];
	
	
	// check completion async
	while(!done) {
		[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
	}
}

-(void)testUploadJPG {
	
	__block BOOL done = NO;
	
	NSDictionary *postData = @{@"param": @"value"};
	NSString *imagePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"iconfinder" ofType:@"jpg"];
	UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
	NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
	
	BCConnection *connection = [[BCConnection alloc] init];
	[connection UPLOAD:@"http://localhost/upload.php"
			parameters:postData
				 image:imageData
				  name:@"jpgfile"
				  type:@"image/jpeg"
			   success:^(BCHTTPResponse *response) {
				   //NSInteger responseCode = response.response.statusCode;
				   NSDictionary *json = response.responseJSON;
				   
				   // test status code
				   XCTAssertEqual(200, response.statusCode, @"HTTP statusCode is not 200");
				   // test post data
				   XCTAssertEqualObjects(json[@"post"][@"param"], @"value", @"POST.param IS NOT EQUAL to 'value'");
				   // test file object
				   NSDictionary *file = json[@"files"][@"jpgfile"];
				   XCTAssertNotNil(file, @"FILES.file is NIL");
				   XCTAssertEqualObjects(@"jpgfile.jpg", file[@"name"], @"$FILE[name] IS NOT 'jpgfile.jpg'");
				   XCTAssertEqualObjects(@"image/jpeg", file[@"type"], @"$FILE[type] IS NOT 'image/jpeg'");
				   XCTAssertEqualObjects([NSNumber numberWithInt:0], file[@"error"], @"FILES.error IS NOT '0'");
				   XCTAssertTrue(file[@"size"] > 0, @"FILES.size IS NOT > 0");
				   done = YES;
			   }
				 error:^(NSError *error) {
					 done = YES;
				 }
	 ];
	
	// check completion async
	while(!done) {
		[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
	}
	
}

@end
