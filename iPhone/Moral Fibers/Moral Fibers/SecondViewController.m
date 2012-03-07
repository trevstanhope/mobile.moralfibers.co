//
//  SecondViewController.m
//  Moral Fibers
//
//  Created by Joseph Pintozzi on 3/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SecondViewController.h"
#import "ShirtsTableViewController.h"

@implementation SecondViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
	//[mensShirts setFont:[UIFont fontWithName:@"Rabbit On The Moon" size:kNavFontSize]];
	[mensShirts setFont:[UIFont fontWithName:@"Helvetica-Bold" size:kButtonSize]];
	//[womensShirts setFont:[UIFont fontWithName:@"Rabbit On The Moon" size:kNavFontSize]];
	[womensShirts setFont:[UIFont fontWithName:@"Helvetica-Bold" size:kButtonSize]];
	// Do any additional setup after loading the view from its nib.
	//set our text in our nav bar
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 360, 44)];
	label.backgroundColor = [UIColor clearColor];
	//label.font = [UIFont fontWithName:@"Rabbit On The Moon" size:kNavFontSize];
	label.font = [UIFont fontWithName:@"Helvetica-Bold" size:kNavFontSize];
	label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	label.textAlignment = UITextAlignmentCenter;
	label.textColor =[UIColor whiteColor];
	label.text = @"Shirts";
	//set it in our nav bar
	[self navigationItem].titleView = label;
	[label release];
}

-(IBAction)showMensShirts:(id)sender{
	ShirtsTableViewController *shirts = [[ShirtsTableViewController alloc] initWithStyle:UITableViewStylePlain];
	shirts.viewToPullFrom = kMenShirts;
	shirts.title = @"Men's Shirts";
	[self.navigationController pushViewController:shirts animated:YES];
	
}

-(IBAction)showWomensShirts:(id)sender{
	ShirtsTableViewController *shirts = [[ShirtsTableViewController alloc] initWithStyle:UITableViewStylePlain];
	shirts.viewToPullFrom = kWomenShirts;
	shirts.title = @"Women's Shirts";
	[self.navigationController pushViewController:shirts animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc
{
    [super dealloc];
}

@end
