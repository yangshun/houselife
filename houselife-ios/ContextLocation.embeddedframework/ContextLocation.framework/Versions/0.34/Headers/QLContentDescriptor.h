
#import <Foundation/Foundation.h>
#import <Common/QLAvailability.h>

@interface QLContentDescriptor : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *contentDescription;
@property (nonatomic, strong) NSString *contentUrl;
@property (nonatomic, strong) NSString *campaignId;
@property (nonatomic, strong) NSNumber *expires;
@property (nonatomic, strong) NSNumber *displayCount;
@property (nonatomic, strong) NSNumber *eventTimeWindow;
@property (nonatomic, strong) NSNumber *placeId;
@property (nonatomic, strong) NSNumber *eventTime;
@property (nonatomic, strong) NSString *iconUrl DEPRECATED;

@end
