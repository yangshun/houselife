//
//  LeftController.m
//  DDMenuController
//
//  Created by Devin Doty on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LeftController.h"
#import "FeedViewController.h"
#import "DDMenuController.h"
#import "ParseStarterProjectAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "ProfileViewController.h"
#import "ActivityViewController.h"

@implementation LeftController

@synthesize tableView=_tableView;

- (id)init {
    if ((self = [super init])) {
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        tableView.delegate = (id<UITableViewDelegate>)self;
        tableView.dataSource = (id<UITableViewDataSource>)self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = [UIColor colorWithWhite:0.29f alpha:1.0f];
        [self.view addSubview:tableView];
        self.tableView = tableView;
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.tableView = nil;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 50.0f;
//}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    /* 
     * Content in this cell should be inset the size of kMenuOverlayWidth
     */
    NSString *title;
    switch (indexPath.row) {
        case 0:
            title = @"HouseLife";
            cell.imageView.image = [UIImage imageNamed:@"icon-tasks"];
            break;
        case 1:
            title = @"Activity";
            cell.imageView.image = [UIImage imageNamed:@"icon-activity"];
            break;
        case 2:
            title = @"Statistics";
            cell.imageView.image = [UIImage imageNamed:@"icon-stats"];
            break;
        case 3:
            title = @"Nearby";
            cell.imageView.image = [UIImage imageNamed:@"icon-location"];
            break;
        case 4:
            title = @"Expenses";
            cell.imageView.image = [UIImage imageNamed:@"icon-expenses"];
            break;
        case 5:
            title = @"Profile";
            cell.imageView.image = [UIImage imageNamed:@"icon-profile"];
            break;
        default:
            title = @"";
            break;
    }
    
    cell.textLabel.text = title;
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0f];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
    cell.textLabel.layer.shadowOffset = CGSizeMake(0.0, 1.0f);
    cell.textLabel.layer.shadowRadius = 1.0f;
    cell.textLabel.layer.shadowOpacity = 1.0f;
    
    UIView *topline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.bounds.size.width, 1)];
    topline.backgroundColor = [UIColor colorWithWhite:0.5f alpha:1.0f];
    [cell addSubview:topline];
    
    UIView *btmline = [[UIView alloc] initWithFrame:CGRectMake(0, cell.bounds.size.height-1, cell.bounds.size.width, 1)];
    btmline.backgroundColor = [UIColor colorWithWhite:0.15f alpha:1.0f];
    [cell addSubview:btmline];
    
    return cell;
    
}

//- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
//    return @"Menu";
//}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // set the root controller
    DDMenuController *menuController = (DDMenuController*)((ParseStarterProjectAppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    
    NSString *title;
    UIViewController *controller;
    switch (indexPath.row) {
        case 0:
            title = @"Tasks";
            break;
        case 1:
            title = @"Activity";
            controller = [[ActivityViewController alloc] init];
            break;
        case 2:
            title = @"Statistics";
            break;
        case 3:
            title = @"Nearby";
            break;
        case 4:
            title = @"Expenses";
            break;
        case 5:
            title = @"Profile";
            controller = [[ProfileViewController alloc] init];
            break;
        default:
            title = @"";
            break;
    }
    
    if (!controller) {
        controller = [FeedViewController new];
    }
    
    controller.title = title;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];

    [menuController setRootController:navController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}



@end
