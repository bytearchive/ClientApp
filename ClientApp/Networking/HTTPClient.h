#import <Foundation/Foundation.h>


@class KSPromise;


@interface HTTPClient : NSObject

- (id)initWithSession:(NSURLSession *)session
                queue:(NSOperationQueue *)queue
acceptableStatusCodes:(NSIndexSet *)acceptableStatusCodes;

- (KSPromise *)promiseWithRequest:(NSURLRequest *)request;

@end
