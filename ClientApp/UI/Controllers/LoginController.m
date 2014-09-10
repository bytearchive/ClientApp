#import "LoginController.h"
#import "KSPromise.h"
#import "PDCreationClient.h"
#import "AuthTokenParams.h"
#import "PDHTTPClient.h"


@interface LoginController () <UITextFieldDelegate>

@property (nonatomic) id<PDCreationClient> authTokenCreator;
@property (nonatomic) UITapGestureRecognizer *tapRecognizer;

@end


@implementation LoginController

- (id)initWithAuthTokenCreator:(id<PDCreationClient>)authTokenCreator
                 tapRecognizer:(UITapGestureRecognizer *)tapRecognizer
{
    self = [super init];
    if (self) {
        self.authTokenCreator = authTokenCreator;
        self.tapRecognizer = tapRecognizer;
    }
    return self;
}

#pragma mark - NSObject

- (instancetype)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    UITextField *otherTextField = (textField == self.usernameField) ? self.passwordField : self.usernameField;
    NSString *updatedText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.loginButton.enabled = (updatedText.length > 0 && otherTextField.text.length > 0);
    return YES;
}

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
    [self.spinner startAnimating];
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    AuthTokenParams *authTokenParams = [[AuthTokenParams alloc] initWithUsername:username password:password];
    KSPromise *promise = [self.authTokenCreator creationPromiseWithRequestParameters:authTokenParams];
    [promise then:^id(NSString *authToken) {
        self.view.userInteractionEnabled = YES;
        [self.spinner stopAnimating];
        NSString *successString = [NSString stringWithFormat:@"here's your auth token: %@", authToken];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"You logged in successfully"
                                                            message:successString
                                                           delegate:nil
                                                  cancelButtonTitle:@"Uh ... OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        
        return authToken;
    } error:^id(NSError *error) {
        NSDictionary *userInfo = error.userInfo;
        NSData *errorData = userInfo[PDHTTPClientErrorDataKey];
        NSError *deserializationError;
        NSDictionary *serverErrorDictionary = [NSJSONSerialization JSONObjectWithData:errorData options:0 error:&deserializationError];
        
        NSArray *usernameErrors = serverErrorDictionary[@"username"];
        NSArray *passwordErrors = serverErrorDictionary[@"password"];
        NSArray *nonFieldErrors = serverErrorDictionary[@"non_field_errors"];
        
        NSMutableString *errorMessageString = [[NSMutableString alloc] init];
        if (usernameErrors) {
            NSString *usernameErrorString = [NSString stringWithFormat:@"Username: %@\n", [usernameErrors componentsJoinedByString:@", "]];
            [errorMessageString appendString:usernameErrorString];
        }
        
        if (passwordErrors) {
            NSString *passwordErrorString = [NSString stringWithFormat:@"Password: %@\n", [passwordErrors componentsJoinedByString:@", "]];
            [errorMessageString appendString:passwordErrorString];
        }
        
        ;
        if (nonFieldErrors) {
            NSString *nonFieldErrorsString = [nonFieldErrors componentsJoinedByString:@", "];
            [errorMessageString appendString:nonFieldErrorsString];
        }
        NSString *errorMessage = [NSString stringWithFormat:@"There was a problem logging in\n\n%@", errorMessageString];
        
        self.view.userInteractionEnabled = YES;
        [self.spinner stopAnimating];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Login Problem"
                                                            message:errorMessage
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