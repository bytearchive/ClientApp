#import "JSONRequestProvider.h"


@interface JSONRequestProvider ()

@property(strong, nonatomic) NSURLComponents *urlComponents;

@end


@implementation JSONRequestProvider

- (id)initWithURLComponents:(NSURLComponents *)urlComponents
{
    self = [super init];
    if (self) {
        self.urlComponents = urlComponents;
    }
    return self;
}

#pragma mark - <HTTPRequestProvider>

- (NSURLRequest *)postRequestWithPath:(NSString *)path
                               params:(NSDictionary *)params
{
    NSMutableURLRequest *request = [self mutableURLRequestWithPath:path httpMethod:@"POST"];
    
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
    NSUInteger bodyDataLength = [bodyData length];
    NSString *bodyDataLengthString = [NSString stringWithFormat:@"%lu", (unsigned long)bodyDataLength];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:bodyDataLengthString forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:bodyData];

    return request;
}

- (NSURLRequest *)getRequestWithPath:(NSString *)path
                              params:(NSDictionary *)params
{
    NSMutableURLRequest *request = [self mutableURLRequestWithPath:path httpMethod:@"GET"];
    return request;
}

- (NSURLRequest *)deleteRequestWithPath:(NSString *)path
                                 params:(NSDictionary *)params
{
    NSMutableURLRequest *request = [self mutableURLRequestWithPath:path httpMethod:@"DELETE"];
    return request;
}

#pragma mark - NSObject

- (id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

#pragma mark - Private

- (NSMutableURLRequest *)mutableURLRequestWithPath:(NSString *)path
                                        httpMethod:(NSString *)httpMethod
{
    NSURLComponents *components = [self.urlComponents copy];
    components.path = path;
    NSURL *url = [components URL];
    NSMutableURLRequest *mutableURLRequest = [NSMutableURLRequest requestWithURL:url];
    [mutableURLRequest setHTTPMethod:httpMethod];
    [mutableURLRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    return mutableURLRequest;
}

@end