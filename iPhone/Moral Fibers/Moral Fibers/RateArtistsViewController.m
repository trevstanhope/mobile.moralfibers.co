//
//  RateArtistsViewController.m
//  Moral Fibers
//
//  Created by Joseph Pintozzi on 3/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RateArtistsViewController.h"
#import "CCJSONParser.h"
#import "UIImageView+WebCache.h"


#define kImagePrefix	@"http://moralfibers.net/sites/default/files/"
#define kDesignURL		@"http://www.moralfibers.net/iphone/designs.php"

@implementation RateArtistsViewController
@synthesize tableView;
@synthesize rateCell;

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
	label.font = [UIFont fontWithName:@"Rabbit On The Moon" size:kNavFontSize];
	label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	label.textAlignment = UITextAlignmentCenter;
	label.textColor =[UIColor whiteColor];
	label.text = @"Rate the Designs";
	//set it in our nav bar
	navItem.titleView = label;
	[label release];
	
	NSString *json = [[NSString alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:kDesignURL]] encoding:NSUTF8StringEncoding];
	designs = [[CCJSONParser objectFromJSON:json] retain];
	 
	
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
	NSLog(@"Found %i designs", [designs count]);
    return [designs count];
	//return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RateDesign";
    
    RateArtistsTableViewCell *cell = (RateArtistsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //[[NSBundle mainBundle] loadNibNamed:@"RateArtistsTableViewCell" owner:self options:nil];
        cell = [[[RateArtistsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    cell.artistName.text = [NSString stringWithFormat:@"Design %i", indexPath.row + 1];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	NSString * imageURL = [NSString stringWithFormat:@"%@%@", kImagePrefix, [[designs objectAtIndex:indexPath.row] objectForKey:@"file_name"]];
	[cell.artistPic setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"twitter"]];
	cell.designRowId = [[designs objectAtIndex:indexPath.row] objectForKey:@"designId"];
	
    return cell;
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}

@end
