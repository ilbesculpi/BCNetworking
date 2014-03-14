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
	HTTPResponse *_response;
	void (^_success)(HTTPResponse*);
	void (^_error)(NSError*);
}


-(void)GET:(NSString *)url parameters:(NSDictionary *)parameters
   success:(void (^)(HTTPResponse *))successHandler
	 error:(void (^)(NSError *))errorHandler {
	
	_success = successHandler;
	_error = errorHandler;
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
	[request setHTTPMethod:@"GET"];
	[request setTimeoutInterval:30.0];
	[request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
	
	// Paramters
	if( parameters ) {
		NSMutableArray *urlParams = [[NSMutableArray alloc] init];
		for( NSString *key in parameters ) {
			[urlParams addObject:[NSString stringWithFormat:@"%@=%@", key, parameters[key]]];
		}
		NSString *bodyData = [urlParams componentsJoinedByString:@"&"];
		NSData *paramData = [bodyData dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
		NSString *length = [NSString stringWithFormat:@"%lu", (unsigned long)paramData.length];
		[request setValue:length forHTTPHeaderField:@"Content-Length"];
		[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
		[request setHTTPBody:paramData];
	}
	
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


-(void)POST:(NSString *)url parameters:(NSDictionary *)parameters
	success:(void (^)(HTTPResponse *))successHandler
	  error:(void (^)(NSError *))errorHandler {
	
	
	
}


#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse object.
	
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
	NSLog(@"Class: %@", [[response class] description]);
	//_response = (HTTPResponse*)response;
	NSHTTPURLResponse *my = (NSHTTPURLResponse*)response;
	my.statusCode;
	_response = [[HTTPResponse alloc] init];
	_response.response = response;
	
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
	_error(error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // do something with the data
    // receivedData is declared as a property elsewhere
    NSLog(@"[INFO] Received %lu bytes of data",(unsigned long)[_data length]);
	[_response setData:_data];
	_success(_response);
    _connection = nil;
    _data = nil;
}

@end
