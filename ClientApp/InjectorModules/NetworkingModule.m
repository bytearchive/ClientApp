#import "NetworkingModule.h"
#import "BSBinder.h"
#import "AuthTokenRepository.h"
#import "JSONRequestProvider.h"
#import "HTTPClient.h"
#import "JSONClient.h"
#import "DomainObjectClient.h"
#import "AuthTokenDeserializer.h"
#import "AuthTokenService.h"
#import "BSSingleton.h"
#import "BSInjector.h"


@implementation NetworkingModule

#pragma mark - <BSModule>

- (void)configure:(id<BSBinder>)binder
{
    [binder bind:[HTTPClient class] toBlock:^id(NSArray *args, id<BSInjector> injector) {
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
        NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
        NSIndexSet *acceptableStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 200)];
        HTTPClient *httpClient = [[HTTPClient alloc] initWithSession:session
                                                               queue:mainQueue
                                               acceptableStatusCodes:acceptableStatusCodes];
        return httpClient;
    }];
    
    [binder bind:[JSONClient class] toBlock:^id(NSArray *args, id<BSInjector> injector) {
        id <RequestPromiseClient> requestPromiseClient = [injector getInstance:[HTTPClient class]];
        JSONClient *jsonClient = [[JSONClient alloc] initWithRequestPromiseClient:requestPromiseClient];
        return jsonClient;
    }];
    
    [binder bind:[DomainObjectClient class] toBlock:^id(NSArray *args, id<BSInjector> injector) {
        id <RequestPromiseClient> requestPromiseClient = [injector getInstance:[JSONClient class]];
        DomainObjectClient *domainObjectClient = [[DomainObjectClient alloc] initWithRequestPromiseClient:requestPromiseClient];
        return domainObjectClient;
    }];
    
    [binder bind:[AuthTokenDeserializer class] toBlock:^id(NSArray *args, id<BSInjector> injector) {
        return [[AuthTokenDeserializer alloc] init];;
    }];
    
    [binder bind:[AuthTokenService class] toBlock:^id(NSArray *args, id<BSInjector> injector) {
        NSURLComponents *components = [self urlComponents];
        id <HTTPRequestProvider> requestProvider = [[JSONRequestProvider alloc] initWithURLComponents:components];
        DomainObjectClient *domainObjectClient = [injector getInstance:[DomainObjectClient class]];
        id <Deserializer> authTokenDeserializer = [injector getInstance:[AuthTokenDeserializer class]];
        AuthTokenService *authTokenService = [[AuthTokenService alloc] initWithRequestProvider:requestProvider
                                                                            domainObjectClient:domainObjectClient
                                                                                  deserializer:authTokenDeserializer];
        return authTokenService;
    }];
    
    [binder bind:[AuthTokenRepository class] toBlock:^id(NSArray *args, id<BSInjector> injector) {
        AuthTokenService *authTokenService = [injector getInstance:[AuthTokenService class]];
        AuthTokenRepository *authTokenRepository = [[AuthTokenRepository alloc] initWithAuthTokenService:authTokenService];
        return authTokenRepository;
    }];
    
    [binder bind:[HTTPClient class] withScope:[BSSingleton scope]];
    [binder bind:[JSONClient class] withScope:[BSSingleton scope]];
    [binder bind:[DomainObjectClient class] withScope:[BSSingleton scope]];
    [binder bind:[AuthTokenDeserializer class] withScope:[BSSingleton scope]];
    [binder bind:[AuthTokenService class] withScope:[BSSingleton scope]];
    [binder bind:[AuthTokenRepository class] withScope:[BSSingleton scope]];
}

#pragma mark - Private

- (NSURLComponents *)urlComponents
{
    NSString *host = @"some-server.com";
    NSNumber *port = @80;
#if defined(LOCALHOST)
    host = @"localhost";
    port = @5000;
#endif
    NSURLComponents *urlComponents = [[NSURLComponents alloc] init];
    urlComponents.scheme = @"http";
    urlComponents.host = host;
    urlComponents.port = port;
    return urlComponents;
}

@end
