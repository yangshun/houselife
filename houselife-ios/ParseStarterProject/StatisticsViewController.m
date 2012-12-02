//
//  StatisticsViewController.m
//  HouseLife
//
//  Created by Yang Shun Tay on 12/2/12.
//
//

#import "StatisticsViewController.h"

@interface StatisticsViewController () {
    
    IBOutlet UIImageView *thumb1;
    IBOutlet UIImageView *thumb2;
    IBOutlet UIImageView *thumb3;
    IBOutlet UIImageView *thumb4;
    IBOutlet UIImageView *thumb5;
    
    IBOutlet UILabel *label1;
    IBOutlet UILabel *label2;
    IBOutlet UILabel *label3;
    IBOutlet UILabel *label4;
    IBOutlet UILabel *label5;
    
    IBOutlet UIView *bluebar1;
    IBOutlet UIView *bluebar2;
    IBOutlet UIView *bluebar3;
    IBOutlet UIView *bluebar4;
    IBOutlet UIView *bluebar5;
    
    int value1;
    int value2;
    int value3;
    int value4;
    int value5;
    NSArray *thumb;
    
    IBOutlet UILabel *nameLabel1;
    IBOutlet UILabel *nameLabel2;
    IBOutlet UILabel *nameLabel3;
    IBOutlet UILabel *nameLabel4;
    IBOutlet UILabel *nameLabel5;
    NSArray *nameArray;
}

@end

@implementation StatisticsViewController

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
    // Do any additional setup after loading the view from its nib.
    
    value1 = 5;
    value2 = 3;
    value3 = 11;
    value4 = 9;
    value5 = 13;
    
    thumb = [[NSArray alloc] initWithObjects:thumb1, thumb2, thumb3, thumb4, thumb5, nil];
    nameArray = [[NSArray alloc] initWithObjects:nameLabel1, nameLabel2, nameLabel3, nameLabel4, nameLabel5, nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    
}

- (void)animateThumbnail:(UIImageView*)imv {
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    for (UILabel *label in nameArray) {
        label.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }
    
    
    int i = 0;
    for (UIImageView *imv in thumb) {
        imv.center = CGPointMake(imv.center.x, imv.center.y + 100);
        imv.alpha = 0.0f;
        
        UILabel *label = nameArray[i];
        label.alpha = 0.0f;
        label.center = CGPointMake(label.center.x, label.center.y + 100);
        [UIView animateWithDuration:0.3f
                              delay:(0.2f * i)
                            options:UIViewAnimationCurveEaseIn
                         animations:^{
                             imv.center = CGPointMake(imv.center.x, imv.center.y - 125);
                             imv.alpha = 1.0f;
                            
                             label.center = CGPointMake(label.center.x, label.center.y - 125);
                             label.alpha = 1.0f;
                         }
                         completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.3f
                                                   delay:0.0f
                                                 options:UIViewAnimationCurveEaseOut
                                              animations:^{
                                                  imv.center = CGPointMake(imv.center.x,
                                                                           imv.center.y + 25);
                                                  label.center = CGPointMake(label.center.x, label.center.y + 25);
                                              } completion:^(BOOL finished){
                                                  if (i == 4) {
                                                      [UIView animateWithDuration:1.0f animations:^{
                                                          CGFloat distance = value1 * 15;
                                                          UILabel *label = label1;
                                                          label.hidden = NO;
                                                          label.text = [NSString stringWithFormat:@"%d", value1];
                                                          UIView *bluebar = bluebar1;
                                                          label.center = CGPointMake(label.center.x, label.center.y - distance);
                                                          bluebar.frame = CGRectMake(bluebar.frame.origin.x, bluebar.frame.origin.y - distance,
                                                                                     bluebar.frame.size.width, bluebar.frame.size.height + distance);
                                                          distance = value2 * 15;
                                                          label = label2;
                                                          label.hidden = NO;
                                                          label.text = [NSString stringWithFormat:@"%d", value2];
                                                          bluebar = bluebar2;
                                                          label.center = CGPointMake(label.center.x, label.center.y - distance);
                                                          bluebar.frame = CGRectMake(bluebar.frame.origin.x, bluebar.frame.origin.y - distance,
                                                                                     bluebar.frame.size.width, bluebar.frame.size.height + distance);
                                                          distance = value3 * 15;
                                                          label = label3;
                                                          label.hidden = NO;
                                                          label.text = [NSString stringWithFormat:@"%d", value3];
                                                          bluebar = bluebar3;
                                                          label.center = CGPointMake(label.center.x, label.center.y - distance);
                                                          bluebar.frame = CGRectMake(bluebar.frame.origin.x, bluebar.frame.origin.y - distance,
                                                                                     bluebar.frame.size.width, bluebar.frame.size.height + distance);
                                                          distance = value4 * 15;
                                                          label = label4;
                                                          label.hidden = NO;
                                                          label.text = [NSString stringWithFormat:@"%d", value4];
                                                          bluebar = bluebar4;
                                                          label.center = CGPointMake(label.center.x, label.center.y - distance);
                                                          bluebar.frame = CGRectMake(bluebar.frame.origin.x, bluebar.frame.origin.y - distance,
                                                                                     bluebar.frame.size.width, bluebar.frame.size.height + distance);
                                                          distance = value5 * 15;
                                                          label = label5;
                                                          label.hidden = NO;
                                                          label.text = [NSString stringWithFormat:@"%d", value5];
                                                          bluebar = bluebar5;
                                                          label.center = CGPointMake(label.center.x, label.center.y - distance);
                                                          bluebar.frame = CGRectMake(bluebar.frame.origin.x, bluebar.frame.origin.y - distance,
                                                                                     bluebar.frame.size.width, bluebar.frame.size.height + distance);
                                                      }];
                                                  }
                                              }];
                         }];
        i++;
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
