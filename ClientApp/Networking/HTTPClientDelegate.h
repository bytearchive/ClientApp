#import <Foundation/Foundation.h>


@class HTTPClient;


@protocol HTTPClientDelegate <NSObject>

- (void)httpClient:(HTTPClient *)httpClient
didUpdateTaskCount:(NSUInteger)updatedTaskCount;

- (void)httpClient:(HTTPClient *)httpClient
    didSendRequest:(NSURLRequest *)request;

@end
