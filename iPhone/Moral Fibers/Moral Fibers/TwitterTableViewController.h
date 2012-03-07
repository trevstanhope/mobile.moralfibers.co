//
//  TwitterTableViewController.h
//  Moral Fibers
//
//  Created by Joseph Pintozzi on 3/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "MBProgressHUD.h"

#define kTwitterFeedURL     @"http://api.twitter.com/1/statuses/user_timeline.json?screen_name=moralfibers"
#define kTwitterPermalink   @"http://twitter.com/#!/moralfibers/status/"

@interface TwitterTableViewController : UIViewController <EGORefreshTableHeaderDelegate> {
    IBOutlet UITableView *tableView;
    NSMutableArray *tweets;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
	
	//  Reloading var should really be your tableviews datasource
	//  Putting it here for demo purposes 
	BOOL _reloading;
	
	MBProgressHUD *hud;
	
	NSDateFormatter *twitterDateFormatter, *niceDateFormatter;
}

@property (retain) NSMutableArray *tweets;
@property (retain) IBOutlet UITableView *tableView;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end
