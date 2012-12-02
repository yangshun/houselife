//
//  NearbyViewController.h
//  HouseLife
//
//  Created by Yang Shun Tay on 12/2/12.
//
//

#import <UIKit/UIKit.h>

#import <ContextCore/QLContextCoreConnector.h>
#import <ContextLocation/QLContextPlaceConnector.h>
#import <ContextProfiling/PRContextInterestsConnector.h>

@interface NearbyViewController : UIViewController <QLContextCorePermissionsDelegate,
QLContextPlaceConnectorDelegate, PRContextInterestsDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) QLContextCoreConnector *contextCoreConnector;
@property (nonatomic, strong) QLContextPlaceConnector *contextPlaceConnector;
@property (nonatomic, strong) PRContextInterestsConnector *contextInterestsConnector;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *placeNameLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *enableSDKButton;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *contentInfoLabel;

- (IBAction)enableSDK:(id)sender;
- (IBAction)showPermissions:(id)sender;

@end
