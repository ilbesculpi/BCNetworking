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


-(void)testResponseText {
	
	__block BOOL done = NO;
	
	[BCNetworking GET:@"http://localhost/simple-text.txt" parameters:nil success:^(BCHTTPResponse *response) {
		XCTAssertEqual(200, response.statusCode, @"HTTP statusCode is not 200");
		XCTAssertNotNil(response.data, @"HTTP response.data is nil");
		XCTAssertEqualObjects(@"SIMPLE TEXT SAMPLE!", response.responseText, @"HTTP responseText failed.");
		done = YES;
	} error:^(NSError *error) {
		XCTFail(@"POST Request failed: %@", error.description);
		done = YES;
	}];
	
	// check completion async
	while(!done) {
		[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
	}	
}

-(void)testSimpleGet {
	
	__block BOOL done = NO;
	
	NSDictionary *query = @{
		@"foo": @"hello",
		@"bar": @"world",
		@"method": @"GET"
	};
	
	[BCNetworking GET:@"http://localhost/get.php" parameters:query success:^(BCHTTPResponse *response) {
		XCTAssertEqual(200, response.statusCode, @"HTTP statusCode is not 200");
		XCTAssertNotNil(response.data, @"HTTP response.data is nil");
		NSDictionary *json = response.responseJSON;
		XCTAssertNotNil(json, @"JSON is nil");
		XCTAssertNotNil(json[@"get"], @"$GET is nil");
		XCTAssertEqualObjects(@"hello", json[@"get"][@"foo"], @"$GET[foo] IS NOT 'hello'");
		XCTAssertEqualObjects(@"world", json[@"get"][@"bar"], @"$GET[bar] IS NOT 'world'");
		XCTAssertEqualObjects(@"GET", json[@"get"][@"method"], @"$GET[method] IS NOT 'GET'");
		done = YES;
	} error:^(NSError *error) {
		XCTFail(@"GET Request failed: %@", error.description);
		done = YES;
	}];
	
	// check completion async
	while(!done) {
		[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
	}
}

-(void)testSimplePost {
	
	__block BOOL done = NO;
	
	NSDictionary *query = @{
		@"foo": @"hello",
		@"bar": @"world",
		@"method": @"POST",
		@"version": @"1.1"
	};
	
	[BCNetworking POST:@"http://localhost/post.php" parameters:query success:^(BCHTTPResponse *response) {
		XCTAssertEqual(200, response.statusCode, @"HTTP statusCode is not 200");
		XCTAssertNotNil(response.data, @"HTTP response.data is nil");
		NSDictionary *json = response.responseJSON;
		XCTAssertNotNil(json, @"JSON is nil");
		XCTAssertNotNil(json[@"post"], @"$POST is nil");
		XCTAssertEqualObjects(@"hello", json[@"post"][@"foo"], @"$POST[foo] IS NOT 'hello'");
		XCTAssertEqualObjects(@"world", json[@"post"][@"bar"], @"$POST[bar] IS NOT 'world'");
		XCTAssertEqualObjects(@"POST", json[@"post"][@"method"], @"$POST[method] IS NOT 'POST'");
		done = YES;
	} error:^(NSError *error) {
		XCTFail(@"POST Request failed: %@", error.description);
		done = YES;
	}];
	
	// check completion async
	while(!done) {
		[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
	}
}



-(void)testUploadPNG {
	
	__block BOOL done = NO;
	
	NSDictionary *postData = @{@"upload": @"PNG"};
	NSString *imagePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"google" ofType:@"png"];
	UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
	NSData *imageData = UIImagePNGRepresentation(image);
	
	BCHTTPRequest *request = [[BCHTTPRequest alloc] init];
	[request setURL:[NSURL URLWithString:@"http://localhost/upload.php"]];
	[request setHTTPMethod:@"POST"];
	[request addRequestParameters:postData];
	[request attachFile:imageData name:@"file" file:@"google.png" type:@"image/png"];
	
	BCConnection *connection = [[BCConnection alloc] init];
	[connection sendRequest:request success:^(BCHTTPResponse *response) {
		
		NSDictionary *json = response.responseJSON;
		
		// test status code
		XCTAssertEqual(200, response.statusCode, @"HTTP statusCode is not 200");
		// test post data
		XCTAssertNotNil(json[@"post"], @"$POST IS NULL");
		XCTAssertEqualObjects(@"PNG", json[@"post"][@"upload"], @"$POST[upload] IS NOT 'PNG'");
		// test file object
		XCTAssertNotNil(json[@"files"][@"file"], @"$FILES[file] IS NULL");
		NSDictionary *file = json[@"files"][@"file"];
		XCTAssertNotNil(file, @"$FILE is NIL");
		XCTAssertEqualObjects(@"google.png", file[@"name"], @"$FILE[name] IS NOT 'google.png'");
		XCTAssertEqualObjects(@"image/png", file[@"type"], @"$FILE[type] IS NOT 'image/png'");
		XCTAssertEqualObjects([NSNumber numberWithInt:0], file[@"error"], @"$FILE[error] IS NOT '0'");
		XCTAssertTrue(file[@"size"] > 0, @"$FILE[size] IS NOT > 0");
		
		done = YES;
	} error:^(NSError *error) {
		XCTFail(@"HTTP UPLOAD failed.");
		done = YES;
	}];
	
	// check completion async
	while(!done) {
		[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
	}
}


-(void)testUploadJPG {
	
	__block BOOL done = NO;
	
	NSDictionary *postData = @{@"upload": @"JPG"};
	NSString *imagePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"iconfinder" ofType:@"jpg"];
	UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
	NSData *imageData = UIImagePNGRepresentation(image);
	
	// request
	BCHTTPRequest *request = [[BCHTTPRequest alloc] init];
	[request setURL:[NSURL URLWithString:@"http://localhost/upload.php"]];
	[request setHTTPMethod:@"POST"];
	[request addRequestParameters:postData];
	[request attachFile:imageData name:@"file" file:@"iconfinder.jpg" type:@"image/jpeg"];
	
	// connection
	BCConnection *connection = [[BCConnection alloc] init];
	[connection sendRequest:request success:^(BCHTTPResponse *response) {
		
		NSDictionary *json = response.responseJSON;
		
		// test status code
		XCTAssertEqual(200, response.statusCode, @"HTTP statusCode is not 200");
		// test post data
		XCTAssertNotNil(json[@"post"], @"$POST IS NULL");
		XCTAssertEqualObjects(@"JPG", json[@"post"][@"upload"], @"$POST[upload] IS NOT 'JPG'");
		// test file object
		XCTAssertNotNil(json[@"files"][@"file"], @"$FILES[file] IS NULL");
		NSDictionary *file = json[@"files"][@"file"];
		XCTAssertNotNil(file, @"$FILE is NIL");
		XCTAssertEqualObjects(@"iconfinder.jpg", file[@"name"], @"$FILE[name] IS NOT 'iconfinder.jpg'");
		XCTAssertEqualObjects(@"image/jpeg", file[@"type"], @"$FILE[type] IS NOT 'image/jpeg'");
		XCTAssertEqualObjects([NSNumber numberWithInt:0], file[@"error"], @"$FILE[error] IS NOT '0'");
		XCTAssertTrue(file[@"size"] > 0, @"$FILE[size] IS NOT > 0");
		
		done = YES;
	} error:^(NSError *error) {
		XCTFail(@"HTTP UPLOAD failed.");
		done = YES;
	}];
	
	// check completion async
	while(!done) {
		[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
	}
}


-(void)testUploadMultipleFiles {
	
	__block BOOL done = NO;
	
	// image 1
	NSString *imagePath1 = [[NSBundle bundleForClass:[self class]] pathForResource:@"github" ofType:@"png"];
	UIImage *image1 = [UIImage imageWithContentsOfFile:imagePath1];
	NSData *imageData1 = UIImagePNGRepresentation(image1);
	// image 2
	NSString *imagePath2 = [[NSBundle bundleForClass:[self class]] pathForResource:@"avatar" ofType:@"png"];
	UIImage *image2 = [UIImage imageWithContentsOfFile:imagePath2];
	NSData *imageData2 = UIImagePNGRepresentation(image2);
	// image 3
	NSString *imagePath3 = [[NSBundle bundleForClass:[self class]] pathForResource:@"minion" ofType:@"jpg"];
	UIImage *image3 = [UIImage imageWithContentsOfFile:imagePath3];
	NSData *imageData3 = UIImagePNGRepresentation(image3);
	
	// request
	BCHTTPRequest *request = [[BCHTTPRequest alloc] init];
	[request setURL:[NSURL URLWithString:@"http://localhost/upload.php"]];
	[request setHTTPMethod:@"POST"];
	NSDictionary *postData = @{@"upload": @"MULTIPLE"};
	[request addRequestParameters:postData];
	[request attachFile:imageData1 name:@"file1" file:@"upload1.png" type:@"image/png"];
	[request attachFile:imageData2 name:@"file2" file:@"upload2.png" type:@"image/png"];
	[request attachFile:imageData3 name:@"file3" file:@"upload3.jpg" type:@"image/jpeg"];
	
	// connection
	BCConnection *connection = [[BCConnection alloc] init];
	[connection sendRequest:request success:^(BCHTTPResponse *response) {
		
		NSDictionary *json = response.responseJSON;
		
		// test status code
		XCTAssertEqual(200, response.statusCode, @"HTTP statusCode is not 200");
		// test file objects
		XCTAssertNotNil(json[@"files"][@"file1"], @"$FILES[file1] IS NULL");
		XCTAssertNotNil(json[@"files"][@"file2"], @"$FILES[file2] IS NULL");
		XCTAssertNotNil(json[@"files"][@"file3"], @"$FILES[file3] IS NULL");
		
		NSDictionary *file1 = json[@"files"][@"file1"];
		XCTAssertNotNil(file1, @"$FILE1 is NULL");
		XCTAssertEqualObjects(@"upload1.png", file1[@"name"], @"$FILE[name] IS NOT 'upload1.png'");
		XCTAssertEqualObjects(@"image/png", file1[@"type"], @"$FILE[type] IS NOT 'image/png'");
		XCTAssertEqualObjects([NSNumber numberWithInt:0], file1[@"error"], @"$FILE[error] IS NOT '0'");
		XCTAssertTrue(file1[@"size"] > 0, @"$FILE[size] IS NOT > 0");
		
		NSDictionary *file2 = json[@"files"][@"file2"];
		XCTAssertNotNil(file2, @"$FILE2 is NULL");
		XCTAssertEqualObjects(@"upload2.png", file2[@"name"], @"$FILE[name] IS NOT 'upload2.png'");
		XCTAssertEqualObjects(@"image/png", file2[@"type"], @"$FILE[type] IS NOT 'image/png'");
		XCTAssertEqualObjects([NSNumber numberWithInt:0], file2[@"error"], @"$FILE[error] IS NOT '0'");
		XCTAssertTrue(file2[@"size"] > 0, @"$FILE[size] IS NOT > 0");
		
		NSDictionary *file3 = json[@"files"][@"file3"];
		XCTAssertNotNil(file3, @"$FILE3 is NULL");
		XCTAssertEqualObjects(@"upload3.jpg", file3[@"name"], @"$FILE[name] IS NOT 'upload3.jpg'");
		XCTAssertEqualObjects(@"image/jpeg", file3[@"type"], @"$FILE[type] IS NOT 'image/jpeg'");
		XCTAssertEqualObjects([NSNumber numberWithInt:0], file3[@"error"], @"$FILE[error] IS NOT '0'");
		XCTAssertTrue(file3[@"size"] > 0, @"$FILE[size] IS NOT > 0");
		
		done = YES;
	} error:^(NSError *error) {
		XCTFail(@"HTTP UPLOAD failed.");
		done = YES;
	}];
	
	// check completion async
	while(!done) {
		[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
	}
}


@end
