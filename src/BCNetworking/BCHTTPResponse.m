//
//  HTTPResponse.m
//  BCNetworking
//
//  Created by Ilbert Esculpi on 3/14/14.
//  Copyright (c) 2014 Ilbert Esculpi. All rights reserved.
//

#import "BCHTTPResponse.h"

@implementation BCHTTPResponse

-(NSString*)responseText {
	return [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
}

-(NSDictionary*)responseJSON {
	NSError *error;
	NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.data options:kNilOptions error:&error];
	return json;
}

@end
