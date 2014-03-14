//
//  BCConnection.h
//  BCNetworking
//
//  Created by Ilbert Esculpi on 3/14/14.
//  Copyright (c) 2014 Ilbert Esculpi. All rights reserved.
//

#import "BCNetworking.h"

@interface BCConnection : NSObject <NSURLConnectionDelegate>

- (void) GET:(NSString*)url parameters:(NSDictionary*)parameters
	 success:(void (^)(HTTPResponse *response))successHandler
	   error:(void (^)(NSError *error))errorHandler;

- (void) POST:(NSString*)url parameters:(NSDictionary*)parameters
	  success:(void (^)(HTTPResponse *response))successHandler
		error:(void (^)(NSError *error))errorHandler;


@end
