#import <UIKit/UIKit.h>


@class AuthTokenRepository;


@interface LoginController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

- (id)initWithAuthTokenRepository:(AuthTokenRepository *)authTokenRepository
                    tapRecognizer:(UITapGestureRecognizer *)tapRecognizer;

@end