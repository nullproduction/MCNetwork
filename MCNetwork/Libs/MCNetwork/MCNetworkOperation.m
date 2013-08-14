//
//  MCNetworkOperation.m
//

#import "MCNetworkOperation.h"

@implementation MCNetworkOperation


+ (MCNetworkOperation *)initWithURLString: (NSString *)URLString
{
    MCNetworkOperation *operation = [[MCNetworkOperation alloc] init];
    operation.URLString = URLString;
    return operation;
}


- (void)start
{
    // URL
    if(_URLString) _URL = [NSURL URLWithString:_URLString];
    
    // Request
    NSURLRequest *request = [NSURLRequest requestWithURL:_URL];

    // Operation
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
         
    // Success
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *requestOperation, id responseObject){
        
        // Data
        _responseData = requestOperation.responseData;
        
        // String
        _responseString = requestOperation.responseString;
        
        // JSON
        if (_handler == MCNetworkJSON)
        {
            _responseDictionary = [NSJSONSerialization JSONObjectWithData:_responseData options:kNilOptions error:nil];
        }
         
         // Success
         _success(self);
     }
     
     // Failure
    failure:^(AFHTTPRequestOperation *requestOperation, NSError *error){
         _failure(error);
    }];
    
    // Progress
    if (_progress)
    {
        [requestOperation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
             float progressDownload = (float)totalBytesRead / totalBytesExpectedToRead;
             _progress(progressDownload);
         }];
    }
    
    // Start
    [requestOperation start];
}


@end
