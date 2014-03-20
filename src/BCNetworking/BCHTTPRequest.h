//
//  BCHTTPRequest.h
//  BCNetworking
//
//  Created by Ilbert Esculpi on 3/19/14.
//  Copyright (c) 2014 Ilbert Esculpi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCHTTPRequest : NSMutableURLRequest

-(void)addRequestParameters:(NSDictionary*)parameters;
-(void)setValue:(NSString*)value forRequestParameter:(NSString*)parameter;
-(void)attachFile:(NSData*)fileData name:(NSString*)name file:(NSString*)file type:(NSString*)type;
-(void)setup;

@end
