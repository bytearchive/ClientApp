#import <Foundation/Foundation.h>
#import "RequestPromiseClient.h"


@class KSPromise;
@protocol HTTPClientDelegate;


@interface HTTPClient : NSObject <RequestPromiseClient>

@property (weak, nonatomic) id <HTTPClientDelegate> delegate;

- (id)initWithSession:(NSURLSession *)session
                queue:(NSOperationQueue *)queue
acceptableStatusCodes:(NSIndexSet *)acceptableStatusCodes;


@end
