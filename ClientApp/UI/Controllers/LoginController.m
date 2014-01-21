#import "LoginController.h"
#import "KSPromise.h"
#import "AuthTokenRepository.h"


@interface LoginController () <UITextFieldDelegate>

@property (strong, nonatomic) AuthTokenRepository *authTokenRepository;
@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;

@end


@implementation LoginController

- (id)initWithAuthTokenRepository:(AuthTokenRepository *)authTokenRepository
                    tapRecognizer:(UITapGestureRecognizer *)tapRecognizer
{
    self = [super init];
    if (self) {
        self.authTokenRepository = authTokenRepository;
        self.tapRecognizer = tapRecognizer;
    }
    return self;
}

#pragma mark - UIViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Login";
    [self.tapRecognizer addTarget:self action:@selector(didTapBackgroundView:)];
    [self.view addGestureRecognizer:self.tapRecognizer];
}

#pragma mark - <UITextFieldDelegate>

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.usernameField) {
        [self.passwordField becomeFirstResponder];
    }
    else if ((textField == self.passwordField) && self.usernameField.text.length == 0) {
        [self.usernameField becomeFirstResponder];
    }
    else {
        [self login];
    }
    return YES;
}

- (IBAction)didTapSignInButton:(id)sender
{
    [self login];
}

#pragma mark - Private

- (void)didTapBackgroundView:(UITapGestureRecognizer *)tapRecognizer
{
    [self dropKeyboard];
}


- (void)login
{
    [self dropKeyboard];
    self.view.userInteractionEnabled = NO;
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    KSPromise *promise = [self.authTokenRepository tokenPromiseWithUsername:username
                                                                   password:password];
    __weak typeof(self) weakSelf = self;
    [promise then:^id(NSString *authToken) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.view.userInteractionEnabled = YES;
        
        NSString *successString = [NSString stringWithFormat:@"here's your auth token: %@", authToken];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"You logged in successfully"
                                                            message:successString
                                                           delegate:nil
                                                  cancelButtonTitle:@"Uh ... OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        
        return authToken;
    } error:^id(NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.view.userInteractionEnabled = YES;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Login Problem"
                                                            message:@"There was a problem logging in, please try again."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        return error;
    }];
}

- (void)dropKeyboard
{
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

@end