#import <Foundation/Foundation.h>


@class KSPromise;
@class HTTPClient;


@interface JSONClient : NSObject

- (id)initWithHTTPClient:(HTTPClient *)httpClient;

- (KSPromise *)promiseWithRequest:(NSURLRequest *)request;

@end
