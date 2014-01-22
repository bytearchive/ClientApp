#import <Foundation/Foundation.h>
#import "RequestPromiseClient.h"


@class KSPromise;


@interface HTTPClient : NSObject <RequestPromiseClient>

- (id)initWithSession:(NSURLSession *)session
                queue:(NSOperationQueue *)queue
acceptableStatusCodes:(NSIndexSet *)acceptableStatusCodes;

@end
