//
//  BCNetworking.h
//  BCNetworking
//
//  Created by Ilbert Esculpi on 3/14/14.
//  Copyright (c) 2014 Ilbert Esculpi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BCHTTPRequest.h"
#import "BCHTTPResponse.h"
#import "BCConnection.h"

@interface BCNetworking : NSObject

+ (void) GET:(NSString*)url
  parameters:(NSDictionary*)parameters
	 success:(void (^)(BCHTTPResponse *response))success
	   error:(void (^)(NSError *error))error;

+ (void) POST:(NSString*)url
   parameters:(NSDictionary*)parameters
	  success:(void (^)(BCHTTPResponse *response))success
		error:(void (^)(NSError *error))error;

/*
- (void) UPLOAD:(NSString*)url
	 parameters:(NSDictionary*)parameters
		  image:(NSData*)imageData
		   name:(NSString*)fileName
		   type:(NSString*)imageType
		success:(void (^)(BCHTTPResponse *response))successHandler
		  error:(void (^)(NSError *error))errorHandler;
*/

@end