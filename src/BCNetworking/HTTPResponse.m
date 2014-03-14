//
//  HTTPResponse.m
//  BCNetworking
//
//  Created by Ilbert Esculpi on 3/14/14.
//  Copyright (c) 2014 Ilbert Esculpi. All rights reserved.
//

#import "HTTPResponse.h"

@implementation HTTPResponse

-(NSString*)responseText {
	return [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
}

@end
