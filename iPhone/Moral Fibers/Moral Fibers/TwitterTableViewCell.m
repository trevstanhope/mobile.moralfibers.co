//
//  TwitterTableViewCell.m
//  
//
//  Created by Joseph Pintozzi on 7/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TwitterTableViewCell.h"

@implementation TwitterTableViewCell
@synthesize tweet, info;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
		tweet = [[[UILabel alloc] initWithFrame:CGRectMake(45, 0, 275, 30)] autorelease];
		[tweet setFont:[UIFont systemFontOfSize:13.0f]];
		[tweet setMinimumFontSize:8.0f];
		[tweet setNumberOfLines:2];
		[self addSubview:tweet];
		
		info = [[[UILabel alloc] initWithFrame:CGRectMake(45, 33, 270, 10)] autorelease];
		[info setFont:[UIFont systemFontOfSize:10.0f]];
		[info setMinimumFontSize:8.0f];
		[info setNumberOfLines:1];
		[info setTextAlignment:UITextAlignmentRight];
		[info setTextColor:[UIColor grayColor]];
		[self addSubview:info];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
