//
//  ArtistOfTheDayViewController.h
//  Moral Fibers
//
//  Created by Joseph Pintozzi on 3/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface ArtistOfTheDayViewController : UIViewController {
    IBOutlet UIImageView *mainPicture;
	IBOutlet UITextView *bioField;
	IBOutlet UINavigationBar *navBar;
	IBOutlet UINavigationItem *navItem;
	IBOutlet UIButton *learnMoreButton;
	MBProgressHUD *hud;
	NSDictionary *artistInfo;
}

-(IBAction)learnMore:(id)sender;

@end
