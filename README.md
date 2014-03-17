#BCNetworking


This library aims to provide a simple, yet useful library for managing HTTP resquest and response.

##Installation

* Copy the folder `BCNetworking` to your project.

## Usage

### Simple GET Request

```
BCConnection *connection = [[BCConnection alloc] init];
[connection GET:@"http://localhost/simple-text.txt" parameters:nil success:^(BCHTTPResponse *response) {
		NSLog(@"[DEBUG] ResponseText: %@", response.responseText");
} error:^(NSError *error) {
		
}];
```

### Simple POST Request

```
NSDictionary *postData = @{
  @"foo": @"hello",
  @"bar": @"world"
};
BCConnection *connection = [[BCConnection alloc] init];
[connection POST:@"http://localhost/simple-text.txt" parameters:postData success:^(BCHTTPResponse *response) {
		NSLog(@"[DEBUG] ResponseText: %@", response.responseText");
} error:^(NSError *error) {
		
}];
```
