//
//  HTTPResponse.m
//  BCNetworking
//
//  Created by Ilbert Esculpi on 3/14/14.
//  Copyright (c) 2014 Ilbert Esculpi. All rights reserved.
//

#import "BCHTTPResponse.h"
#import <objc/runtime.h>
//#import <Foundation/Foundation.h>

@interface BCHTTPResponse()

@property (nonatomic) NSHTTPURLResponse *http;

@end

@implementation BCHTTPResponse

-(id)initWithResponse:(NSHTTPURLResponse *)response {
	self = [super init];
	if( self ) {
		self.http = response;
	}
	return self;
}


-(NSString*)responseText {
	return [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
}

-(NSDictionary*)responseJSON {
	NSError *error;
	NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.data options:kNilOptions error:&error];
	return json;
}


#pragma mark - NSHTTPURLResponse

-(NSInteger)statusCode {
	return self.http.statusCode;
}

@end
