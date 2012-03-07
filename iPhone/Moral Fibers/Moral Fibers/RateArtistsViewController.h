//
//  RateArtistsViewController.h
//  Moral Fibers
//
//  Created by Joseph Pintozzi on 3/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

//
// This is gonna take some serious work
// First use views.get to get a listing of mens and womens shirts
// then take the node of of those objects, and use node.get on the corresponding nid
// after getting that node, look in the taxonomy array (should only be one object)



#import <UIKit/UIKit.h>
#import "RateArtistsTableViewCell.h"

@interface RateArtistsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    UITableView *tableView;
    RateArtistsTableViewCell *rateCell;
	NSArray *designs;
	IBOutlet UINavigationItem *navItem;
}

@property (retain) UITableView *tableView;
@property (nonatomic, assign) IBOutlet RateArtistsTableViewCell *rateCell;

@end
