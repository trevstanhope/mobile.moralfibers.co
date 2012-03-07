//
//  WebBrowserViewController.m
//  iPhone
//
//  Created by Joseph Pintozzi on 11/16/09.
//  Copyright 2009 Tiny Dragon Apps LLC. All rights reserved.
//

#import "WebBrowserViewController.h"

@implementation WebBrowserViewController
@synthesize web, seg;
@synthesize initialURL;
@synthesize navItem;

- (void)viewWillAppear:(BOOL)animated {
	if (!isSecondaryLoad) {
		[web loadRequest:[NSURLRequest requestWithURL:initialURL]];
		isSecondaryLoad = YES;
	}
	[super viewWillAppear:animated];
}

-(void)awakeFromNib {
	//NSLog(@"Awaken from nib");
	//[web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.apple.com/"]]];
}

-(void)viewDidLoad{
	[web reload];
	[seg setEnabled:FALSE forSegmentAtIndex:0];
	[seg setEnabled:FALSE forSegmentAtIndex:2];
}

-(IBAction)back{
	[web goBack];
}
-(IBAction)forward{
	[web goForward];
}
-(IBAction)stop{
	[seg setImage:[UIImage imageNamed:@"reload_small_white.png"] forSegmentAtIndex:1];
	[web stopLoading];
}
-(IBAction)refresh{
	NSLog(@"Refreshing");
	[seg setImage:[UIImage imageNamed:@"stop_sign_small_white.png"] forSegmentAtIndex:1];
	[web reload];
}
-(IBAction)close{
	//TODO: close modal view controller
	[web stopLoading];
    [self.parentViewController dismissModalViewControllerAnimated:YES];
	//[((iPhoneAppDelegate*)[[UIApplication sharedApplication] delegate]) closeModalViewController];
}

- (IBAction)segaction:(id)sender{
	UISegmentedControl *segmentedcontrol = (UISegmentedControl *) sender;
	NSInteger selectedSegment = segmentedcontrol.selectedSegmentIndex;
	NSLog(@"Selected segment: %d",selectedSegment);
	if (selectedSegment == 0) {
		if ([web canGoBack]) {
			[self back];
		}
	}
	if (selectedSegment == 1) {
		//if loading, stop, else, refresh the webpage
		if (![web canGoBack] && !self.initialURL) {
			
		}
		else if (web.loading == YES) {
			[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
			[self stop];
		}
		else {
			[self refresh];
		}
	}
	if (selectedSegment == 2) {
		if ([web canGoForward]) {
			[self forward];
		}
	}
	[segmentedcontrol setSelectedSegmentIndex:UISegmentedControlNoSegment];
}

#pragma mark UIWebView delegations

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	//NSLog(@"Should Start Web Load");
    /*
	NSURL *url = [request URL];
	if ([[url absoluteString] length] > 7 && [[[url absoluteString] substringToIndex:7] isEqualToString:@"mailto:"])
	{
		NSLog(@"mailto: link");
		
		if ([MFMailComposeViewController canSendMail])
		{
			NSLog(@"We can send mail!");
			MFMailComposeViewController *mailClass = [[[MFMailComposeViewController alloc] init] autorelease];
			mailClass.mailComposeDelegate = (iPhoneAppDelegate *)[[UIApplication sharedApplication] delegate];
			NSArray *parts = [[NSArray alloc] init];
			if ([[url absoluteString] rangeOfString:@"?"].location != NSNotFound) {
				NSLog(@"Breaking up parts");
				NSInteger start = [[url absoluteString] rangeOfString:@"?"].location;
				start++;
				parts = [[[url absoluteString] substringFromIndex:start] componentsSeparatedByString:@"&"];
				NSString *to = [[url absoluteString] substringFromIndex:7];
				to = [to substringToIndex:[to rangeOfString:@"?"].location];
				[mailClass setToRecipients:[NSArray arrayWithObject:to]];
			}
			else {
				NSLog(@"No parts, just mailto:");
				[mailClass setToRecipients:[NSArray arrayWithObject:[[url absoluteString] substringFromIndex:7]]];
				NSLog(@"%@",[[url absoluteString] substringFromIndex:7]);
			}
			
			if ([parts count] > 0) {
				NSLog(@"There are parts");
				for (int i = 0; i < [parts count]; i++) {
					NSLog(@"Part %d: %@", i, [parts objectAtIndex:i]);
					if([[[parts objectAtIndex:i] substringToIndex:8] isEqualToString:@"subject="]) {
						[mailClass setSubject:[[[parts objectAtIndex:i] substringFromIndex:8] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
					}
					else if([[[parts objectAtIndex:i] substringToIndex:3] isEqualToString:@"cc="]) {
						[mailClass setCcRecipients:[NSArray arrayWithObject:[[[parts objectAtIndex:i] substringFromIndex:3] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
					}
					else if([[[parts objectAtIndex:i] substringToIndex:5] isEqualToString:@"body="]) {
						NSString *body = [[parts objectAtIndex:i] substringFromIndex:5];
						body = [body stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
						[mailClass setMessageBody:body isHTML:YES];
					}
					else if([[[parts objectAtIndex:i] substringToIndex:4] isEqualToString:@"bcc="]) {
						[mailClass setBccRecipients:[NSArray arrayWithObject:[[[parts objectAtIndex:i] substringFromIndex:4] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
					}
				}
			}
			NSLog(@"Show mail composer!");
			//[[((iPhoneAppDelegate *)[[UIApplication sharedApplication] delegate]).tabController selectedViewController] presentModalViewController:mailClass animated:YES];
			[(iPhoneAppDelegate *)[[UIApplication sharedApplication] delegate] showMailComposer:mailClass];
			return TRUE;
		}
	}*/
	return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	NSLog(@"Starting web load");
	[seg setImage:[UIImage imageNamed:@"stop_sign_small_white.png"] forSegmentAtIndex:1];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	NSLog(@"Web load finished");
	[seg setImage:[UIImage imageNamed:@"reload_small_white.png"] forSegmentAtIndex:1];
	NSLog(@"Title: %@",[web stringByEvaluatingJavaScriptFromString:@"document.title"]);
	navItem.title = [web stringByEvaluatingJavaScriptFromString:@"document.title"];
	
	
	//this properly sets forward and backwards buttons
	if ([web canGoBack]) {
		[seg setEnabled:TRUE forSegmentAtIndex:0];
	}
	else {
		[seg setEnabled:FALSE forSegmentAtIndex:0];
	}
	if ([web canGoForward]) {
		[seg setEnabled:TRUE forSegmentAtIndex:2];
	}
	else {
		[seg setEnabled:FALSE forSegmentAtIndex:2];
	}
	
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
	NSLog(@"Webview failed to load, error: %@",[error localizedDescription]);
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

-(void)viewDidDisappear:(BOOL)animated{
	[super viewDidDisappear:animated];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)dealloc {
	web.delegate = nil;
	self.initialURL = nil;
    [super dealloc];
}


@end
