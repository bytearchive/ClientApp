#import <UIKit/UIKit.h>


@protocol BSInjector;


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic, readonly) id <BSInjector> injector;
@property (strong, nonatomic) UIWindow *window;

@end
