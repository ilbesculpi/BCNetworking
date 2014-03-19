//
//  BCHTTPRequest.h
//  BCNetworking
//
//  Created by Ilbert Esculpi on 3/19/14.
//  Copyright (c) 2014 Ilbert Esculpi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCHTTPRequest : NSMutableURLRequest

-(void)addParameters:(NSDictionary*)parameters;

@end
