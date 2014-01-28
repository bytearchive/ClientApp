#import "AppDelegate.h"
#import "LoginController.h"
#import "HTTPClient.h"
#import "Deserializer.h"
#import "HTTPClientDelegate.h"
#import "Blindside.h"
#import "NetworkingModule.h"
#import "ControllerModule.h"


@interface AppDelegate () <HTTPClientDelegate>

@property (strong, nonatomic) id <BSInjector> injector;

@end


@implementation AppDelegate

- (id)init
{
    self = [super init];
    if (self) {
        id <BSModule> networkingModule = [[NetworkingModule alloc] init];
        id <BSModule> controllerModule = [[ControllerModule alloc] init];
        self.injector = [Blindside injectorWithModules:@[networkingModule, controllerModule]];
    }
    return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    HTTPClient *httpClient = [self.injector getInstance:[HTTPClient class]];
    httpClient.delegate = self;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] init];
    LoginController *loginController = [self.injector getInstance:[LoginController class]];
    [loginController setupWithTapRecognizer:tapRecognizer];
    
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

@end
