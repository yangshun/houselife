//
//  FeedViewController.h
//  HouseLife
//
//  Created by Yang Shun Tay on 12/1/12.
//
//

#import <UIKit/UIKit.h>
#import "FeedItemViewCell.h"
#import "Parse/Parse.h"

@interface FeedViewController : PFQueryTableViewController <UIActionSheetDelegate>
@property (nonatomic, strong) IBOutlet FeedItemViewCell *feedCell;

@end
