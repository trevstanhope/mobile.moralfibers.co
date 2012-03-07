//
//  RateArtistsTableViewCell.h
//  Moral Fibers
//
//  Created by Joseph Pintozzi on 3/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kVoteURL		@"http://moralfibers.net/iphone/vote.php"

@interface RateArtistsTableViewCell : UITableViewCell {
    UIButton *voteUp, *voteDown;
    UILabel *artistName;
    UIImageView *artistPic;
	NSString *designRowId;
}

@property (retain) UIButton *voteUp, *voteDown;
@property (retain) UILabel *artistName;
@property (retain) UIImageView *artistPic;
@property (retain) NSString *designRowId;

-(void)voteOnDesign:(int)vote;

@end
