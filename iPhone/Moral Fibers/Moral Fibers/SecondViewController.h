//
//  SecondViewController.h
//  Moral Fibers
//
//  Created by Joseph Pintozzi on 3/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SecondViewController : UIViewController {
    IBOutlet UIButton *mensShirts, *womensShirts;
}


-(IBAction)showMensShirts:(id)sender;
-(IBAction)showWomensShirts:(id)sender;

@end
