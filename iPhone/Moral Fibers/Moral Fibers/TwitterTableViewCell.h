//
//  TwitterTableViewCell.h
//  
//
//  Created by Joseph Pintozzi on 7/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwitterTableViewCell : UITableViewCell {
	UILabel *tweet, *info;
}

@property (retain) UILabel *tweet, *info;

@end
