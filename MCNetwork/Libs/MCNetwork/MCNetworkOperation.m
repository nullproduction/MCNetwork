//
//  MCNetworkOperation.m
//

#import "MCNetworkOperation.h"

@implementation MCNetworkOperation


/*
 * Init with URLString
 */
+ (MCNetworkOperation *)initWithURLString: (NSString *)URLString
{
    MCNetworkOperation *operation = [[MCNetworkOperation alloc] init];
    operation.URLString = URLString;
    return operation;
}


/*
 * Send Async
 */
- (void)sendAsync
{
    // URL
    if(_URLString) _URL = [NSURL URLWithString:_URLString];
    
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
            
            // Handlers
            [self handlers];
                
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
    if(_URLString) _URL = [NSURL URLWithString:_URLString];
    
    // Request
    NSURLRequest *request = [NSURLRequest requestWithURL:_URL];
    
    // Response
    NSURLResponse *response;
    
    // Error
    NSError *error;
    
    // Send Synchronous Request
    _responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    // Handlers
    [self handlers];
}


/*
 * Handler
 */
- (void)handlers
{
    // Response String
    _responseString = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    
    // JSON
    if (_handler == MCNetworkJSON)
    {
        _responseDictionary = [NSJSONSerialization JSONObjectWithData:_responseData options:kNilOptions error:nil];
    }
}

@end
