//
//  ShirtsTableViewController.m
//  Moral Fibers
//
//  Created by Joseph Pintozzi on 8/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ShirtsTableViewController.h"
#import "ASIFormDataRequest.h"
#import "Moral_FibersAppDelegate.h"
#import "CCJSONParser.h"
#import "UIImageView+WebCache.h"
#import "WebBrowserViewController.h"

@implementation ShirtsTableViewController
@synthesize viewToPullFrom;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
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
	
	hud = [[MBProgressHUD alloc] initWithView:self.tabBarController.view];
	[self.tabBarController.view addSubview:hud];
	hud.delegate = self;
	hud.dimBackground = YES;
	[hud show:YES];
	
	ASIFormDataRequest *post = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kAPIURL]];
	[post setPostValue:kAPIKey forKey:kAPI];
	[post setPostValue:kGetView forKey:kMethod];
	[post setPostValue:viewToPullFrom forKey:kViewName];
	[post setPostValue:kAPIDomain forKey:kDomain];
	[post setDelegate:self];
	[post startAsynchronous];
}


- (void)requestFinished:(ASIHTTPRequest *)request
{
	// Use when fetching text data
	NSString *responseString = [request responseString];
	NSLog(@"Response string: %@", responseString);
	
	NSDictionary *responseDictionary = [CCJSONParser objectFromJSON:responseString];
	if ([[responseDictionary objectForKey:@"#error"] boolValue] == TRUE || [responseDictionary objectForKey:kDataKey] == nil) {
		[hud hide:YES];
		[Moral_FibersAppDelegate presentConnectionError:nil];
		//crap, error
		return;
	}
	
	
	shirts = [[responseDictionary objectForKey:kDataKey] retain];
	
	if (!shirtUrls) {
		shirtUrls = [NSMutableArray arrayWithCapacity:[shirts count]];
	} else {
		[shirtUrls removeAllObjects];
	}
	
	for (NSDictionary *shirtDict in shirts) {
		NSString *nodeData = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kNodeURL, [shirtDict objectForKey:@"nid"]]] encoding:NSUTF8StringEncoding error:nil];
		NSLog(@"%@",nodeData);
		NSString *filePath = [[[[CCJSONParser objectFromJSON:nodeData] objectForKey:@"field_tshirt_featured_image"] objectAtIndex:0] objectForKey:@"filepath"];
		[shirtUrls addObject:filePath];
	}
	
	
	[self.tableView reloadData];
	
	//hide the hud!
	[hud hide:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
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
	if(shirts)
		return [shirts count];
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	cell.textLabel.text = [[shirts objectAtIndex:indexPath.row] objectForKey:@"node_title"];
	
	
	//now use a node get to gather more information about this artist
	/*
	ASIFormDataRequest *post2 = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kAPIURL]];
	[post2 setPostValue:kAPIKey forKey:kAPI];
	[post2 setPostValue:kFileGet forKey:kMethod];
	[post2 setPostValue:[[shirts objectAtIndex:indexPath.row] objectForKey:@"node_data_field_tshirt_featured_image_field_tshirt_featured_image_fid"] forKey:kFileID];
	[post2 setPostValue:kAPIDomain forKey:kDomain];
	[post2 startSynchronous];
	
	//check for an error
	NSError *error = [post2 error];
	if (!error) {
		NSString *response = [post2 responseString];
		NSLog(@"Response string: %@", response);
		NSDictionary *responseDictionary = [[CCJSONParser objectFromJSON:response] objectForKey:kDataKey];
		if ([[responseDictionary objectForKey:kErrorKey] boolValue] == TRUE) {
			//we have an error
			return cell;
		}
		NSString *shirtImageURL = [NSString stringWithFormat:@"%@/%@", kBaseURL, [responseDictionary objectForKey:kPicPath]];
		[cell.imageView setImageWithURL:[NSURL URLWithString:shirtImageURL] placeholderImage:[UIImage imageNamed:@"twitter"]];
	}*/
	//use node.get to get the file instead of file.get
	/*
	NSString *nodeData = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kNodeURL, [[shirts objectAtIndex:indexPath.row] objectForKey:@"nid"]]] encoding:NSUTF8StringEncoding error:nil];
	NSLog(@"%@",nodeData);
	NSString *filePath = [[[[CCJSONParser objectFromJSON:nodeData] objectForKey:@"field_tshirt_featured_image"] objectAtIndex:0] objectForKey:@"filepath"];
	[cell.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseURL, filePath]] placeholderImage:[UIImage imageNamed:@"moralfiberslogo_bluestarstamp"]];
	*/
	//background load this image
	//NSDictionary *extraParams = [NSDictionary dictionaryWithObjectsAndKeys:cell, @"cell", indexPath, @"indexPath", nil];
	//[NSThread detachNewThreadSelector:@selector(backgroundLoadImage:) toTarget:self withObject:extraParams];
	//cell.imageView.image = [UIImage imageNamed:@"moralfiberslogo_bluestarstamp"];
	[cell.imageView setImageWithURL:[shirtUrls objectAtIndex:indexPath.row] placeholderImage:[UIImage imageNamed:@"moralfiberslogo_bluestarstamp"]];
    return cell;
}

-(void)backgroundLoadImage:(NSDictionary*)dict{
	[self backgroundLoadImageForCell:[dict objectForKey:@"cell"] atIndexPath:[dict objectForKey:@"indexPath"]];
}

-(void)backgroundLoadImageForCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath*)indexPath{
	
	//[cell.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseURL, filePath]] placeholderImage:[UIImage imageNamed:@"moralfiberslogo_bluestarstamp"]];
	/*
	NSDictionary *extraParams = [NSDictionary dictionaryWithObjectsAndKeys:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseURL, filePath]], @"url", [UIImage imageNamed:@"moralfiberslogo_bluestarstamp"], @"placeholder", nil];
	[cell.imageView performSelectorOnMainThread:@selector(setImageWithDictionary:) withObject:extraParams waitUntilDone:YES];
	 */
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
    [browser setInitialURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kNodeViewURL, [[shirts objectAtIndex:indexPath.row] objectForKey:@"node_vid"]]]];
    [self presentModalViewController:browser animated:YES];
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
