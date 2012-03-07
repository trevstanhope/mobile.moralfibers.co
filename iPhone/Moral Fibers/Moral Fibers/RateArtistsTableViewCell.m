//
//  RateArtistsTableViewCell.m
//  Moral Fibers
//
//  Created by Joseph Pintozzi on 3/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RateArtistsTableViewCell.h"
#import "CCJSONParser.h"

@implementation RateArtistsTableViewCell
@synthesize voteUp, voteDown, artistPic, artistName, designRowId;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        voteUp = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [voteUp setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
		[voteUp addTarget:self action:@selector(voteUp:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:voteUp];
        
        voteDown = [[UIButton alloc] initWithFrame:CGRectMake(0, 30, 30, 30)];
        [voteDown setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
		[voteDown addTarget:self action:@selector(voteDown:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:voteDown];
        
        artistName = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 220, 30)];
        [self addSubview:artistName];
		
		artistPic = [[UIImageView alloc] initWithFrame:CGRectMake(30, 0, 60, 60)];
		[self addSubview:artistPic];
    }
    return self;
}

-(void)voteUp:(id)sender{
	NSLog(@"Voting up!");
	[self voteOnDesign:1];
}

-(void)voteDown:(id)sender{
	NSLog(@"Voting up!");
	[self voteOnDesign:-1];
}

-(void)voteOnDesign:(int)vote{
	NSMutableString *voteUrl = [NSMutableString stringWithString:kVoteURL];
	//making sure we encode our UDID
	[voteUrl appendFormat:@"?vote=%@&UDID=%@&design=%@", [[NSString stringWithFormat:@"%i", vote] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding], [[[UIDevice currentDevice] uniqueIdentifier] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding], designRowId];
	NSLog(@"Connecting to %@", voteUrl);
	
	//get our response
	NSString *response = [[NSString alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:voteUrl]] encoding:NSUTF8StringEncoding];
	NSDictionary *responseDict = [CCJSONParser objectFromJSON:response];
	//check our json for an error
	if ([responseDict objectForKey:@"error"]) {
		[[[[UIAlertView alloc] initWithTitle:@"Error" message:[responseDict objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease] show];
		return;
	}
	[[[[UIAlertView alloc] initWithTitle:@"Success" message:[responseDict objectForKey:@"result"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease] show];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [super dealloc];
}

@end
