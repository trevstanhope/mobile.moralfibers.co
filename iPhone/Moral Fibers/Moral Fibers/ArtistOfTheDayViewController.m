//
//  ArtistOfTheDayViewController.m
//  Moral Fibers
//
//  Created by Joseph Pintozzi on 3/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ArtistOfTheDayViewController.h"
#import "WebBrowserViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "CCJSONParser.h"

@implementation ArtistOfTheDayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)learnMore:(id)sender{
    WebBrowserViewController *browser = [[WebBrowserViewController alloc] initWithNibName:@"WebBrowserViewController" bundle:nil];
    [browser setInitialURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kNodeViewURL, [artistInfo objectForKey:@"nid"]]]];
    [self presentModalViewController:browser animated:YES];
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	//set our text in our nav bar
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 360, 44)];
	label.backgroundColor = [UIColor clearColor];
	//label.font = [UIFont fontWithName:@"Rabbit On The Moon" size:kNavFontSize];
	label.font = [UIFont fontWithName:@"Helvetica-Bold" size:kNavFontSize];
	label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	label.textAlignment = UITextAlignmentCenter;
	label.textColor =[UIColor whiteColor];
	label.text = @"Artist of the Month";
	//set it in our nav bar
	navItem.titleView = label;
	[label release];
	
	ASIFormDataRequest *post = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kAPIURL]];
	[post setPostValue:kAPIKey forKey:kAPI];
	[post setPostValue:kGetView forKey:kMethod];
	[post setPostValue:kAotM forKey:kViewName];
	[post setPostValue:kAPIDomain forKey:kDomain];
	[post setDelegate:self];
	[post startAsynchronous];
	
	hud = [[MBProgressHUD alloc] initWithView:self.tabBarController.view];
	[self.tabBarController.view addSubview:hud];
	hud.delegate = self;
	hud.dimBackground = YES;
	[hud show:YES];
	
}


- (void)requestFinished:(ASIHTTPRequest *)request
{
	// Use when fetching text data
	NSString *responseString = [request responseString];
	NSLog(@"Response string: %@", responseString);
	
	NSDictionary *responseDictionary = [CCJSONParser objectFromJSON:responseString];
	if ([[responseDictionary objectForKey:@"#error"] boolValue] == TRUE || [[responseDictionary objectForKey:kDataKey] count] < 1) {
		[hud hide:YES];
		[self presentConnectionError:nil];
		//crap, error
		return;
	}
	
	//if we get to here, we have valid data
	//NSString *sessionId = [[responseDictionary objectForKey:kDataKey] objectForKey:kSessionKey];
	//NSLog(@"Session Id: %@", sessionId);
	
	// Use when fetching binary data
	//NSData *responseData = [request responseData];
	
	NSString *authorName = [[[responseDictionary objectForKey:kDataKey] objectAtIndex:0] objectForKey:kNodeTitle];
	NSString *nid = [[[responseDictionary objectForKey:kDataKey] objectAtIndex:0] objectForKey:kNodeID];
	NSLog(@"Found artist with NID of %@", nid);
	//self.title = authorName;
	
	//set our text in our nav bar
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 360, 44)];
	label.backgroundColor = [UIColor clearColor];
	//label.font = [UIFont fontWithName:@"Rabbit On The Moon" size:kNavFontSize];
	label.font = [UIFont fontWithName:@"Helvetica-Bold" size:kNavFontSize];
	label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	label.textAlignment = UITextAlignmentCenter;
	label.textColor =[UIColor whiteColor];
	label.text = authorName;
	//set it in our nav bar
	navItem.titleView = label;
	[label release];
	
	//throw in some more info
	//bioField.text = authorName;
	learnMoreButton.titleLabel.minimumFontSize = 7.0f;
	//learnMoreButton.titleLabel.font = [UIFont fontWithName:@"Rabbit On The Moon" size:18.0f];
	learnMoreButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0f];
	//[learnMoreButton.titleLabel setText:[NSString stringWithFormat:@"Learn more about %@", [[authorName componentsSeparatedByString:@" "] objectAtIndex:0]]];
	[learnMoreButton.titleLabel setText:@"Tap to learn more"];
	
	//now use a node get to gather more information about this artist
	/*
	ASIFormDataRequest *post2 = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kAPIURL]];
	[post2 setPostValue:kAPIKey forKey:kAPI];
	[post2 setPostValue:kNodeGet forKey:kMethod];
	[post2 setPostValue:nid forKey:kNodeID];
	[post2 setPostValue:kAPIDomain forKey:kDomain];
    [post2 setPostValue:@"\"teaser\"" forKey:@"\"fields\""];
	[post2 startSynchronous];
	
	//check for an error
	NSError *error = [post2 error];
	if (!error) {
		NSString *response = [post2 responseString];
		NSLog(@"Response string: %@", response);
		responseDictionary = [[CCJSONParser objectFromJSON:response] objectForKey:kDataKey];
		if ([[responseDictionary objectForKey:kErrorKey] boolValue] == TRUE) {
			//we have an error
			return;
		}
		//pull out the file path of the artists picture from our response
		NSString *artistPictureUrlString = [[[responseDictionary objectForKey:kArtistPics] objectAtIndex:0] objectForKey:kPicPath];
		[mainPicture setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", kBaseURL, artistPictureUrlString]] placeholderImage:mainPicture.image]; 
	}*/
	
	//fetch our artist info dictionary from the NID
	NSString *nodeData = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kNodeURL, nid]] encoding:NSUTF8StringEncoding error:nil];
	NSLog(@"%@",nodeData);
	artistInfo = [[CCJSONParser objectFromJSON:nodeData] retain];
	
	
	//get our image of the artist
	NSString *thumbnailUrl = [[[artistInfo objectForKey:@"field_artist_thumbnail"] objectAtIndex:0] objectForKey:@"filepath"];
	NSData *artistThumbData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseURL, thumbnailUrl]]];
	UIImage *artistThumb = [UIImage imageWithData:artistThumbData];
	mainPicture.image = artistThumb;
	
	//get their bio and show it on the screen
	bioField.text = [artistInfo objectForKey:@"body"];
	
	//hide the hud!
	[hud hide:YES];
}

-(void)presentConnectionError:(id)sender{
    UIAlertView *error = [[[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an error when updating, please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
    [error show];
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	NSError *error = [request error];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
