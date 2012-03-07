//
//  TwitterTableViewController.m
//  Moral Fibers
//
//  Created by Joseph Pintozzi on 3/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TwitterTableViewController.h"
#import "CCJSONParser.h"
#import "UIImageView+WebCache.h"
#import "WebBrowserViewController.h"
#import "TwitterTableViewCell.h"

@implementation TwitterTableViewController
@synthesize tweets;
@synthesize tableView;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 360, 44)];
		label.backgroundColor = [UIColor clearColor];
		//label.font = [UIFont fontWithName:@"Rabbit On The Moon" size:kNavFontSize];
		label.font = [UIFont fontWithName:@"Helvetica-Bold" size:kNavFontSize];
		label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
		label.textAlignment = UITextAlignmentCenter;
		label.textColor =[UIColor whiteColor];
		label.text = @"Tweets";
		//set it in our nav bar
		self.navigationItem.titleView = label;
		[label release];
    }
    return self;
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
    if (_refreshHeaderView == nil) {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
		[view release];
		
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
	
	if (!twitterDateFormatter) {
		twitterDateFormatter = [[NSDateFormatter alloc] init];
		NSLocale *usLocale = [NSLocale currentLocale];
		[twitterDateFormatter setLocale:usLocale]; 
		[twitterDateFormatter setDateStyle:NSDateFormatterLongStyle];
		[twitterDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
		
		// see http://unicode.org/reports/tr35/tr35-6.html#Date_Format_Patterns
		[twitterDateFormatter setDateFormat: @"EEE MMM dd HH:mm:ss +0000 yyyy"];
		
		niceDateFormatter = [[NSDateFormatter alloc] init];
		[niceDateFormatter setDateStyle:NSDateFormatterLongStyle];
		[niceDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
		
		// see http://unicode.org/reports/tr35/tr35-6.html#Date_Format_Patterns
		[niceDateFormatter setDateFormat: @"MMM dd H:mm"];
		
		[usLocale release];
	}
	
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	if (!tweets) {
		//see if we need to make our hud
		if (!hud) {
			hud = [[MBProgressHUD alloc] initWithView:self.tabBarController.view];
			[self.tabBarController.view addSubview:hud];
			hud.delegate = self;
			hud.dimBackground = YES;
		}
		//show the hud
		[hud show:YES];
        [NSThread detachNewThreadSelector:@selector(backgroundPullFeed:) toTarget:self withObject:nil];
    }
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (!tweets) {
        return 0;
    }
    return [tweets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    TwitterTableViewCell *cell = (TwitterTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[TwitterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	//pull down the profile image (if necessary using placeholder image)
    NSString *profilePictureURL = [[[tweets objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"profile_image_url"];
    [cell.imageView setImageWithURL:[NSURL URLWithString:profilePictureURL] placeholderImage:[UIImage imageNamed:@"twitter"]];
	//show our tweet
    cell.tweet.text = [[tweets objectAtIndex:indexPath.row] objectForKey:@"text"];
	//convert our date
	NSDate *date = [twitterDateFormatter dateFromString:[[tweets objectAtIndex:indexPath.row] objectForKey:@"created_at"]];
	cell.info.text = [NSString stringWithFormat:@"tweeted by %@ on %@", [[[tweets objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"name"], [niceDateFormatter stringFromDate:date]];
    cell.tag = (int)[[tweets objectAtIndex:indexPath.row] objectForKey:@"id"];
    return cell;
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    [_refreshHeaderView performSelectorOnMainThread:@selector(egoRefreshScrollViewDataSourceDidFinishedLoading:) withObject:self.tableView waitUntilDone:NO];
    [tableView reloadData];
	
	[hud hide:YES];
	
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	//[self reloadTableViewDataSource];
	//[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
    [hud show:YES];
    [NSThread detachNewThreadSelector:@selector(backgroundPullFeed:) toTarget:self withObject:nil];
    
	
}

-(void)backgroundPullFeed:(id)sender{
    //try to get our tweets
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    @try {
		
        NSString *jsonFeed = [[NSString alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:kTwitterFeedURL]] encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonFeed);
		if ([jsonFeed rangeOfString:@"\"error\""].location != NSNotFound) {
			NSDictionary *dict = [CCJSONParser objectFromJSON:jsonFeed];
			[[[[UIAlertView alloc] initWithTitle:@"Error" message:@"Error connecting to Twitter" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease] show];
			return;
		} 
        tweets = [[NSMutableArray arrayWithArray:[CCJSONParser objectFromJSON:jsonFeed]] retain];
		 
		//tweets = [NSMutableArray arrayWithCapacity:0];
    }
    @catch (NSException *exception) {
        [self performSelectorOnMainThread:@selector(presentConnectionError:) withObject:nil waitUntilDone:NO];
		[hud hide:YES];
    }
    @finally {
        [self reloadTableViewDataSource];
        //[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
        [self performSelectorOnMainThread:@selector(doneLoadingTableViewData) withObject:nil waitUntilDone:YES];
        [tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    }
	[pool release];
}

-(void)presentConnectionError:(id)sender{
    UIAlertView *error = [[[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an error when updating, please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
    [error show];
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    
    WebBrowserViewController *browser = [[WebBrowserViewController alloc] initWithNibName:@"WebBrowserViewController" bundle:nil];
    [browser setInitialURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kTwitterPermalink, [[tweets objectAtIndex:indexPath.row] objectForKey:@"id_str"]]]];
    [self presentModalViewController:browser animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
