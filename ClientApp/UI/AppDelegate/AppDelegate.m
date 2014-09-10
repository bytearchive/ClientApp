#import "AppDelegate.h"
#import "LoginController.h"
#import "AuthTokenDeserializer.h"
#import "PDNetworkResourceProvider.h"
#import "AuthTokenSerializer.h"
#import "AuthTokenDeserializer.h"
#import "PDDeserializer.h"
#import "PDNetworkClientProvider.h"
#import "PDCreationClient.h"
#import "PDDomainObjectClient.h"
#import "PDURLSessionClient.h"
#import "PDHTTPClient.h"
#import "PDJSONClient.h"
#import "PDJSONRequestProvider.h"
#import "PDURLSessionClientDelegate.h"
#import "PDParameterToQueryStringEncoder.h"


@interface AppDelegate () <PDURLSessionClientDelegate>
@end


static NSString *const httpErrorDomain = @"com.myapp.http";


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    PDNetworkResourceProvider *networkResourceProvider = [[PDNetworkResourceProvider alloc] init];
    PDNetworkClientProvider *networkClientProvider = [[PDNetworkClientProvider alloc] init];
    
    // NSOperationQueues
    //
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    
    // Paths
    //
    NSString * (^authTokenPathBlock) (NSString *) = ^ NSString *(__unused id requestParams) { return @"/api/auth/token/"; };
    
    // Serializers
    //
    id<PDRequestParametersSerializer> createAuthTokenRequestParametersSerializer = [[AuthTokenSerializer alloc] init];
    
    // Deserializers
    //
    id<PDDeserializer> authTokenDeserializer = [[AuthTokenDeserializer alloc] init];
    
    // Network Resources
    //
    id<PDNetworkResource> createAuthTokenResource = [networkResourceProvider creationResourceWithPathConfigurationBlock:authTokenPathBlock
                                                                                            requestParametersSerializer:createAuthTokenRequestParametersSerializer
                                                                                                           deserializer:authTokenDeserializer];
    
    // PDRequesters
    //
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    NSIndexSet *acceptableStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 200)];
    
    PDURLSessionClient *URLSessionClient = [[PDURLSessionClient alloc] initWithURLSession:session queue:mainQueue];
    URLSessionClient.delegate = self;
    id<PDRequester> HTTPClient = [[PDHTTPClient alloc] initWithRequester:URLSessionClient acceptableStatusCodes:acceptableStatusCodes errorDomain:httpErrorDomain];
    id<PDRequester> JSONClient = [[PDJSONClient alloc] initWithRequester:HTTPClient];
    
    NSURLComponents *URLComponents = [self urlComponents];
    PDParameterToQueryStringEncoder *parameterEncoder = [[PDParameterToQueryStringEncoder alloc] initWithStringEncoding:NSUTF8StringEncoding];
    id<PDRequestProvider> JSONRequestProvider = [[PDJSONRequestProvider alloc] initWithURLComponents:URLComponents parameterEncoder:parameterEncoder];
    PDDomainObjectClient *domainObjectClient = [[PDDomainObjectClient alloc] initWithRequester:JSONClient
                                                                               requestProvider:JSONRequestProvider
                                                                                         queue:mainQueue];
    // Network clients
    //
    id<PDCreationClient> authTokenCreator = [networkClientProvider networkClientWithNetworkResource:createAuthTokenResource
                                                                                 domainObjectClient:domainObjectClient];

    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] init];
    LoginController *loginController = [[LoginController alloc] initWithAuthTokenCreator:authTokenCreator tapRecognizer:tapRecognizer];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginController];
    
    UIScreen *mainScreen = [UIScreen mainScreen];
    self.window = [[UIWindow alloc] initWithFrame:[mainScreen bounds]];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark - <PDURLSessionClientDelegate>

- (void)URLSessionClient:(PDURLSessionClient *)client
          didSendRequest:(NSURLRequest *)request
{
    UIApplication *application = [UIApplication sharedApplication];
    application.networkActivityIndicatorVisible = YES;
}

- (void)URLSessionClient:(PDURLSessionClient *)client
      didUpdateDataTasks:(NSArray *)dataTasks
             uploadTasks:(NSArray *)uploadTasks
           downloadTasks:(NSArray *)downloadTasks
{
    UIApplication *application = [UIApplication sharedApplication];
    application.networkActivityIndicatorVisible = dataTasks.count > 0;
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
