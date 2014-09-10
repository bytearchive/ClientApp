#import <UIKit/UIKit.h>


@protocol PDCreationClient;


@interface LoginController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

- (instancetype)init __attribute__((unavailable("Please use initWithAuthTokenCreator:tapRecognizer: when initializing LoginController")));

- (id)initWithAuthTokenCreator:(id<PDCreationClient>)authTokenCreator
                 tapRecognizer:(UITapGestureRecognizer *)tapRecognizer;

@end