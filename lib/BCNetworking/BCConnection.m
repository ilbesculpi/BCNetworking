//
//  BCConnection.m
//  BCNetworking
//
//  Created by Ilbert Esculpi on 3/14/14.
//  Copyright (c) 2014 Ilbert Esculpi. All rights reserved.
//

#import "BCConnection.h"

@implementation BCConnection {
	NSMutableData *_data;
	NSURLConnection *_connection;
	BCHTTPResponse *_response;
	//void (^_success)(BCHTTPResponse*);
	//void (^_error)(NSError*);
}


-(id)initWithRequest:(BCHTTPRequest *)request {
	self = [super init];
	if( self ) {
		self.request = request;
	}
	return self;
}


-(void)send {
	
	[self.request setup];
	
	_data = [NSMutableData dataWithCapacity: 0];
	_connection = [[NSURLConnection alloc] initWithRequest:_request delegate:self];
	
	if (!_connection) {
		// Release the receivedData object.
		_data = nil;
		// Inform the user that the connection failed.
		NSError *error = [[NSError alloc] initWithDomain:@"Network Error" code:NSURLErrorUnknown userInfo:nil];
		self.errorHandler(error);
	}
}

-(void)sendRequest:(BCHTTPRequest *)request
		   success:(void (^)(BCHTTPResponse *))success
			 error:(void (^)(NSError *))error {
	
	self.request = request;
	self.successHandler = success;
	self.errorHandler = error;
	
	[self send];
}


/*
-(void)UPLOAD:(NSString *)url
   parameters:(NSDictionary *)parameters
		image:(NSData *)imageData
		 name:(NSString *)fileName
		 type:(NSString *)imageType
	  success:(void (^)(BCHTTPResponse *))successHandler
		error:(void (^)(NSError *))errorHandler {
	

	// create request
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
	[request setHTTPShouldHandleCookies:NO];
	[request setTimeoutInterval:30];
	[request setHTTPMethod:@"POST"];
	
	
	static NSString *BoundaryConstant = @"--------BCN1VcXz24Ca45K08y";
	NSString *FileParamConstant = fileName;
	NSString *FileNameConstant = @"image.png";
	if( [imageType isEqualToString:@"image/png"] ) {
		FileNameConstant = [NSString stringWithFormat:@"%@.png", fileName];
	}
	else if( [imageType isEqualToString:@"image/jpeg"] ) {
		FileNameConstant = [NSString stringWithFormat:@"%@.jpg", fileName];
	}
	
	// set Content-Type in HTTP header
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
	[request setValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	// post body
	NSMutableData *body = [NSMutableData data];
	
	// add params (all params are strings)
	if( parameters ) {
		for (NSString *param in parameters) {
			[body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
			[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
			[body appendData:[[NSString stringWithFormat:@"%@\r\n", [parameters objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
		}
	}
	
	// add image data
	//NSData *imageData = UIImageJPEGRepresentation(imageToPost, 1.0);
	if (imageData) {
		[body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", FileParamConstant, FileNameConstant] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", imageType] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:imageData];
		[body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	}
	else {
		NSLog(@"[ERROR] no image provided.");
	}
	
	[body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
	
	// setting the body of the post to the reqeust
	[request setHTTPBody:body];
	
	// set the content-length
	NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	
	// set URL
	[request setURL:[NSURL URLWithString:url]];
	
	_data = [NSMutableData dataWithCapacity: 0];
	_connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	if (!_connection) {
		// Release the receivedData object.
		_data = nil;
		// Inform the user that the connection failed.
		NSError *error = [[NSError alloc] initWithDomain:@"Network Error" code:NSURLErrorUnknown userInfo:nil];
		_error(error);
	}
	
}
*/

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse object.
	
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
	//_response = [[BCHTTPResponse alloc] init];
	//_response.response = (NSHTTPURLResponse*)response;
	_response = [[BCHTTPResponse alloc] initWithResponse:(NSHTTPURLResponse*)response];
	
    // receivedData is an instance variable declared elsewhere.
    [_data setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [_data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    _connection = nil;
    _data = nil;
	
	// inform the user
	self.errorHandler(error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // do something with the data
    // receivedData is declared as a property elsewhere
    NSLog(@"[INFO] Received %lu bytes of data",(unsigned long)[_data length]);
	[_response setData:_data];
    _connection = nil;
    _data = nil;
	self.successHandler(_response);
}

@end
