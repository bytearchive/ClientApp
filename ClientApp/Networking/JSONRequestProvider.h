#import <Foundation/Foundation.h>


@interface JSONRequestProvider : NSObject

- (id)initWithURLComponents:(NSURLComponents *)urlComponents;

- (NSURLRequest *)postRequestWithPath:(NSString *)path
                               params:(NSDictionary *)params;

- (NSURLRequest *)getRequestWithPath:(NSString *)path
                              params:(NSDictionary *)params;

- (NSURLRequest *)deleteRequestWithPath:(NSString *)path
                                 params:(NSDictionary *)params;

@end