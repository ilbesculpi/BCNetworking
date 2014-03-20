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

@property (nonatomic, strong) BCHTTPRequest *request;
@property (nonatomic, strong) void (^successHandler)(BCHTTPResponse *response);
@property (nonatomic, strong) void (^errorHandler)(NSError *error);


-(id)initWithRequest:(BCHTTPRequest*)request;

-(void)send;

-(void)sendRequest:(BCHTTPRequest*)request
		   success:(void (^)(BCHTTPResponse *response))success
			 error:(void (^)(NSError *error))error;

@end
