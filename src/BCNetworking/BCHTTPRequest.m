//
//  BCHTTPRequest.m
//  BCNetworking
//
//  Created by Ilbert Esculpi on 3/19/14.
//  Copyright (c) 2014 Ilbert Esculpi. All rights reserved.
//

#import "BCHTTPRequest.h"



@interface BCHTTPRequest()

@property (nonatomic) NSMutableDictionary *requestParameters;
@property (nonatomic) NSMutableArray *attachments;

@end



@implementation BCHTTPRequest

-(void)addRequestParameters:(NSDictionary *)parameters {
	if( !self.requestParameters ) {
		self.requestParameters = [[NSMutableDictionary alloc] init];
	}
	if( parameters ) {
		[self.requestParameters addEntriesFromDictionary:parameters];
	}
}

-(void)setValue:(NSString *)value forRequestParameter:(NSString *)parameter {
	if( !self.requestParameters ) {
		self.requestParameters = [[NSMutableDictionary alloc] init];
	}
	if( parameter && value ) {
		[self.requestParameters setValue:value forKey:parameter];
	}
}

-(void)attachFile:(NSData *)fileData name:(NSString *)name file:(NSString*)file type:(NSString *)type {
	if( !self.attachments ) {
		self.attachments = [[NSMutableArray alloc] init];
	}
	
	[self.attachments addObject:@{
		@"data": fileData,
		@"name": name,
		@"file": file,
		@"type": type
	}];
}

-(void)setup {
	
	if( !self.requestParameters ) {
		return;
	}
	
	if( [self.HTTPMethod isEqualToString:@"GET"] ) {
		// modify the URL to append query parameters
		NSMutableArray *urlParams = [[NSMutableArray alloc] init];
		for( NSString *key in self.requestParameters ) {
			[urlParams addObject:[NSString stringWithFormat:@"%@=%@", key, self.requestParameters[key]]];
		}
		NSString *fullUrl = [NSString stringWithFormat:@"%@?%@", self.URL.absoluteString, [urlParams componentsJoinedByString:@"&"]];
		self.URL = [NSURL URLWithString:fullUrl];
	}
	else if( [self.HTTPMethod isEqualToString:@"POST"] || [self.HTTPMethod isEqualToString:@"PUT"] ) {
		
		static NSString *BoundaryConstant = @"----------BCS147137N0VcXz24Ca45K08y";
		
		// set Content-Type in HTTP header
		NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
		[self setValue:contentType forHTTPHeaderField: @"Content-Type"];
		
		NSMutableData *body = [NSMutableData data];
		
		// post params
		if( self.requestParameters ) {
			for (NSString *param in self.requestParameters) {
				[body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
				[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
				[body appendData:[[NSString stringWithFormat:@"%@\r\n", [self.requestParameters objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
			}
		}
		
		// attachments
		if( self.attachments ) {
			for( NSDictionary *attachment in self.attachments ) {
				[body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
				[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", attachment[@"name"], attachment[@"file"]] dataUsingEncoding:NSUTF8StringEncoding]];
				[body appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", attachment[@"type"]] dataUsingEncoding:NSUTF8StringEncoding]];
				[body appendData:attachment[@"data"]];
				[body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
			}
		}
		
		[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
		//[body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
		
		// setting the body of the post to the reqeust
		[self setHTTPBody:body];
		
		// set the content-length
		NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
		[self setValue:postLength forHTTPHeaderField:@"Content-Length"];
		
		//NSString *bodyData = [urlParams componentsJoinedByString:@"&"];
		//NSData *paramData = [bodyData dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
		//NSString *length = [NSString stringWithFormat:@"%lu", (unsigned long)paramData.length];
		//[self setValue:length forHTTPHeaderField:@"Content-Length"];
		//[self setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
		//[self setHTTPBody:paramData];
	}
}

@end
