//
//  MCRequestOperation.m
//

#import "MCRequestOperation.h"

@implementation MCRequestOperation


/*
 * Init with URLString
 */
+ (MCRequestOperation *)initWithURLString: (NSString *)URLString
{
    MCRequestOperation *operation = [[MCRequestOperation alloc] init];
    operation.URLString = URLString;
    return operation;
}


/*
 * Send Async
 */
- (void)sendAsync
{
    // URL
    _URL = [NSURL URLWithString:_URLString];
    
    // Request
    NSURLRequest *request = [NSURLRequest requestWithURL:_URL];

    // Queue
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    // Send Asynchronous Request
    [NSURLConnection sendAsynchronousRequest:request queue:queue
    completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    {
        if(!error.code)
        {
            // Response Data
            _responseData = data;
            
            // Handler
            [self handler];
            
            // Success
            _success(self);
        }
        else
        {
            // Failure
            _failure(error);
        }
    }];
}


/*
 * Send Sync
 */
- (void)sendSync
{
    // URL
    _URL = [NSURL URLWithString:_URLString];
    
    // Request
    NSURLRequest *request = [NSURLRequest requestWithURL:_URL];
    
    // Response
    NSURLResponse *response;
    
    // Error
    NSError *error;
    
    // Send Synchronous Request
    _responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    // Handler
    [self handler];
}


/*
 * Handler
 */
- (void)handler
{
    // Response String
    _responseString = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    
    // JSON
    if (_type == MCNetworkJSON)
    {
        _responseDictionary = [NSJSONSerialization JSONObjectWithData:_responseData options:kNilOptions error:nil];
    }
    
    // XML
    if (_type == MCNetworkXML)
    {
        _responseDictionary = [[[SHXMLParser alloc] init] parseData:_responseData];
    }
}

@end
