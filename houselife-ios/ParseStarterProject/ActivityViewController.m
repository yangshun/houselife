//
//  ActivityViewController.m
//  HouseLife
//
//  Created by Yang Shun Tay on 12/1/12.
//
//

#import "ActivityViewController.h"

@interface ActivityViewController () {
    IBOutlet UITableView *tableview;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ActivityItemViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"ActivityItemViewCell" owner:self options:nil];
        cell = self.activityCell;
        cell.frame = CGRectMake(0, 0, 320, 50);
        cell.selectionStyle =  UITableViewCellSelectionStyleGray;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    cell.title.text = [NSString stringWithFormat:@"title %d", indexPath.row];
    cell.date.text = [NSString stringWithFormat:@"date %d", indexPath.row];
    cell.assignee.text = [NSString stringWithFormat:@"assignee %d", indexPath.row];
    // Configure the cell...
    
    return cell;
}


@end
