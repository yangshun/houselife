//
//  FeedViewController.m
//  HouseLife
//
//  Created by Yang Shun Tay on 12/1/12.
//
//

#import "FeedViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ParseStarterProjectAppDelegate.h"
#import "ThumbnailManager.h"
#import "AddFeedViewController.h"

@interface FeedViewController () {
    IBOutlet UIView *circle;
    IBOutlet UITableView *tableview;
    NSArray *allUsers;
    ThumbnailManager *thumbnailManager;
    NSIndexPath *currentIndexPath;
}

@end

@implementation FeedViewController

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

- (IBAction)addTask:(id)sender {
    AddFeedViewController *addfeedvc = [AddFeedViewController new];
    [self presentModalViewController:addfeedvc animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    circle.layer.cornerRadius = 20.0f;
    [((ParseStarterProjectAppDelegate*)[UIApplication sharedApplication].delegate) loadAllUsers];
    thumbnailManager = [[ThumbnailManager alloc] init];
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                                                target:self action:@selector(addTask:)];
    self.navigationItem.rightBarButtonItem = editButton;
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshTable)
                                                 name:@"RefreshTable"
                                               object:nil];
}

- (void)refreshTable {
    [self loadObjects];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data Source Delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75.0f;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Delete"
                                                    otherButtonTitles:@"Done", nil];
    [actionSheet showInView:self.view];
    currentIndexPath = indexPath;
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:currentIndexPath];
    [cell setSelected:NO];
    
    PFObject *feedItem = self.objects[currentIndexPath.row];
    switch (buttonIndex) {
        case 0:{
            // Delete
            [feedItem setObject:[NSNumber numberWithInt:2] forKey:@"status"];
            [feedItem saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [self loadObjects];
            }];
            }
            break;
        case 1:{
            // Done
            [feedItem setObject:[NSNumber numberWithInt:1] forKey:@"status"];
            [feedItem saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [self loadObjects];
            }];
            }
            break;
        case 2:
            // Cancel
            break;
        default:
            break;
    }
}

- (PFQuery *)queryForTable {
    
//    if (![PFUser currentUser]) {
//        PFQuery *query = [PFQuery queryWithClassName:self.className];
//        [query setLimit:0];
//        return query;
//    }
    [((ParseStarterProjectAppDelegate*)[UIApplication sharedApplication].delegate) loadAllUsers];
    PFQuery *query = [PFQuery queryWithClassName:self.className];
    [query whereKey:@"household_id" equalTo:@"0dYzLuyY7C"];
    [query whereKey:@"status" equalTo:[NSNumber numberWithInt:0]];
    [query orderByDescending:@"createdAt"];
    
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    FeedItemViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"FeedItemViewCell" owner:self options:nil];
        cell = self.feedCell;
        cell.frame = CGRectMake(0, 0, 320, 75);
        cell.selectionStyle =  UITableViewCellSelectionStyleGray;
        cell.backgroundColor = [UIColor clearColor];
    }
    PFObject *feedItem = self.objects[indexPath.row];
    
    cell.title.text = [NSString stringWithFormat:@"%@", [feedItem objectForKey:@"title"]];
    cell.desc.text = [NSString stringWithFormat:@"%@", [feedItem objectForKey:@"description"]];
    NSString *nameId = [feedItem objectForKey:@"assignee_id"];
    cell.thumb.image = [thumbnailManager imageForUserId:nameId];

    
//    NSArray *allUsers = ((ParseStarterProjectAppDelegate*)[UIApplication sharedApplication].delegate).allUsers;
//    if (nameId) {
//        for (PFUser *user in allUsers) {
//            if ([nameId isEqualToString:user.objectId]) {
//                cell.assignee.text = user.username;
//                break;
//            }
//        }
//    } else {
//        cell.assignee.text = @"";
//    }
    
    return cell;
}

@end
