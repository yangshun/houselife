//
//  AddFeedViewController.m
//  HouseLife
//
//  Created by Yang Shun Tay on 12/2/12.
//
//

#import "AddFeedViewController.h"
#import <Parse/Parse.h>

@interface AddFeedViewController () {
    IBOutlet UIImageView *arrow;
    int currentIndex;
    IBOutlet UITextField *titleField;
    IBOutlet UITextField *desc;

}

@end

@implementation AddFeedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    currentIndex = 2;

    // Do any additional setup after loading the view from its nib.
}

- (IBAction)done {
    
    NSString *assignee_id;
    
    switch (currentIndex) {
        case 0:
            // chenyang
            assignee_id = @"Mug7rHmPUm";
            break;
        case 1:
            // waiyin
            assignee_id = @"23RLBVtAso";
            break;
        case 2:
            // yangshun
            assignee_id = @"vYGFgMbOUX";
            break;
        case 3:
            // xialang
            assignee_id = @"eoWdgTClmN";
            break;
        case 4:
            // hendy
            assignee_id = @"hbmdSfsTBe";
            break;
        default:
//            assignee_id = [NSNull null];
            break;
    }
    
    PFObject *object = [PFObject objectWithClassName:@"task"];
    [object setObject:assignee_id forKey:@"assignee_id"];
    
    NSString *titleString = [NSString stringWithFormat:@"%@", titleField.text];
    if ([titleString isEqualToString:@""]) {
        titleString = @"< No Title >";
    }
    NSLog(@"title: %@", titleString);
    
    NSString *descString =[NSString stringWithFormat:@"%@", desc.text];
    if ([descString isEqualToString:@""]) {
        descString = @"< No Description >";
    }
    NSLog(@"desc: %@", descString);
    
    [object setObject:titleString forKey:@"title"];
    
    [object setObject:descString forKey:@"description"];
    
    [object setObject:@"0dYzLuyY7C" forKey:@"household_id"];
    
    [object setObject:[NSNumber numberWithInt:0] forKey:@"status"];
    
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshTable" object:nil];
            [self dismissModalViewControllerAnimated:YES];
        }
    }];
}

- (IBAction)cancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)random {
    
    int index = arc4random() % 5;
    
    while (index == currentIndex) {
        index = arc4random() % 5;
    }
    
    currentIndex = index;
    [UIView animateWithDuration:0.3f animations:^{
        arrow.center = CGPointMake(70 + currentIndex * 45, arrow.center.y);
    }];
}

- (IBAction)select:(UIButton*)sender {
    currentIndex = sender.tag;
    [UIView animateWithDuration:0.3f animations:^{
        arrow.center = CGPointMake(70 + currentIndex * 45, arrow.center.y);
    }];
}

- (IBAction)laziest {
    currentIndex = 1;
    [UIView animateWithDuration:0.3f animations:^{
        arrow.center = CGPointMake(70 + currentIndex * 45, arrow.center.y);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
