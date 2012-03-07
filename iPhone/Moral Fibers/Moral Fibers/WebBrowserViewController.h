//
//  WebBrowserViewController.h
//  iPhone
//
//  Created by Joseph Pintozzi on 11/16/09.
//  Copyright 2009 Tiny Dragon Apps LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebBrowserViewController : UIViewController <UIWebViewDelegate> {
	IBOutlet UIWebView *web;
	IBOutlet UISegmentedControl *seg;
	NSURL *initialURL;
	BOOL isSecondaryLoad;
	IBOutlet UINavigationItem *navItem;
}

@property (retain) NSURL *initialURL;
@property (nonatomic, retain) IBOutlet UIWebView *web;
@property (nonatomic, retain) IBOutlet UISegmentedControl *seg;
@property (nonatomic, retain) IBOutlet UINavigationItem *navItem;


-(IBAction)back;
-(IBAction)forward;
-(IBAction)stop;
-(IBAction)refresh;
-(IBAction)close;
-(IBAction)segaction:(id)sender;

@end
