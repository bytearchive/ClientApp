#import <UIKit/UIKit.h>


@class AuthTokenRepository;


@interface LoginController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

- (id)initWithAuthTokenRepository:(AuthTokenRepository *)authTokenRepository
                    tapRecognizer:(UITapGestureRecognizer *)tapRecognizer;

@end