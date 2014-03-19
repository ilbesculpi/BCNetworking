//
//  BCNetworking.m
//  BCNetworking
//
//  Created by Ilbert Esculpi on 3/19/14.
//  Copyright (c) 2014 Ilbert Esculpi. All rights reserved.
//

#import "BCNetworking.h"

@implementation BCNetworking

+ (void) GET:(NSString *)url
  parameters:(NSDictionary *)parameters
	 success:(void (^)(BCHTTPResponse *))success
	   error:(void (^)(NSError *))error {
	
	// connection
	BCConnection *connection = [[BCConnection alloc] init];
	
	// request
	BCHTTPRequest *request = [[BCHTTPRequest alloc] init];
	[request setURL:[NSURL URLWithString:url]];
	[request setHTTPMethod:@"GET"];
	[request addParameters:parameters];
	
	// handlers
	connection.successHandler = success;
	connection.errorHandler = error;
	
	// send
	[connection send];
	
}

+ (void) POST:(NSString *)url
   parameters:(NSDictionary *)parameters
	  success:(void (^)(BCHTTPResponse *))success
		error:(void (^)(NSError *))error {
	
	// connection
	BCConnection *connection = [[BCConnection alloc] init];
	
	// request
	BCHTTPRequest *request = [[BCHTTPRequest alloc] init];
	[request setURL:[NSURL URLWithString:url]];
	[request setHTTPMethod:@"POST"];
	[request addParameters:parameters];
	
	// handlers
	connection.successHandler = success;
	connection.errorHandler = error;
	
	// send
	[connection send];
}

@end
