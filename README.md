# BCNetworking

This library aims to provide a simple, yet useful library for managing HTTP resquest and response.


## Installation

* Copy the folder `BCNetworking` to your project.
* Add `#import BCNetworking.h`


## Usage

### Simple GET/POST requests

BCNetworking provides 2 simple ways to send/receive data from/to your server. These shortcut allows you to send and receive data using GET or POST method.

```
// Simple GET Request
[BCNetworking GET:@"http://example.com/script.php" parameters:nil success:^(BCHTTPResponse *response) {
		NSLog(@"Received: %@", response.responseText);
	} error:^(NSError *error) {
		NSLog(@"An error occured.");
	}
];

// Simple POST Request
NSDictionary *query = @{ @"foo": @"hello", @"bar": @"world" };	// post data
[BCNetworking POST:@"http://example.com/script.php" parameters:query success:^(BCHTTPResponse *response) {
		NSLog(@"Received: %@", response.responseText);
	} error:^(NSError *error) {
		NSLog(@"An error occured.");
	}
];

```

### Upload Files

```
UIImage *image = [UIImage imageNamed:@"picture.png"];
NSData *fileData = UIImagePNGRepresentation(image);
BCHTTPRequest *request = [[BCHTTPRequest alloc] init];
[request setURL:[NSURL URLWithString:@"http://example.com/upload.php"]];
[request setHTTPMethod:@"POST"];
[request attachFile:fileData name:@"file" file:@"picture.png" type:@"image/png"];

[BCNetworking sendResquest:request success:success:^(BCHTTPResponse *response) {
		NSLog(@"File uploaded.");
	} error:^(NSError *error) {
		NSLog(@"Error uploading file.");
	}
];
```

### Response Format

`BCHTTPResponse` has some methods to parse the response received from the server.

* data: returns the raw response as NSData.
* responseText: returns the response as NSString.
* responseJSON: returns a NSDictionary for the JSON object.
* responseXML: returns a NSDictionary for the root XML object.

