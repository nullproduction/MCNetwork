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
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                // Handler
                [self handler];
                
                // Success
                dispatch_async(dispatch_get_main_queue(),^{
                    _success(self);
                });
            });
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
        TICK;
        _responseDictionary = [NSJSONSerialization JSONObjectWithData:_responseData options:kNilOptions error:nil];
        TOCK;
    }
    
    // XML
    if (_type == MCNetworkXML)
    {
        TICK;
        _responseDictionary = [[[SHXMLParser alloc] init] parseData:_responseData];
        TOCK;
    }
    
    // Mapping
    if (_mapping)
    {
        TICK;
        _responseMapping = [MCNetworkMapping convert:_responseDictionary withMapping:_mapping];
        TOCK;
    }
}

@end
