//
//  ShirtsTableViewController.h
//  Moral Fibers
//
//  Created by Joseph Pintozzi on 8/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface ShirtsTableViewController : UITableViewController
{
	NSString *viewToPullFrom;
	MBProgressHUD *hud;
	
	NSArray *shirts;
	NSMutableArray *shirtUrls;
}

@property (nonatomic, retain) NSString *viewToPullFrom;
-(void)backgroundLoadImageForCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath*)indexPath;
@end
