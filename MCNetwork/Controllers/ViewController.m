//
//  ViewController.m
//  MCNetwork
//
//

#import "ViewController.h"
#import "MCNetwork.h"
#import "RXMLElement.h"

@implementation ViewController

#define kRSSURLString @"http://laowaicast.rpod.ru/rss.xml"
#define TICK   NSDate *startTime = [NSDate date]
#define TOCK   NSLog(@"Time: %f", -[startTime timeIntervalSinceNow])


- (void)viewDidAppear:(BOOL)animated
{
    //[self loadAsyncRSS];
    [self loadFile];
}


- (void)loadFile
{
    NSLog(@"download file start");
    NSString *URLfile = @"http://podcast.cnbc.com.edgesuite.net//OptionsAction-080913.mp4";
    MCNetworkOperation *operation = [MCNetworkOperation initWithURLString:URLfile];
    operation.success = ^(MCNetworkOperation *operation) {
        NSLog(@"download file success");
    };
    operation.progress = ^(float progressDownload) {
        NSLog(@"%f", progressDownload);
    };
    [operation start];
}

- (void)loadAsyncRSS
{
    MCNetworkOperation *operation = [MCNetworkOperation initWithURLString:kRSSURLString];
    operation.success = ^(MCNetworkOperation *operation) {
        TICK;
        RXMLElement *rootRSS = [RXMLElement elementFromXMLData:operation.responseData];
        NSMutableArray *result = [NSMutableArray array];
        
        [rootRSS iterate:@"channel.item" usingBlock: ^(RXMLElement *item) {
            [result addObject:@{
                 @"title": [item child:@"title"].text,
                 @"link": [item child:@"link"].text,
                 @"description": [item child:@"description"].text,
             }];
        }];
        
        NSLog(@"%@", result[0][@"title"]);
        TOCK;
    };
    [operation start];
}

@end
