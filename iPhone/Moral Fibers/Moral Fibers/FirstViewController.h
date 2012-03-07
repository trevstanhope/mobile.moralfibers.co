//
//  FirstViewController.h
//  Moral Fibers
//
//  Created by Joseph Pintozzi on 3/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@interface FirstViewController : UIViewController <ZBarReaderDelegate> {
	IBOutlet UIButton *website, *scan;
	IBOutlet UINavigationItem *navItem;
}

-(IBAction)scan:(id)sender;
-(IBAction)openWebpage:(id)sender;

@end
