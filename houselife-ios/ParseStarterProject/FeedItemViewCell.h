//
//  WishItemViewCell.h
//  HouseLife
//
//  Created by Yang Shun Tay on 12/1/12.
//
//

#import <UIKit/UIKit.h>

@interface FeedItemViewCell : UITableViewCell

@property (nonatomic, unsafe_unretained) IBOutlet UILabel *title;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *desc;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *assignee;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *thumb;

@end
