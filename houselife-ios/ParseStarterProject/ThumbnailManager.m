//
//  ThumbnailManager.m
//  HouseLife
//
//  Created by Yang Shun Tay on 12/2/12.
//
//

#import "ThumbnailManager.h"

@implementation ThumbnailManager {
    
    UIImage *waiyin;
    UIImage *yangshun;
    UIImage *xialang;
    UIImage *chenyang;
    UIImage *hendy;
}

- (id)init {
    self = [super init];
    if (self) {
        waiyin = [UIImage imageNamed:@"thumb-wy"];
        yangshun = [UIImage imageNamed:@"thumb-ys"];
        xialang = [UIImage imageNamed:@"thumb-xl"];
        chenyang = [UIImage imageNamed:@"thumb-cy"];
        hendy = [UIImage imageNamed:@"thumb-hendy"];
    }
    return self;
}

- (UIImage*)imageForUserId:(NSString*)string {
    
    
    if ([string isEqualToString:@"23RLBVtAso"]) {
        return waiyin;
    } else if ([string isEqualToString:@"vYGFgMbOUX"]) {
        return yangshun;
    } else if ([string isEqualToString:@"eoWdgTClmN"]) {
        return xialang;
    } else if ([string isEqualToString:@"Mug7rHmPUm"]) {
        return chenyang;
    } else if ([string isEqualToString:@"hbmdSfsTBe"]) {
        return hendy;
    } else{
        return nil;
    }
}



@end
