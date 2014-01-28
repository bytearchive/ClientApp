#import "ControllerModule.h"
#import "BSBinder.h"
#import "LoginController.h"
#import "BSInjector.h"
#import "AuthTokenRepository.h"


@implementation ControllerModule

#pragma mark - <BSModule>

- (void)configure:(id<BSBinder>)binder
{
    [binder bind:[LoginController class] toBlock:^id(NSArray *args, id<BSInjector> injector) {
        AuthTokenRepository *authTokenRepository = [injector getInstance:[AuthTokenRepository class]];
        return [[LoginController alloc] initWithAuthTokenRepository:authTokenRepository];
    }];
}

@end
