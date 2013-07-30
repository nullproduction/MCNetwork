//
//  ViewController.m
//  MCNetwork
//
//

#import "ViewController.h"
#import "MCNetwork.h"

@implementation ViewController

#define kRSSURLString @"http://laowaicast.rpod.ru/rss.xml"

/*
 * Load
 */
- (void)viewDidLoad
{
    // Super
    [super viewDidLoad];
    
    // Load Sync RSS
    //[self loadSyncRSS];
    
    // Load ASync RSS
    //[self loadAsyncRSS];
    
    // Load two request
    [self loadTwoRequest];
}


/*
 * Load Sync RSS
 */
- (void)loadSyncRSS
{
    MCRequestOperation *operation = [[MCRequestOperation alloc] init];
    operation.URLString = kRSSURLString;
    [operation sendSync];
    
    NSLog(@"sendSync  - %@", operation.responseString);
}


/*
 * Load Async RSS
 */
- (void)loadAsyncRSS
{
    MCRequestOperation *operation = [MCRequestOperation initWithURLString:kRSSURLString];
    operation.success = ^(MCRequestOperation *operation) {
        NSLog(@"sendAsync - %@", operation.responseString);
    };
    operation.failure = ^(NSError *error) {
        NSLog(@"Error: %@", error);
    };
    [operation sendAsync];
}


/*
 * Load Two Request
 */
- (void)loadTwoRequest
{
    // firstURLString
    NSString *firstURLString = @"https://itunes.apple.com/lookup?id=669974469";

    // First request
    MCRequestOperation *operation = [MCRequestOperation initWithURLString:firstURLString];
    operation.type = MCNetworkJSON;
    [operation sendSync];
    
    // secondURLString
    NSString *secondURLString = operation.responseDictionary[@"results"][0][@"feedUrl"];
    NSLog(@"%@", secondURLString);
    
    // Second request
    operation.URLString = secondURLString;
    operation.type = MCNetworkXML;
    [operation sendSync];
    
    // Copyright
    NSString *copyright = operation.responseDictionary[@"rss"][@"channel"][@"C"];
    NSLog(@"%@", copyright);
}


@end
