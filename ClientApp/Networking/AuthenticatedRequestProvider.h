#import <Foundation/Foundation.h>


@class JSONRequestProvider;


@interface AuthenticatedRequestProvider : NSObject

- (id)initWithAuthToken:(NSString *)token
        requestProvider:(JSONRequestProvider *)requestProvider;

- (NSURLRequest *)getRequestWithPath:(NSString *)path
                              params:(NSDictionary *)params;

- (NSURLRequest *)postRequestWithPath:(NSString *)path
                               params:(NSDictionary *)params;

- (NSURLRequest *)deleteRequestWithPath:(NSString *)path
                                 params:(NSDictionary *)params;

@end
