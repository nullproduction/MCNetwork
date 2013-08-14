//
//  MCNetworkOperation.h
//

#import "AFNetworking.h"

@interface MCNetworkOperation : NSObject

typedef enum
{
    MCNetworkJSON=1,
    MCNetworkSaveFile=2
} Handler;

+ (MCNetworkOperation *)initWithURLString: (NSString *)URLString;
- (void)start;

typedef void(^MCNetworkSuccessBlock)(MCNetworkOperation *requestOperation);
typedef void(^MCNetworkFailureBlock)(NSError *error);
typedef void(^MCNetworkProgressBlock)(float progressDownload);

@property (nonatomic, retain) NSURL *URL;
@property (nonatomic, retain) NSString *URLString;
@property (nonatomic, retain) NSData *responseData;
@property (nonatomic, retain) NSString *responseString;
@property (nonatomic, retain) NSDictionary *responseDictionary;
@property (nonatomic, readwrite) Handler handler;
@property (nonatomic, copy) MCNetworkSuccessBlock success;
@property (nonatomic, copy) MCNetworkFailureBlock failure;
@property (nonatomic, copy) MCNetworkProgressBlock progress;

@end
