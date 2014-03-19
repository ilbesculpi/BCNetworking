//
//  HTTPResponse.h
//  BCNetworking
//
//  Created by Ilbert Esculpi on 3/14/14.
//  Copyright (c) 2014 Ilbert Esculpi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCHTTPResponse : NSHTTPURLResponse <NSCopying>

@property (nonatomic) NSData *data;
@property (nonatomic, readonly) NSString *responseText;
@property (nonatomic, readonly) NSDictionary *responseJSON;


-(id)initWithResponse:(NSHTTPURLResponse*)response;

@end
