#import "ParseStarterProjectViewController.h"
#import <Parse/Parse.h>
#import "FeedViewController.h"
#import "DDMenuController.h"
#import "ParseStarterProjectAppDelegate.h"
#import "LeftController.h"

#define kOFFSET_FOR_KEYBOARD 216.0

@implementation ParseStarterProjectViewController {
    
    IBOutlet UIImageView *logo;
    IBOutlet UITextField *username;
    IBOutlet UITextField *password;
    IBOutlet UIView *container;

}


- (IBAction)signin:(UIButton*)sender {

    FeedViewController *mainController = [[FeedViewController alloc] init];
    mainController.title = @"HouseLife";
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mainController];
    
    DDMenuController *rootController = [[DDMenuController alloc] initWithRootViewController:navController];
    
    ParseStarterProjectAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.menuController = rootController;
    
    LeftController *leftController = [[LeftController alloc] init];
    rootController.leftViewController = leftController;
    
    [self presentViewController:rootController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - UIViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(IBAction)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

- (IBAction)hideKeyboard {
    [username resignFirstResponder];
    [password resignFirstResponder];
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    if ([sender isEqual:username] || [sender isEqual:password])
    {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    username.text = @"";
    password.text = @"";
    container.center = CGPointMake(container.center.x, container.center.y + container.frame.size.height);
    logo.center = CGPointMake(logo.center.x, logo.center.y - logo.frame.size.height);
    
}

- (void)viewDidAppear:(BOOL)animated {
    [UIView animateWithDuration:1.0f animations:^{
        container.center = CGPointMake(container.center.x, container.center.y - container.frame.size.height);
        logo.center = CGPointMake(logo.center.x, logo.center.y + logo.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}



@end
