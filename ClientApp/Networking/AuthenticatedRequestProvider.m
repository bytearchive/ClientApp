#import "AuthenticatedRequestProvider.h"


@interface AuthenticatedRequestProvider ()

@property (strong, nonatomic) id<HTTPRequestProvider> requestProvider;
@property (copy, nonatomic) NSString *token;

@end


@implementation AuthenticatedRequestProvider

- (id)initWithAuthToken:(NSString *)token
        requestProvider:(id<HTTPRequestProvider>)requestProvider
{
    self = [super init];
    if (self) {
        self.token = token;
        self.requestProvider = requestProvider;
    }
    return self;
}

#pragma mark - <HTTPRequestProvider>

- (NSURLRequest *)postRequestWithPath:(NSString *)path
                               params:(NSDictionary *)params
{
    NSURLRequest *request = [self.requestProvider postRequestWithPath:path params:params];
    return [self addAuthTokenHeaderToRequest:request];
}

- (NSURLRequest *)getRequestWithPath:(NSString *)path
                              params:(NSDictionary *)params
{
    NSURLRequest *request = [self.requestProvider getRequestWithPath:path params:params];
    return [self addAuthTokenHeaderToRequest:request];
}

- (NSURLRequest *)deleteRequestWithPath:(NSString *)path
                                 params:(NSDictionary *)params
{
    NSURLRequest *request = [self.requestProvider deleteRequestWithPath:path params:params];
    return [self addAuthTokenHeaderToRequest:request];
}

#pragma mark - NSObject

- (id)init

{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

#pragma mark - Private

- (NSURLRequest *)addAuthTokenHeaderToRequest:(NSURLRequest *)request
{
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    NSString *authTokenString = [NSString stringWithFormat:@"Token %@", self.token];
    [mutableRequest setValue:authTokenString forHTTPHeaderField:@"Authorization"];
    return [mutableRequest copy];
}

@end
