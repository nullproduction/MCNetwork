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
- (void)viewDidAppear:(BOOL)animated
{
    // Load Sync RSS
    //[self loadSyncRSS];
    
    // Load ASync RSS
    [self loadAsyncRSS];
    
    // Load two request
    //[self loadTwoRequest];
    //[self loadTwoRequestAsync];
    
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
    operation.type = MCNetworkXML;
    operation.mapping = self.rssMapping;
    operation.success = ^(MCRequestOperation *operation) {
        NSLog(@"%@", operation.responseDictionaryConvert[0][@"title"]);
    };
    operation.failure = ^(NSError *error) {
        NSLog(@"Error: %@", error);
    };
    [operation sendAsync];
}


/*
 * Load Two Request Async
 */
- (void)loadTwoRequestAsync
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [self loadTwoRequest];
    });
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
    NSString *copyright = operation.responseDictionary[@"rss"][@"channel"][@"copyright"];
    NSLog(@"%@", copyright);
}

/*
 * Mapping
 */
- (NSDictionary *)rssMapping
{
    return @{
     @"path": @"rss.channel.item",
     @"attributes": @{
             @"title": @{
                     @"path": @"title"
                     },
             @"link": @{
                     @"path": @"link"
                     },
             @"pubDate": @{
                     @"path": @"pubDate",
                     @"handler": @{
                             @"class": @"ViewController",
                             @"method": @"dateForRssDate:"
                             }
                     },
             @"desc": @{
                     @"path": @"description"
                     },
             @"enclosureUrl": @{
                     @"path": @"enclosure.url"
                     },
             @"enclosureType": @{
                     @"path": @"enclosure.type"
                     },
             @"enclosureLength": @{
                     @"path": @"enclosure.length"
                     },
             @"duration": @{
                     @"path": @"itunes:duration"
                     },
             @"imageURL": @{
                     @"path": @"itunes:image.href"
                     },
             }
     };
}


/*
 * Date For Rss Date
 */
+ (NSDate *)dateForRssDate:(NSString *)rssDate
{
    NSString *dateFormat = @"EEE, dd MMMM yyyy HH:mm:ss Z";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    return [dateFormatter dateFromString:rssDate];
}

@end
