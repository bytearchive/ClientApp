#import "AppDelegate.h"
#import "LoginController.h"
#import "AuthTokenRepository.h"
#import "AuthTokenService.h"
#import "JSONRequestProvider.h"
#import "HTTPClient.h"
#import "JSONClient.h"
#import "DomainObjectClient.h"
#import "Deserializer.h"
#import "AuthTokenDeserializer.h"
#import "RequestPromiseClient.h"
#import "HTTPClientDelegate.h"


@interface AppDelegate () <HTTPClientDelegate>
@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSURLComponents *urlComponents = [self urlComponents];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    NSIndexSet *acceptableStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 200)];
    
    id<HTTPRequestProvider> jsonRequestProvider = [[JSONRequestProvider alloc] initWithURLComponents:urlComponents];
    
    
    HTTPClient *httpClient = [[HTTPClient alloc] initWithSession:session
                                                                         queue:mainQueue
                                                         acceptableStatusCodes:acceptableStatusCodes];
    httpClient.delegate = self;
    
    id <RequestPromiseClient> jsonClient = [[JSONClient alloc] initWithRequestPromiseClient:httpClient];
    DomainObjectClient *domainObjectClient = [[DomainObjectClient alloc] initWithRequestPromiseClient:jsonClient];
    
    id <Deserializer> authTokenDeserializer = [[AuthTokenDeserializer alloc] init];
    AuthTokenService *authTokenService = [[AuthTokenService alloc] initWithRequestProvider:jsonRequestProvider
                                                                        domainObjectClient:domainObjectClient
                                                                              deserializer:authTokenDeserializer];
    AuthTokenRepository *authTokenRepository = [[AuthTokenRepository alloc] initWithAuthTokenService:authTokenService];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] init];
    LoginController *loginController = [[LoginController alloc] initWithAuthTokenRepository:authTokenRepository
                                                                              tapRecognizer:tapRecognizer];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginController];
    
    UIScreen *mainScreen = [UIScreen mainScreen];
    self.window = [[UIWindow alloc] initWithFrame:[mainScreen bounds]];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark - <HTTPClientDelegate>

- (void)httpClient:(HTTPClient *)httpClient didSendRequest:(NSURLRequest *)request
{
    UIApplication *application = [UIApplication sharedApplication];
    application.networkActivityIndicatorVisible = YES;
}

- (void)httpClient:(HTTPClient *)httpClient didUpdateTaskCount:(NSUInteger)updatedTaskCount
{
    UIApplication *application = [UIApplication sharedApplication];
    application.networkActivityIndicatorVisible = updatedTaskCount > 0;
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
