#import <Foundation/Foundation.h>


@protocol HTTPRequestProvider <NSObject>

- (NSURLRequest *)getRequestWithPath:(NSString *)path
                              params:(NSDictionary *)params;

- (NSURLRequest *)postRequestWithPath:(NSString *)path
                               params:(NSDictionary *)params;

- (NSURLRequest *)deleteRequestWithPath:(NSString *)path
                                 params:(NSDictionary *)params;

@end
