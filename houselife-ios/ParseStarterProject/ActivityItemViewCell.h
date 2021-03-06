//
//  WishItemViewCell.h
//  HouseLife
//
//  Created by Yang Shun Tay on 12/1/12.
//
//

#import <UIKit/UIKit.h>

@interface ActivityItemViewCell : UITableViewCell

@property (nonatomic, unsafe_unretained) IBOutlet UILabel *title;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *date;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *type;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *thumb;

@end
