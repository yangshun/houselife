//
//  NearbyViewController.m
//  HouseLife
//
//  Created by Yang Shun Tay on 12/2/12.
//
//

#import "NearbyViewController.h"
#import <ContextLocation/QLContentDescriptor.h>
#import <ContextLocation/QLPlaceEvent.h>
#import <ContextCore/QLContextConnectorPermissions.h>
#import <ContextProfiling/PRProfile.h>
#import <ContextCore/QLContextCoreError.h>
#import <ContextLocation/QLPlace.h>

@interface NearbyViewController ()

- (void)displayLastKnownPlaceEvent;
- (void)savePlaceEvent:(QLPlaceEvent *)placeEvent;
- (void)displaceLastKnownContentDescriptor;

@end

@implementation NearbyViewController {
    
    IBOutlet UIImageView *map;
}

@synthesize contextCoreConnector;
@synthesize contextPlaceConnector;
@synthesize contextInterestsConnector;


@synthesize enableSDKButton;
@synthesize contentInfoLabel;
@synthesize placeNameLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.contextCoreConnector = [[QLContextCoreConnector alloc] init];
    self.contextCoreConnector.permissionsDelegate = self;
    
    self.contextPlaceConnector = [[QLContextPlaceConnector alloc] init];
    self.contextPlaceConnector.delegate = self;
    
    self.contextInterestsConnector = [[PRContextInterestsConnector alloc] init];
    self.contextInterestsConnector.delegate = self;
    
    [self.contextCoreConnector checkStatusAndOnEnabled:^(QLContextConnectorPermissions *contextConnectorPermissions) {
        if (contextConnectorPermissions.subscriptionPermission)
        {
            if (contextPlaceConnector.isPlacesEnabled)
            {
                [self displayLastKnownPlaceEvent];
            }
        }
    } disabled:^(NSError *error) {
          NSLog(@"%@", error);
          
          if (error.code == QLContextCoreNonCompatibleOSVersion)
          {
              NSLog(@"%@", @"SDK Requires iOS 5.0 or higher");
          }
          else
          {
              enableSDKButton.enabled = YES;
              self.placeNameLabel.text = nil;
              self.contentInfoLabel.text = nil;
          }
      }];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showMapAndAlert:(id)sender {
    [UIView animateWithDuration:0.5f
                     animations:^{
                         map.alpha = 1.0f;
                     } completion:^(BOOL finished){
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"MacDonalds nearby"
                                                                         message:@"There is a MacDonalds nearby where you can buy dinner."
                                                                        delegate:self
                                                               cancelButtonTitle:@"Okay" otherButtonTitles: nil];
                         [alert show];
                     }];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
}

- (IBAction)enableSDK:(id)sender
{
    [contextCoreConnector enableFromViewController:self
                                           success:^{
                                               enableSDKButton.enabled = NO;
                                           }
                                           failure:^(NSError *error) {
                                               NSLog(@"%@", error);
                                           }];
}

- (IBAction)showPermissions:(id)sender
{
    [contextCoreConnector showPermissionsFromViewController:self];
}

- (void)displayLastKnownPlaceEvent
{
    self.placeNameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"PlaceEventKey"];
}

- (void)savePlaceEvent:(QLPlaceEvent *)placeEvent
{
    NSString *placeTitle = nil;
    switch (placeEvent.eventType)
    {
        case QLPlaceEventTypeAt:
            placeTitle = [NSString stringWithFormat:@"At %@", placeEvent.place.name];
            break;
        case QLPlaceEventTypeLeft:
            placeTitle = [NSString stringWithFormat:@"Left %@", placeEvent.place.name];
            break;
    }
    [[NSUserDefaults standardUserDefaults] setObject:placeTitle forKey:@"PlaceEventKey"];
}

- (void)displaceLastKnownContentDescriptor
{
    [self.contextPlaceConnector requestContentHistoryAndOnSuccess:^(NSArray *contentHistories)
     {
         QLContentDescriptor *lastKnownContentDescriptor = [contentHistories lastObject];
         self.contentInfoLabel.text = lastKnownContentDescriptor.title;
     }
                                                          failure:^(NSError *error)
     {
         NSLog(@"Failed to fetch content: %@", [error localizedDescription]);
     }];
}

- (void)postOneContentDescriptorLocalNotification:(QLContentDescriptor *)contentDescriptor
{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.alertAction = NSLocalizedString(@"Foo", nil);
    localNotification.alertBody = [NSString stringWithFormat:@"%@", contentDescriptor.title];
    localNotification.applicationIconBadgeNumber++;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}


#pragma mark - QLContextCorePermissionsDelegate methods

- (void)subscriptionPermissionDidChange:(BOOL)subscriptionPermission
{
    if (subscriptionPermission)
    {
        if (contextPlaceConnector.isPlacesEnabled)
        {
            [self displayLastKnownPlaceEvent];
        }
        else
        {
            self.placeNameLabel.text = @"";
        }
        enableSDKButton.enabled = NO;
    }
    else
    {
        self.placeNameLabel.text = @"Subscription permission off";
        self.contentInfoLabel.text = @"";
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
}


#pragma mark - QLContextPlaceConnectorDelegate methods

- (void)didGetPlaceEvent:(QLPlaceEvent *)placeEvent
{
    [self savePlaceEvent:placeEvent];
    [self displayLastKnownPlaceEvent];
}

- (void)didGetContentDescriptors:(NSArray *)contentDescriptors
{
    self.contentInfoLabel.text = [[contentDescriptors lastObject] title];
    
    [self displaceLastKnownContentDescriptor];
    
    for (QLContentDescriptor *contentDescriptor in contentDescriptors)
    {
        [self postOneContentDescriptorLocalNotification:contentDescriptor];
    }
    
}

- (void)placesPermissionDidChange:(BOOL)placesPermission
{
    if (placesPermission)
    {
        [self displayLastKnownPlaceEvent];
        [self displaceLastKnownContentDescriptor];
    }
    else
    {
        self.placeNameLabel.text = @"Location Permission turned off by user";
        self.contentInfoLabel.text = @"";
    }
}


#pragma mark - QLContextCorePermissionsDelegate methods

- (void)interestsDidChange:(PRProfile *)interests
{
    //NSLog(@"User profile did change: %@", [interests description]);
}

- (void)interestsPermissionDidChange:(BOOL)interestsPermission
{
    NSLog(@"Interests permission did change to: %d", interestsPermission);
}



@end
