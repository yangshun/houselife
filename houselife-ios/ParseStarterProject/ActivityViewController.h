//
//  ActivityViewController.h
//  HouseLife
//
//  Created by Yang Shun Tay on 12/1/12.
//
//

#import <UIKit/UIKit.h>
#import "ActivityItemViewCell.h"
#import "Parse/Parse.h"

@interface ActivityViewController : PFQueryTableViewController

@property (nonatomic, strong) IBOutlet ActivityItemViewCell *activityCell;

@end
