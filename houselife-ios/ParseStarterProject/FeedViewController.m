//
//  FeedViewController.m
//  HouseLife
//
//  Created by Yang Shun Tay on 12/1/12.
//
//

#import "FeedViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface FeedViewController () {
    IBOutlet UIView *circle;
    IBOutlet UITableView *tableview;
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

- (IBAction)addTask:(id)sender {
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    circle.layer.cornerRadius = 20.0f;
    // Do any additional setup after loading the view from its nib.
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
    return 10;
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
    
    cell.title.text = [NSString stringWithFormat:@"title %d", indexPath.row];
    cell.desc.text = [NSString stringWithFormat:@"desc %d", indexPath.row];
    cell.assignee.text = [NSString stringWithFormat:@"assignee %d", indexPath.row];
    // Configure the cell...
    
    return cell;
}

@end
