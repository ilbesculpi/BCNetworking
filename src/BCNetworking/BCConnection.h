//
//  BCConnection.h
//  BCNetworking
//
//  Created by Ilbert Esculpi on 3/14/14.
//  Copyright (c) 2014 Ilbert Esculpi. All rights reserved.
//

#import "BCNetworking.h"
#import <UIKit/UIKit.h>

@interface BCConnection : NSObject <NSURLConnectionDelegate>

- (void) GET:(NSString*)url
  parameters:(NSDictionary*)parameters
	 success:(void (^)(BCHTTPResponse *response))successHandler
	   error:(void (^)(NSError *error))errorHandler;

- (void) POST:(NSString*)url
   parameters:(NSDictionary*)parameters
	  success:(void (^)(BCHTTPResponse *response))successHandler
		error:(void (^)(NSError *error))errorHandler;

- (void) UPLOAD:(NSString*)url
	 parameters:(NSDictionary*)parameters
		  image:(NSData*)imageData
		   name:(NSString*)fileName
		   type:(NSString*)imageType
		success:(void (^)(BCHTTPResponse *response))successHandler
		  error:(void (^)(NSError *error))errorHandler;

@end
