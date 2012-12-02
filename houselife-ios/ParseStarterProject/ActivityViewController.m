//
//  ActivityViewController.m
//  HouseLife
//
//  Created by Yang Shun Tay on 12/1/12.
//
//

#import "ActivityViewController.h"
#import "ThumbnailManager.h"

@interface ActivityViewController () {
    IBOutlet UITableView *tableview;
    ThumbnailManager *thumbnailManager;
}

@end

@implementation ActivityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        self.className = @"task";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    thumbnailManager = [[ThumbnailManager alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (PFQuery *)queryForTable {
    
    //    if (![PFUser currentUser]) {
    //        PFQuery *query = [PFQuery queryWithClassName:self.className];
    //        [query setLimit:0];
    //        return query;
    //    }
    PFQuery *query = [PFQuery queryWithClassName:self.className];
    [query whereKey:@"household_id" equalTo:@"0dYzLuyY7C"];
    [query whereKey:@"status" notEqualTo:[NSNumber numberWithInt:0]];
    [query orderByDescending:@"updatedAt"];
    
    [query setCachePolicy:kPFCachePolicyNetworkOnly];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    //
    // If there is no network connection, we will hit the cache first.
    if (self.objects.count == 0) {
        NSLog(@"Loading from cache");
        [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
    }
    
    return query;
}

#pragma mark - Data Source Delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ActivityItemViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"ActivityItemViewCell" owner:self options:nil];
        cell = self.activityCell;
        cell.frame = CGRectMake(0, 0, 320, 50);
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    PFObject *feedItem = self.objects[indexPath.row];
    
    NSString *nameId = [feedItem objectForKey:@"assignee_id"];
    switch ([[feedItem objectForKey:@"status"]intValue]) {
        case 1:
            cell.title.text = [[NSString stringWithFormat:@"completed %@.", [feedItem objectForKey:@"title"]] lowercaseString];
            break;
        case 2:
            cell.title.text = [[NSString stringWithFormat:@"deleted %@.", [feedItem objectForKey:@"title"]] lowercaseString];
            break;
        default:
            cell.title.text = [[NSString stringWithFormat:@"%@.", [feedItem objectForKey:@"title"]] lowercaseString];
            break;
    }
    
    cell.thumb.image = [thumbnailManager imageForUserId:nameId];
    // Configure the cell...
    
    return cell;
}


@end
